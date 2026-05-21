extends Node2D

const FOREST = preload("uid://be4iwn1f0j2je")
const GRASS = preload("uid://da2ghdo6bn4uo")
const INDOORS = preload("uid://bnj7g3m07pa8d")
const MUD = preload("uid://cw80y7sg026sc")
const ROAD = preload("uid://bbiva72diusye")
const ROCK = preload("uid://be4ale1rsdgd1")
const RUINS = preload("uid://clr0vwyj1wc2s")
const SAND = preload("uid://b16aro6npg8l5")
const TALL_GRASS = preload("uid://usy0j13ucyby")
const THICKET = preload("uid://4u5ytx5altwk")
const TRENCH = preload("uid://bo7oe1pauol3d")
const WASTELAND = preload("uid://dmk0ogaalafow")
const WATER = preload("uid://clov3pgyy2heg")

var terrain_dictionary: Dictionary[Globals.Terrain, Resource] = {
	Globals.Terrain.Forest: FOREST,
	Globals.Terrain.Grass: GRASS,
	Globals.Terrain.Indoors: INDOORS,
	Globals.Terrain.Mud: MUD,
	Globals.Terrain.Road: ROAD,
	Globals.Terrain.Rock: ROCK,
	Globals.Terrain.Ruins: RUINS,
	Globals.Terrain.Sand: SAND,
	Globals.Terrain.TallGrass: TALL_GRASS,
	Globals.Terrain.Thicket: THICKET,
	Globals.Terrain.Trench: TRENCH,
	Globals.Terrain.Wasteland: WASTELAND,
	Globals.Terrain.Water: WATER,
}

var test_map = [
	[1, 1, 1],
	[2, 1, 0],
	[1, 1, 1],
]
var map_width: int = 0
var map_height: int = 0
var tile_map = []

var pixels: int = 128

@onready var zone: Sprite2D = $Zone

func _ready() -> void:
	build_map(test_map)

func build_map(map) -> void:
	map_height = len(map)
	map_width = len(map[0])
	var y: int = 0
	for row in map:
		var x: int = 0
		var new_row = []
		for tile in row:
			var resource = terrain_dictionary[tile]
			var instance = resource.instantiate()
			instance.position = Vector2(x * pixels, y * pixels)
			add_child(instance)
			new_row.append(instance)
			x += 1
		y += 1
		tile_map.append(new_row)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var mousePos: Vector2 = get_global_mouse_position()
	var x = floorf(mousePos.x / pixels)
	var y = floorf(mousePos.y / pixels)
	#if is_in_bounds(x, y):
	zone.position = Vector2(x * pixels, y * pixels)
	#else:
		#zone.position.x = -500

func get_mouse_grid_coordinate() -> Vector2:
	var mousePos: Vector2 = get_global_mouse_position()
	var x = floorf(mousePos.x / pixels)
	var y = floorf(mousePos.y / pixels)
	return Vector2(x, y)

func is_in_bounds(x: int, y: int) -> bool:
	return x < map_width && y < map_height && x > -1 && y > -1
	

func _input(event) -> void: # When an action happened.
	if event.is_action_pressed("click"):
		var grid_pos = get_mouse_grid_coordinate()
		if is_in_bounds(grid_pos.x, grid_pos.y):
			var terrain = tile_map[grid_pos.x][grid_pos.y]
			print("terrain: " + str(terrain.terrain_type))
		
	if event.is_action_pressed("escape"):
		get_tree().quit()
