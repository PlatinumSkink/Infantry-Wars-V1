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

@onready var camera: Node2D = $Camera
@onready var camera_2d: Camera2D = $Camera/Camera2D
@export var camera_speed: int = 500

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
	[4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4],
	[2, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
	[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
	[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1],
	[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
	[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
	[1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
	[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
	[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1],
	[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
	[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1],
	[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
	[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1],
	[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
	[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
	[4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4],
]
var map_width: int = 0
var map_height: int = 0
var map_width_pixels: int = 0
var map_height_pixels: int = 0
var tile_map = []

var pixels: int = 128

@onready var zone: Sprite2D = $Zone

var camera_position_x: float = 0:
	set(value):
		camera_position_x = value
		camera.position.x = camera_position_x

var camera_position_y: float = 0:
	set(value):
		camera_position_y = value
		camera.position.y = camera_position_y

func _ready() -> void:
	build_map(test_map)
	var half_map_width = map_width_pixels / 2
	var half_map_height = map_height_pixels / 2
	camera_position_x = half_map_width
	camera_position_y = half_map_height

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
	map_width_pixels = map_width * pixels
	map_height_pixels = map_height * pixels

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mousePos: Vector2 = get_global_mouse_position()
	var viewportMousePos: Vector2 = get_viewport().get_mouse_position()
	var x = floorf(mousePos.x / pixels)
	var y = floorf(mousePos.y / pixels)
	if is_in_bounds(x, y):
		zone.visible = true
		zone.position = Vector2(x * pixels, y * pixels)
	else:
		zone.visible = false
	var viewport_size = get_viewport_rect().size
	var twenty_percent_of_width = viewport_size / 5
	var zoomed_viewport_size = viewport_size / camera_2d.zoom
	if viewport_size.x / camera_2d.zoom.x < map_width_pixels:
		if viewportMousePos.x < twenty_percent_of_width.x:
			camera_position_x -= camera_speed / camera_2d.zoom.x * delta
			if camera_position_x < (viewport_size.x / camera_2d.zoom.x) / 2:
				camera_position_x = (viewport_size.x / camera_2d.zoom.x) / 2
		if viewportMousePos.x > viewport_size.x - twenty_percent_of_width.x:
			camera_position_x += camera_speed / camera_2d.zoom.y * delta
			if camera_position_x + (viewport_size.x / camera_2d.zoom.x) / 2 > map_width_pixels:
				camera_position_x = map_width_pixels - (viewport_size.x / camera_2d.zoom.x) / 2
	else:
		camera_position_x = map_width_pixels / 2 # middle
	if viewport_size.y / camera_2d.zoom.y < map_height_pixels:
		if viewportMousePos.y < twenty_percent_of_width.y:
			camera_position_y -= camera_speed / camera_2d.zoom.y * delta
			if camera_position_y - (viewport_size.y / camera_2d.zoom.y) / 2 < 0:
				camera_position_y = (viewport_size.y / camera_2d.zoom.y) / 2
		if viewportMousePos.y > viewport_size.y - twenty_percent_of_width.y:
			camera_position_y += camera_speed / camera_2d.zoom.y * delta
			if camera_position_y + (viewport_size.y / camera_2d.zoom.y) / 2 > map_height_pixels:
				camera_position_y = map_height_pixels - (viewport_size.y / camera_2d.zoom.y) / 2
	else:
		camera_position_y = map_height_pixels / 2 # middle

func get_mouse_grid_coordinate() -> Vector2:
	var mousePos: Vector2 = get_global_mouse_position()
	var x = floorf(mousePos.x / pixels)
	var y = floorf(mousePos.y / pixels)
	return Vector2(x, y)

func is_in_bounds(x: int, y: int) -> bool:
	return x < map_width && y < map_height && x > -1 && y > -1

var zoom_minimum = Vector2(.1, .1) 
var zoom_maximum = Vector2(2.5, 2.5)
var zoom_speed = Vector2(.5, .5)

func _input(event: InputEvent) -> void: # When an action happened.
	if event.is_action_pressed("click"):
		var grid_pos = get_mouse_grid_coordinate()
		if is_in_bounds(grid_pos.y, grid_pos.x):
			var terrain = tile_map[grid_pos.y][grid_pos.x]
			print("terrain: " + str(terrain.terrain_type))
	
	if event.is_action_pressed("zoom_in"):
		if camera_2d.zoom > zoom_minimum:
			camera_2d.zoom -= zoom_speed
			var viewport_size = get_viewport_rect().size
			print("zoom: " + str(camera_2d.zoom) + ". viewport_size: " + str(viewport_size / camera_2d.zoom) + ". map_size: " + str(map_width_pixels) + "," + str(map_height_pixels))
	
	if event.is_action_pressed("zoom_out"):
		if camera_2d.zoom < zoom_maximum:
			camera_2d.zoom += zoom_speed
			var viewport_size = get_viewport_rect().size
			print("zoom: " + str(camera_2d.zoom) + ". viewport_size: " + str(viewport_size / camera_2d.zoom) + ". map_size: " + str(map_width_pixels) + "," + str(map_height_pixels))

	
	if event.is_action_pressed("escape"):
		get_tree().quit()
