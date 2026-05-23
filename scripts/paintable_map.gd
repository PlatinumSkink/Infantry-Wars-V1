class_name PaintableMap
extends Node2D

@onready var tile_map_layer: TileMapLayer = $TerrainMap
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
		
	return tile_map

# 0 128 256 384 512 640 768 896 1024
