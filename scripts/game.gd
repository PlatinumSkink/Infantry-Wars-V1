extends Node2D

@onready var generated_map: Node2D = $GeneratedMap
@onready var anywhere_menu: Node2D = $CanvasLayer/AnywhereMenu

func _ready():
	Globals.controlMode = Globals.ControlMode.PlayerTurn

func _on_generated_map_clicked_on_nothing() -> void:
	if Globals.controlMode == Globals.ControlMode.PlayerTurn:
		anywhere_menu.show_menu()
