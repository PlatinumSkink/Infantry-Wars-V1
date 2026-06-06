extends Node2D

signal clicked_on_nothing

@onready var camera: TileCamera = $Camera

var map_width: int = 0
var map_height: int = 0
var map_width_pixels: int = 0
var map_height_pixels: int = 0
var tile_map = []
var cover_map = {}
var unit_map = {}
var unit_array = []
var control_point_map = {}
var faction_list_in_order: Array[Faction]
var faction_index_dictionary: Dictionary[Globals.Factions, int]

var pixels: int = 128

@onready var zone: Sprite2D = $Zone
@onready var map_generator: Node2D = $MapGenerator

const TEST_MAP = preload("uid://duvdr268m838v")
const UNIT_TEST_MAP = preload("uid://db1e3j1mvfxul")
const MAP_BASE = preload("uid://cqejh2ix2btba")

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
	map_generator.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var mousePos: Vector2 = get_global_mouse_position()
	var x = floorf(mousePos.x / pixels)
	var y = floorf(mousePos.y / pixels)
	if is_in_bounds(x, y):
		zone.visible = true
		zone.position = Vector2(x * pixels, y * pixels)
	else:
		zone.visible = false
	
func get_mouse_grid_coordinate() -> Vector2:
	var mousePos: Vector2 = get_global_mouse_position()
	var x = floorf(mousePos.x / pixels)
	var y = floorf(mousePos.y / pixels)
	return Vector2(x, y)

func is_in_bounds(x: int, y: int) -> bool:
	return x < map_width && y < map_height && x > -1 && y > -1


func _input(event: InputEvent) -> void: # When an action happened.
	if event.is_action_pressed("click"):
		var clicked_something: bool = false
		var grid_pos = get_mouse_grid_coordinate()
		print("grid_pos: " + str(grid_pos))
		if is_in_bounds(grid_pos.x, grid_pos.y):
			var terrain = tile_map[grid_pos.y][grid_pos.x]
			print("terrain: " + str(terrain.terrain_type))
			get_tile_cover(grid_pos)
		
		if !clicked_something:
			clicked_on_nothing.emit()
	
	if event.is_action_pressed("escape"):
		get_tree().quit()

func get_tile_cover(grid_pos):
	var cover_grid_pos: Vector2 = grid_pos * 2 # tile 1,1 is actually 2,2 in cover world.
	for direction in Globals.Direction:
		var coordinate: Vector2 = Globals.GetDirectionCoordinateString(direction)
		var final_pos: Vector2 = cover_grid_pos + coordinate
		if cover_map.has(final_pos):
			var cover: Cover = cover_map[final_pos]
			print("Has " + cover.cover_name + " in direction " + direction)
