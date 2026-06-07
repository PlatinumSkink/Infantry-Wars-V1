extends Node2D

@onready var button: Button = $Button
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

var size: Vector2

func _ready() -> void:
	size = collision_shape_2d.shape.size

func set_text(text: String) -> void:
	button.text = text

func _on_button_mouse_entered() -> void:
	button.modulate.v = 1.5

func _on_button_mouse_exited() -> void:
	button.modulate.v = 1

func _on_button_button_down() -> void:
	button.modulate = Color.RED

func _on_button_button_up() -> void:
	button.modulate = Color.WHITE
