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

const CONTROL_POINT = preload("uid://cb2ilvj7cx761")
const ENTRY_CONTROL_POINT = preload("uid://dq2nu0ffdw73g")
const FORWARD_OPERATING_BASE = preload("uid://ca0p4w1ggi5qj")

const ANTI_AIR = preload("uid://xiubgnwkmmpi")
const APC = preload("uid://ba5bml02x1cxc")
const ARMOR = preload("uid://cahqaibmt0gm4")
const ARTILLERY = preload("uid://cmtl1tkrhv26s")
const BAZOOKA = preload("uid://lc48o41qfe6x")
const BOMBER = preload("uid://cuipds3mlanyq")
const COMMANDO = preload("uid://c4baj12tdypbo")
const ENGINEER = preload("uid://b1t0idnq58bdy")
const FIGHTER = preload("uid://bs7qtiigyypwf")
const FLAMETHROWER = preload("uid://cdt1bd544qu4d")
const GHILLIE = preload("uid://dfi1dvglpthaw")
const GRENADIER = preload("uid://c5icua4nvkyf7")
const GUNSHIP = preload("uid://6r12b1kq1yfe")
const HEAVY_TANK = preload("uid://bsmo4hsikorxn")
const IFV = preload("uid://dqi41ohqum6rw")
const LIGHT_TANK = preload("uid://bp6i7b3eolh4x")
const LUV = preload("uid://dmfbxsmm0nud1")
const MEDIC = preload("uid://c8tkbkqn72x0p")
const MISSILE = preload("uid://c3f6gq4qsfx6o")
const MORTAR = preload("uid://dmyg2v1yusxl2")
const RIFLE = preload("uid://ge3bdiq4hfyq")
const SCOUT = preload("uid://bduvgxm4kpj2b")
const SENTRY = preload("uid://8tlv4d5lgy5v")
const SHIELD = preload("uid://d1328o3fxjdm5")
const SHOCK = preload("uid://djhs76ikk3xmc")
const SNIPER = preload("uid://dhn37niv4hybq")
const T_COPTER = preload("uid://ce4xd8xmu1tu2")

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
var unit_dictionary: Dictionary[String, Resource] = {
	"Rifle": RIFLE,
	"Shock": SHOCK,
	"Armor": ARMOR,
	"Bazooka": BAZOOKA,
	"Sentry": SENTRY,
	"Scout": SCOUT,
	"Medic": MEDIC,
	"Engineer": ENGINEER,
	"Flamethrower": FLAMETHROWER,
	"Mortar": MORTAR,
	"Sniper": SNIPER,
	"Grenadier": GRENADIER,
	"Missile": MISSILE,
	"Shield": SHIELD,
	"Commando": COMMANDO,
	"Ghillie": GHILLIE,
	"Anti-Air": ANTI_AIR,
	"Artillery": ARTILLERY,
	"Light Tank": LIGHT_TANK,
	"Heavy Tank": HEAVY_TANK,
	"LUV": LUV,
	"APC": APC,
	"IFV": IFV,
	"Fighter": FIGHTER,
	"Bomber": BOMBER,
	"Gunship": GUNSHIP,
	"T. Copter": T_COPTER,
}
var control_point_dictionary: Dictionary[String, Resource] = {
	"FOB2": FORWARD_OPERATING_BASE,
	"FOB3": FORWARD_OPERATING_BASE,
	"EP2": ENTRY_CONTROL_POINT,
	"EP3": ENTRY_CONTROL_POINT,
	"P2": CONTROL_POINT,
	"P3": CONTROL_POINT,
}

var control_point_size_dictionary: Dictionary[String, int] = {
	"FOB2": 2,
	"FOB3": 3,
	"EP2": 2,
	"EP3": 3,
	"P2": 2,
	"P3": 3,
}

var faction_dictionary: Dictionary[String, Globals.Factions] = {
	"Red": Globals.Factions.Red,
	"Blue": Globals.Factions.Blue,
	"White": Globals.Factions.White,
	"Yellow": Globals.Factions.Yellow,
	"Green": Globals.Factions.Green,
	"Purple": Globals.Factions.Purple,
	"None": Globals.Factions.None,
}

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

func build(map: Resource):
	var instance: PaintableMap = map.instantiate()
	var parent = get_parent()
	add_child(instance)
	make_factions(instance.factions)
	build_map(instance.get_array())
	build_cover(instance.get_cover_dictionary())
	build_control_points(instance.get_control_point_dictionary(), instance.get_control_point_faction_dictionary())
	build_units(instance.get_unit_dictionary(), instance.get_unit_faction_dictionary())
	instance.queue_free()

func make_factions(factions):
	var i := 0
	for faction in factions:
		faction_list_in_order.append(faction)
		faction_index_dictionary[faction.faction] = i
		i += 1

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
			get_parent().add_child(instance)
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
		instance.position.x = (vector.x) * pixels / 2
		instance.position.y = (vector.y) * pixels / 2
		var directions = Vector2(coverItem.direction.x -1, coverItem.direction.y -1)
		directions += instance.position
		instance.set_direction(directions)
		get_parent().add_child(instance)
		cover_map[vector] = instance

func build_control_points(point_dictionary: Dictionary[Vector2, String], point_faction_dictionary: Dictionary[Vector2, String]):
	for vector in point_dictionary:
		var string = point_dictionary[vector]
		var size = control_point_size_dictionary[string]
		var resource = control_point_dictionary[string]
		var faction_string = point_faction_dictionary[vector]
		var faction = faction_dictionary[faction_string]
		if !faction_index_dictionary.has(faction):
			faction = Globals.Factions.None
		var instance = resource.instantiate()
		print(string + " at " + str(vector) + " faction is " + str(faction))
		get_parent().add_child(instance)
		instance.size = size
		instance.faction = faction
		control_point_map[vector] = instance
		if size == 2:
			instance.position.x = vector.x * pixels + pixels
			instance.position.y = vector.y * pixels
		elif size == 3:
			instance.position.x = vector.x * pixels + pixels / 2
			instance.position.y = vector.y * pixels + pixels / 2
		else:
			assert(false, "size other than 2 or 3")

func build_units(vector_unit_dictionary: Dictionary[Vector2, String], unit_faction_dictionary: Dictionary[Vector2, String]):
	for vector in vector_unit_dictionary:
		if !unit_faction_dictionary.has(vector):
			continue
		var string = vector_unit_dictionary[vector]
		var resource = unit_dictionary[string]
		var faction_string = unit_faction_dictionary[vector]
		var faction = faction_dictionary[faction_string]
		if !faction_index_dictionary.has(faction):
			continue # Don't put units of factions that aren't in the map.
		var instance = resource.instantiate()
		#print(string + " at " + str(vector) + " faction is " + str(faction))
		get_parent().add_child(instance)
		var size = instance.size
		instance.faction = faction
		unit_map[vector] = instance
		unit_array.append(instance)
		if size == 1:
			instance.position.x = vector.x * pixels + pixels / 2
			instance.position.y = vector.y * pixels + pixels / 2
		elif size == 2:
			instance.position.x = vector.x * pixels + pixels
			instance.position.y = vector.y * pixels + pixels
		elif size == 3:
			instance.position.x = vector.x * pixels + pixels + pixels / 2
			instance.position.y = vector.y * pixels + pixels + pixels / 2
		else:
			assert(false, "size other than 1, 2 or 3")
