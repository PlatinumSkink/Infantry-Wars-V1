extends Node2D

var turn: int = 0
var player_turn: int = 0

@onready var generated_map: Node2D = $GeneratedMap
@onready var anywhere_menu: Node2D = $CanvasLayer/AnywhereMenu


func _on_generated_map_clicked_on_nothing() -> void:
	anywhere_menu.show_menu()
