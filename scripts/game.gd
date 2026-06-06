extends Node2D

var turn: int = 0
var player_turn: int = 0

@onready var generated_map: Node2D = $GeneratedMap


func _on_generated_map_clicked_on_nothing() -> void:
	# Show a menu.
	pass # Replace with function body.
