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

const BUSH = preload("uid://jvdeijkipisc")
const DOOR = preload("uid://bw31e2c5bbpos")
const FENCE = preload("uid://di0ioxhrxnsc7")
const INDOOR_WALL = preload("uid://c558njtvp0rxr")
const REINFORCED_WALL = preload("uid://c6ayhgndlangs")
const SANDBAGS = preload("uid://d20tjritd3tho")
const STONE_WALL = preload("uid://8rxmxqorrm8m")
const WINDOW = preload("uid://b8x8cl5abj3pw")


@onready var camera: TileCamera = $Camera

var terrain_string_dictionary: Dictionary[String, Globals.Terrain] = {
	"Forest": Globals.Terrain.Forest,
	"Grass": Globals.Terrain.Grass,
	"Indoors": Globals.Terrain.Indoors,
	"Mud": Globals.Terrain.Mud,
	"Road": Globals.Terrain.Road,
	"Rock": Globals.Terrain.Rock,
	"Ruins": Globals.Terrain.Ruins,
	"Sand": Globals.Terrain.Sand,
	"Tall Grass": Globals.Terrain.TallGrass,
	"Thicket": Globals.Terrain.Thicket,
	"Trench": Globals.Terrain.Trench,
	"Wasteland": Globals.Terrain.Wasteland,
	"Water": Globals.Terrain.Water,
}
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
var cover_dictionary: Dictionary[Globals.Cover, Resource] = {
	Globals.Cover.Bush: BUSH, 
	Globals.Cover.Door: DOOR,
	Globals.Cover.Fence: FENCE,
	Globals.Cover.IndoorWall: INDOOR_WALL,
	Globals.Cover.ReinforcedWall: REINFORCED_WALL,
	Globals.Cover.Sandbags: SANDBAGS,
	Globals.Cover.StoneWall: STONE_WALL,
	Globals.Cover.GlassWindow: WINDOW,
}

var map_width: int = 0
var map_height: int = 0
var map_width_pixels: int = 0
var map_height_pixels: int = 0
var tile_map = []

var pixels: int = 128

@onready var zone: Sprite2D = $Zone

@export var new_map: PaintableMap
const TEST_MAP = preload("uid://duvdr268m838v")

func _ready() -> void:
	var instance: PaintableMap = TEST_MAP.instantiate()
	add_child(instance)
	build_map(instance.get_array())
	build_cover(instance.get_cover_dictionary())
	instance.queue_free()
	camera.setup(map_width_pixels, map_height_pixels)
	

func build_map(map) -> void:
	map_height = len(map)
	map_width = len(map[0])
	var y: int = 0
	for row in map:
		var x: int = 0
		var new_row = []
		for tile in row:
			var tile_enum = terrain_string_dictionary[tile]
			var resource = terrain_dictionary[tile_enum]
			var instance = resource.instantiate()
			instance.position = Vector2(x * pixels, y * pixels)
			add_child(instance)
			new_row.append(instance)
			x += 1
		y += 1
		tile_map.append(new_row)
	map_width_pixels = map_width * pixels
	map_height_pixels = map_height * pixels

func build_cover(cover_item_dictionary: Dictionary[Vector2, CoverItem]) -> void:
	for vector in cover_item_dictionary:
		var coverItem = cover_item_dictionary[vector]
		var resourse = cover_dictionary[coverItem.type]
		var instance = resourse.instantiate()
		print("creating " + str(coverItem.type) + " at " + str(vector))
		instance.position.x = (vector.x) * pixels + (pixels / 2) + (coverItem.direction.x / 2 * pixels)
		instance.position.y = (vector.y) * pixels + (pixels / 2) + (coverItem.direction.y / 2 * pixels)
		print("instance.position = " + str(instance.position) + ". coverItem.direction: " + str(coverItem.direction))
		add_child(instance)


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
		var grid_pos = get_mouse_grid_coordinate()
		if is_in_bounds(grid_pos.y, grid_pos.x):
			var terrain = tile_map[grid_pos.y][grid_pos.x]
			print("terrain: " + str(terrain.terrain_type))
	
	if event.is_action_pressed("escape"):
		get_tree().quit()
