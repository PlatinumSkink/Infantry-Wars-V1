extends Node2D

@onready var tile_map_layer: TileMapLayer = $Tilemap/TileMapLayer
@onready var zone: Sprite2D = $zone

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var mousePos: Vector2 = get_global_mouse_position()
	var localToMap: Vector2 = tile_map_layer.local_to_map(mousePos)
	var mapToLocal: Vector2 = tile_map_layer.map_to_local(localToMap)
	zone.position = mapToLocal
	#print("localToMap: " + str(localToMap))
	#var atlasCoords: Vector2 = tile_map_layer.get_cell_atlas_coords(localToMap)
	#print("atlasCoords: " + str(atlasCoords)) #It returned where in the sprite-sheet it is.
	var tileData: TileData = tile_map_layer.get_cell_tile_data(localToMap)
	#print("tileData: " + str(tileData))
	if tileData != null:
		pass
		#print("tileData.terrain: " + str(tileData.terrain))

func _input(event) -> void: # When an action happened.
	if event.is_action_pressed("click"):
		var mousePos: Vector2 = get_global_mouse_position()
		var localToMap: Vector2 = tile_map_layer.local_to_map(mousePos)
		var tileData: TileData = tile_map_layer.get_cell_tile_data(localToMap)
		if tileData != null:
			print("tileData.terrain: " + str(tileData.terrain))
			tile_map_layer.set_cell(localToMap, 2, Vector2(0,0))
			
