extends Node2D

signal clicked_on_nothing

@onready var camera: TileCamera = $Camera

var map_width: int = 0
var map_height: int = 0
var map_width_pixels: int = 0
var map_height_pixels: int = 0
var tile_map = []
var cover_map: Dictionary[Vector2, Cover] = {}
var unit_map = {}
var unit_array = []
var control_point_map = {}
var faction_list_in_order: Array[Faction]
var faction_index_dictionary: Dictionary[Globals.Factions, int]
var rounds: int = 0
var player_turn: int = 0
var movement_instances: Dictionary[Vector2,Node]

var pixels: int = 128

@onready var zone: Sprite2D = $Zone
@onready var map_generator: Node2D = $MapGenerator
@onready var arrow_placer: Node2D = $ArrowPlacer


const TEST_MAP = preload("uid://duvdr268m838v")
const UNIT_TEST_MAP = preload("uid://db1e3j1mvfxul")
const MAP_BASE = preload("uid://cqejh2ix2btba")
const MOVE_TILE = preload("uid://ceg6mp31q7ya8")

const ARROWHEAD = preload("uid://dkubpl4ax0nwk")
const CORNER = preload("uid://dwoppmpcsevnb")
const STRAIGHT = preload("uid://lflg154o7ep3")


var inactive: bool = false

func _ready() -> void:
	map_generator.build(MAP_BASE)
	map_width = map_generator.map_width
	map_height = map_generator.map_height
	map_width_pixels = map_generator.map_width_pixels
	map_height_pixels = map_generator.map_height_pixels
	tile_map = map_generator.tile_map
	cover_map = map_generator.cover_map
	unit_map = map_generator.unit_map
	unit_array = map_generator.unit_array
	control_point_map = map_generator.control_point_map
	faction_list_in_order = map_generator.faction_list_in_order
	faction_index_dictionary = map_generator.faction_index_dictionary
	camera.setup(map_width_pixels, map_height_pixels)
	for row in tile_map:
		for tile in row:
			var instance = MOVE_TILE.instantiate()
			instance.position = tile.position
			instance.visible = false
			instance.modulate.a = 0.5
			movement_instances[tile.position / pixels] = instance
			add_child(instance)
	map_generator.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Globals.controlMode != Globals.ControlMode.PlayerTurn:
		zone.visible = false
		return
	var mousePos: Vector2 = get_global_mouse_position()
	var x = floorf(mousePos.x / pixels)
	var y = floorf(mousePos.y / pixels)
	if is_in_bounds(x, y):
		zone.visible = true
		zone.position = Vector2(x * pixels, y * pixels)
	else:
		zone.visible = false
	if Globals.controlMode != Globals.ControlMode.UnitSelected:
		draw_arrow()
	
func get_mouse_grid_coordinate() -> Vector2:
	var mousePos: Vector2 = get_global_mouse_position()
	var x = floorf(mousePos.x / pixels)
	var y = floorf(mousePos.y / pixels)
	return Vector2(x, y)

func is_in_bounds(x: int, y: int) -> bool:
	return x < map_width && y < map_height && x > -1 && y > -1


func _input(event: InputEvent) -> void: # When an action happened.
	if event.is_action_pressed("escape"):
		get_tree().quit()
	match Globals.controlMode:
		Globals.ControlMode.PlayerTurn:
			player_turn_click(event)
		Globals.ControlMode.UnitSelected:
			unit_selected_input(event)

func player_turn_click(event: InputEvent):
	if event.is_action_pressed("click"):
		var clicked_something: bool = false
		var grid_pos = get_mouse_grid_coordinate()
		print("grid_pos: " + str(grid_pos))
		if is_in_bounds(grid_pos.x, grid_pos.y):
			var terrain = tile_map[grid_pos.y][grid_pos.x]
			print("terrain: " + str(terrain.terrain_type))
			get_tile_cover(grid_pos)
			if unit_map.has(grid_pos):
				var unit = unit_map[grid_pos]
				if faction_index_dictionary[unit.faction] == player_turn && !unit.moved:
					select_unit(unit, grid_pos)
					clicked_something = true
		
		if !clicked_something:
			clicked_on_nothing.emit()

func get_tile_cover(grid_pos):
	var cover_grid_pos: Vector2 = grid_pos * 2 # tile 1,1 is actually 2,2 in cover world.
	for direction in Globals.Direction:
		var coordinate: Vector2 = Globals.GetDirectionCoordinateString(direction)
		var final_pos: Vector2 = cover_grid_pos + coordinate
		if cover_map.has(final_pos):
			var cover: Cover = cover_map[final_pos]
			print("Has " + cover.cover_name + " in direction " + direction)

var selectedUnit: Unit
var selectedUnitLocation: Vector2

func select_unit(unit: Unit, pos: Vector2):
	print("selected " + str(unit.unit_type))
	Globals.controlMode = Globals.ControlMode.UnitSelected
	
	selectedUnit = unit
	selectedUnitLocation = pos
	
	var total_movement = unit.movement
	var movement_type = unit.movement_type
	var attack_movement = unit.attack_move
	
	var alreadyVisited: Dictionary[Vector2, bool] = {}
	var alreadyChecked: Dictionary[Vector2, bool] = {}
	var distanceTo: Dictionary[Vector2, float] = {}
	var spotList: Array[Vector2] = []
	spotList.append(pos)
	distanceTo[pos] = 0
	
	while len(spotList) > 0:
		var thisSpot = spotList[0]
		spotList.remove_at(0)
		if !alreadyVisited.has(thisSpot):
			movement_instances[thisSpot].visible = true
		alreadyVisited[thisSpot] = true

		for direction in Globals.NSEW:
			var checkedPosition = thisSpot + direction
			if !is_in_bounds(checkedPosition.x, checkedPosition.y):
				continue
			var terrainMoveCost: float = get_move_movement_cost(thisSpot, checkedPosition, movement_type)
			var coverMoveCost: float = get_cover_movement_cost(thisSpot, direction, movement_type)
			var distanceHere: float = distanceTo[thisSpot] + terrainMoveCost + coverMoveCost
			if distanceHere > float(total_movement):
				continue
			if alreadyChecked.has(checkedPosition):
				if distanceTo[checkedPosition] > distanceHere: # Replace with movement cost.
					distanceTo[checkedPosition] = distanceHere
					if !spotList.has(checkedPosition): # place back in list if out of it.
						spotList.append(checkedPosition)
			else:
				distanceTo[checkedPosition] = distanceHere
				spotList.append(checkedPosition)
				alreadyChecked[checkedPosition] = true

func get_move_movement_cost(position1: Vector2, position2: Vector2, movementType: Global.MovementType) -> float:
	var previousTile: Terrain =  tile_map[position1.y][position1.x]
	var tile: Terrain = tile_map[position2.y][position2.x]
	if previousTile.leave_cost.has(movementType):
		return maxf(tile.movement_cost[movementType], previousTile.leave_cost[movementType])
	return tile.movement_cost[movementType]

func get_cover_movement_cost(from: Vector2, direction: Vector2, movementType: Global.MovementType) -> float:
	if movementType == Global.MovementType.Flying:
		return 0 # flying units are unaffected
	from *= 2 # Double the coordinates, then add one.
	from += Vector2(1,1) # No matter the position, the covers are counted from +1+1. 1, 3, 5, 7, 9
	var coverSpot: Vector2 = from + direction
	if cover_map.has(coverSpot):
		var cover: Cover = cover_map[coverSpot]
		if cover.blocks:
			return 99
		return cover_map[coverSpot].movement_cost
	return 0

func draw_arrow():
	pass

func unit_selected_input(event: InputEvent):
	if event.is_action_pressed("click"):
		var mouse_grid_coordinate = get_mouse_grid_coordinate()
		print("trying to astar to " + str(mouse_grid_coordinate) + "!")
		var path = astarWithTerrain(selectedUnitLocation, mouse_grid_coordinate, selectedUnit.movement_type)
		print("path is " + str(path))
		arrow_placer.placeArrows(path)

func astarWithTerrain(from: Vector2, to: Vector2, movementType: Global.MovementType) -> Array[Vector2]:		
	var path: Array[Vector2] = []
	
	if from == to || !is_in_bounds(from.x, from.y) || !is_in_bounds(to.x, to.y):
		path.append(from)
		return path
		
	var nodes: Dictionary[Vector2, MoveNode] = {}
	var nodeList: Array[MoveNode] = []
	var firstNode: MoveNode = MoveNode.new(from, to, 0, from) # We reach the last node when the previous node is the same as this one.
	
	nodes[from] = firstNode
	nodeList.append(firstNode)
		
	while len(nodeList) > 0:
		var node = nodeList[0]
		nodeList.remove_at(0)
		#print("checking " + str(node.position) + ". distance here: " + str(node.steps_here) + ". distance to goal: " + str(node.distance_to_goal) + ". " + str(nodeList.size()) + " items left")
		if node.position == to:
			path = get_astar_path(to, nodes)
			break
		
		for direction in Globals.NSEW:
			var checkedPosition = node.position + direction
			if !is_in_bounds(checkedPosition.x, checkedPosition.y):
				continue
			var terrainMoveCost: float = get_move_movement_cost(node.position, checkedPosition, movementType)
			var coverMoveCost: float = get_cover_movement_cost(node.position, direction, movementType)
			var totalNodeCost = node.steps_here + terrainMoveCost + coverMoveCost
			if nodes.has(checkedPosition):
				#print("we've already been to " + str(checkedPosition) + "! previous distance here is " + str(nodes[checkedPosition].steps_here))
				if nodes[checkedPosition].steps_here <= totalNodeCost:
					#print("new path is " + str(totalNodeCost) + " and longer!")
					continue
				#print("new path is " + str(totalNodeCost) + " and shorter!")
				
			
			var newNode = MoveNode.new(checkedPosition, to, totalNodeCost, node.position)
			nodes[checkedPosition] = newNode
			#print("adding " + str(checkedPosition) + " to nodes with distance " + str(totalNodeCost))
			if !nodeListHas(nodeList, checkedPosition):
				#print("adding to array!")
				nodeList.append(newNode)
			else:
				nodeList = nodeListReplace(nodeList, checkedPosition, newNode)
		
		nodeList.sort_custom(func(a: MoveNode, b: MoveNode): return a.getComputeDistance() < b.getComputeDistance())
	
	return path

func get_astar_path(goal: Vector2, nodes: Dictionary[Vector2, MoveNode]) -> Array[Vector2]:
	var path: Array[Vector2]
	var node: MoveNode = nodes[goal]
	print("we found it")
	while true:
		var thisPosition: Vector2 = node.position
		path.append(thisPosition)
		var previousNode: MoveNode = nodes[node.previous_node]
		if thisPosition == previousNode.position:
			break
		node = nodes[node.previous_node]
	path.reverse()
	return path

func nodeListHas(nodeList: Array[MoveNode], checkedPosition: Vector2) -> bool:
	for node in nodeList:
		if node.position == checkedPosition:
			return true
	return false

func nodeListReplace(nodeList: Array[MoveNode], checkedPosition: Vector2, newNode: MoveNode) -> Array[MoveNode]:
	var index = -1
	for i in range(nodeList.size()):
		var node: MoveNode = nodeList[i]
		if node.position == checkedPosition:
			index = i
			break
	nodeList.remove_at(index)
	nodeList.append(newNode)
	return nodeList
