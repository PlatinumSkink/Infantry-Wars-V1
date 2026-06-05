extends Node2D

@onready var small_sprite: Sprite2D = $SmallSprite
@onready var small_label: Label = $SmallLabel
@onready var big_sprite: Sprite2D = $BigSprite
@onready var big_label: Label = $BigLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	big_sprite.visible = false
	big_label.visible = false
	visible = false

func _process(delta: float) -> void: #TODO: Don't do this every frame.
	var zoom = get_viewport().get_camera_2d().zoom.x
	if zoom < 1:
		big_sprite.visible = true
		big_label.visible = true
		small_sprite.visible = false
		small_label.visible = false
	else:
		small_sprite.visible = true
		small_label.visible = true
		big_sprite.visible = false
		big_label.visible = false

func set_health(exact_health: int):
	var hp: float = float(exact_health) / 10
	var fullHp: int = ceil(hp)
	visible = fullHp < 10 && 0 < fullHp
	if visible:
		small_label.text = str(fullHp) 
