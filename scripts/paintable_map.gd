class_name PaintableMap
extends Node2D

@onready var tile_map_layer: TileMapLayer = $TerrainMap
@onready var cover_map: TileMapLayer = $CoverMap
@onready var cover_type_map: TileMapLayer = $CoverTypeMap
@onready var control_point_map: TileMapLayer = $ControlPointMap
@onready var point_faction_map: TileMapLayer = $PointFactionMap
@onready var unit_layer: TileMapLayer = $UnitLayer
@onready var unit_faction_layer: TileMapLayer = $UnitFactionLayer


var map_width: int = 0
var map_height: int = 0

var tile_map = []
# Left, Right, Up, Down
# SE, NE, NW, SW

func get_array():
	var currentCell = Vector2(0,0)
	var cell: TileData = tile_map_layer.get_cell_tile_data(currentCell)
	var tileSet: TileSet = tile_map_layer.tile_set
	while cell != null:
		var row = []
		while cell != null:
			var terrain: int = cell.terrain
			var terrain_name: String = tileSet.get_terrain_name(0, terrain)
			print("terrain_name: " + terrain_name)
			row.append(terrain_name)
			currentCell.x += 1
			cell = tile_map_layer.get_cell_tile_data(currentCell)
		currentCell.x = 0
		currentCell.y += 1
		tile_map.append(row)
		cell = tile_map_layer.get_cell_tile_data(currentCell)
	
	map_height = len(tile_map)
	map_width = len(tile_map[0])
	return tile_map

# 0 128 256 384 512 640 768 896 1024

# Let's see. The dictionary should take coordinates.
# But the coordinates assumes all tiles are 3,3.
# Top left is 0,0. The border between the tile in the
# top left and the one to the right of it should be
# 2,1. The one diagonally down-right from the tile two
# tiles to the right of the tile in the top-left should be
# 0,1,2|3,4|5,6 yes 6,2.
# The items are saved in 
func get_cover_dictionary() -> Dictionary[Vector2, CoverItem]:
	var coverDictionary: Dictionary[Vector2, CoverItem] = {}
	
	var i: int = 0
	for row in tile_map:
		var j: int = 0
		for tile in row:
			var currentCell = Vector2(j,i)
			var cell: TileData = cover_map.get_cell_tile_data(currentCell)
			if cell != null:
				#let's see.
				var cover: int = cell.terrain
				var directionArray: Array[Vector2] = get_direction_array_from_cell_type(cover)
				
				# Value. I have the x and y. Top left of any tile is their coordinates * 2.
				var x: int = j * 2
				var y: int = i * 2

				var coverType = get_cover_type(currentCell)

				for vector in directionArray:
					var coverSpot = Vector2(x + vector.x, y + vector.y)
					var coverItem = CoverItem.create(coverType, vector)
					coverDictionary[coverSpot] = coverItem
			j += 1
		i += 1
	return coverDictionary

func get_cover_type(currentCell) -> Globals.Cover:
	var coverTypeSet: TileSet = cover_type_map.tile_set
	var cellType: TileData = cover_type_map.get_cell_tile_data(currentCell)
	var coverType: int = cellType.terrain
	var coverTypeName: String = coverTypeSet.get_terrain_name(0, coverType)
	return cover_string_dictionary[coverTypeName]


var Left = Vector2(0,1)
var Right = Vector2(2,1)
var Up = Vector2(1,0)
var Down = Vector2(1,2)
var SE = Vector2(2,2)
var NE = Vector2(2,0)
var NW = Vector2(0,0)
var SW = Vector2(0,2)

# Return an array of all places to place cover.
# Assume 0,0 is top left. 
func get_direction_array_from_cell_type(cover: int) -> Array[Vector2]:
	var directionArray: Array[Vector2] = []
	var coverSet: TileSet = cover_map.tile_set
	var terrain_name: String = coverSet.get_terrain_name(0, cover)
	match terrain_name:
		"Left":
			directionArray.append(Left)
		"Right":
			directionArray.append(Right)
		"Up":
			directionArray.append(Up)
		"Down":
			directionArray.append(Down)
		"LeftRight":
			directionArray.append(Left)
			directionArray.append(Right)
		"UpDown":
			directionArray.append(Up)
			directionArray.append(Down)
		"RightDown":
			directionArray.append(Right)
			directionArray.append(Down)
		"LeftDown":
			directionArray.append(Left)
			directionArray.append(Down)
		"LeftUp":
			directionArray.append(Left)
			directionArray.append(Up)
		"RightUp":
			directionArray.append(Right)
			directionArray.append(Up)
		"UpOpen":
			directionArray.append(Left)
			directionArray.append(Right)
			directionArray.append(Down)
		"RightOpen":
			directionArray.append(Left)
			directionArray.append(Up)
			directionArray.append(Down)
		"DownOpen":
			directionArray.append(Left)
			directionArray.append(Right)
			directionArray.append(Up)
		"LeftOpen":
			directionArray.append(Right)
			directionArray.append(Up)
			directionArray.append(Down)
		"Box":
			directionArray.append(Left)
			directionArray.append(Right)
			directionArray.append(Up)
			directionArray.append(Down)
		"SE":
			directionArray.append(SE)
		"NE":
			directionArray.append(NE)
		"NW":
			directionArray.append(NW)
		"SW":
			directionArray.append(SW)
		"SENW":
			directionArray.append(SE)
			directionArray.append(NW)
		"NESW":
			directionArray.append(NE)
			directionArray.append(SW)
		"SENE":
			directionArray.append(SE)
			directionArray.append(NE)
		"SESW":
			directionArray.append(SE)
			directionArray.append(SW)
		"NWSW":
			directionArray.append(NW)
			directionArray.append(SW)
		"NENW":
			directionArray.append(NE)
			directionArray.append(NW)
		"OpenNW":
			directionArray.append(SE)
			directionArray.append(NE)
			directionArray.append(SW)
		"OpenNE":
			directionArray.append(SE)
			directionArray.append(NW)
			directionArray.append(SW)
		"OpenSE":
			directionArray.append(NE)
			directionArray.append(NW)
			directionArray.append(SW)
		"OpenSW":
			directionArray.append(SE)
			directionArray.append(NE)
			directionArray.append(NW)
		"Diagonal Box":
			directionArray.append(SE)
			directionArray.append(NE)
			directionArray.append(NW)
			directionArray.append(SW)
	return directionArray

var cover_string_dictionary: Dictionary[String, Globals.Cover] = {
	"Fence": Globals.Cover.Fence,
	"Stone Wall": Globals.Cover.StoneWall,
	"Sandbags": Globals.Cover.Sandbags,
	"Bush": Globals.Cover.Bush,
	"Indoors Wall": Globals.Cover.IndoorWall,
	"Window": Globals.Cover.GlassWindow,
	"Door": Globals.Cover.Door,
	"Reinforced Wall": Globals.Cover.ReinforcedWall,
}

func get_control_point_dictionary() -> Dictionary[Vector2, String]:
	var controlDictionary: Dictionary[Vector2, String] = {}
	var tileSet: TileSet = control_point_map.tile_set

	var i: int = 0
	for row in tile_map:
		var j: int = 0
		for tile in row:
			var currentCell = Vector2(j,i)
			var cell: TileData = control_point_map.get_cell_tile_data(currentCell)
			if cell != null:
				var control_point: int = cell.terrain
				var control_point_name: String = tileSet.get_terrain_name(0, control_point)
				controlDictionary[currentCell] = control_point_name
			j += 1
		i += 1
	return controlDictionary

func get_control_point_faction_dictionary() -> Dictionary[Vector2, String]:
	var controlFactionDictionary: Dictionary[Vector2, String] = {}
	var tileSet: TileSet = point_faction_map.tile_set

	var i: int = 0
	for row in tile_map:
		var j: int = 0
		for tile in row:
			var currentCell = Vector2(j,i)
			var cell: TileData = point_faction_map.get_cell_tile_data(currentCell)
			if cell != null:
				var faction_point: int = cell.terrain
				var faction_point_name: String = tileSet.get_terrain_name(0, faction_point)
				controlFactionDictionary[currentCell] = faction_point_name
			j += 1
		i += 1
	return controlFactionDictionary

func get_unit_dictionary() -> Dictionary[Vector2, String]:
	var unitDictionary: Dictionary[Vector2, String] = {}
	var tileSet: TileSet = unit_layer.tile_set

	var i: int = 0
	for row in tile_map:
		var j: int = 0
		for tile in row:
			var currentCell = Vector2(j,i)
			var cell: TileData = unit_layer.get_cell_tile_data(currentCell)
			if cell != null:
				var unit: int = cell.terrain
				var unit_name: String = tileSet.get_terrain_name(0, unit)
				unitDictionary[currentCell] = unit_name
			j += 1
		i += 1
	return unitDictionary

func get_unit_faction_dictionary() -> Dictionary[Vector2, String]:
	var unitFactionDictionary: Dictionary[Vector2, String] = {}
	var tileSet: TileSet = unit_faction_layer.tile_set

	var i: int = 0
	for row in tile_map:
		var j: int = 0
		for tile in row:
			var currentCell = Vector2(j,i)
			var cell: TileData = unit_faction_layer.get_cell_tile_data(currentCell)
			if cell != null:
				var unit_faction: int = cell.terrain
				var unit_faction_name: String = tileSet.get_terrain_name(0, unit_faction)
				unitFactionDictionary[currentCell] = unit_faction_name
			j += 1
		i += 1
	return unitFactionDictionary
