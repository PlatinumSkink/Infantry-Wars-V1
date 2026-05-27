class_name PaintableMap
extends Node2D

@onready var tile_map_layer: TileMapLayer = $TerrainMap
@onready var cover_map: TileMapLayer = $CoverMap
@onready var cover_type_map: TileMapLayer = $CoverTypeMap

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
func get_cover_dictionary():
	var coverDictionary = {}
	
	var coverTypeSet: TileSet = cover_type_map.tile_set
	var i: int = 0
	for row in tile_map:
		var j: int = 0
		for tile in row:
			var currentCell = Vector2(i,j)
			var cell: TileData = cover_map.get_cell_tile_data(currentCell)
			if cell != null:
				#let's see.
				var cover: int = cell.terrain
				var cellType: TileData = cover_type_map.get_cell_tile_data(currentCell)
				var coverType: int = cellType.terrain
				
				# Value. I have the x and y. Top left of any tile is their coordinates * 2.
				var x: int = j * 2
				var y: int = i * 2
				
				pass
			j += 1
		i += 1

# Return an array of all places to place cover.
# Assume 0,0 is top left. 
func get_direction_array_from_cell_type(cover: int):
	var coverSet: TileSet = cover_map.tile_set
	var terrain_name: String = coverSet.get_terrain_name(0, cover)
	match terrain_name:
		"Left":
			pass
		"Right":
			pass
		"Up":
			pass
		"Down":
			pass
		"LeftRight":
			pass
		"UpDown":
			pass
		"RightDown":
			pass
		"LeftDown":
			pass
		"LeftUp":
			pass
		"RightUp":
			pass
		"UpOpen":
			pass
		"RightOpen":
			pass
		"DownOpen":
			pass
		"LeftOpen":
			pass
		"Box":
			pass
		"SE":
			pass
		"NE":
			pass
		"NW":
			pass
		"SW":
			pass
		"SENW":
			pass
		"NESW":
			pass
		"SENE":
			pass
		"SESW":
			pass
		"NWSW":
			pass
		"NENW":
			pass
		"OpenNW":
			pass
		"OpenNE":
			pass
		"OpenSE":
			pass
		"OpenSW":
			pass
		"Diagonal Box":
			pass
