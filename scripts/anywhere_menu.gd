extends Node2D

const ANYWHERE_BUTTON = preload("uid://ro50enygsnku")

signal commanders_button_pressed
signal status_button_pressed
signal options_button_pressed
signal save_button_pressed
signal end_turn_button_pressed

var size: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var i: int = 0
	var commanders_button = ANYWHERE_BUTTON.instantiate()
	add_child(commanders_button)
	commanders_button.set_text("Commanders")
	commanders_button.button.connect("pressed", _commanders_button_pressed)
	var y: int = commanders_button.size.y
	i += 1
	
	var status_button = ANYWHERE_BUTTON.instantiate()
	add_child(status_button)
	status_button.set_text("Status")
	status_button.button.connect("pressed", _status_button)
	status_button.position.y = y * i
	i += 1
	
	var options_button = ANYWHERE_BUTTON.instantiate()
	add_child(options_button)
	options_button.set_text("Options")
	options_button.button.connect("pressed", _options_button)
	options_button.position.y = y * i
	i += 1
	
	var save_button = ANYWHERE_BUTTON.instantiate()
	add_child(save_button)
	save_button.set_text("Safe")
	save_button.button.connect("pressed", _save_button)
	save_button.position.y = y * i
	i += 1
	
	var end_turn_button = ANYWHERE_BUTTON.instantiate()
	add_child(end_turn_button)
	end_turn_button.set_text("End Turn")
	end_turn_button.button.connect("pressed", _end_turn_button)
	end_turn_button.position.y = y * i
	i += 1
	
	size = Vector2(end_turn_button.size.x, end_turn_button.size.y * i)

func _commanders_button_pressed():
	print("commanders")
	commanders_button_pressed.emit()

func _status_button():
	print("status")
	status_button_pressed.emit()

func _options_button():
	print("options")
	options_button_pressed.emit()

func _save_button():
	print("save")
	save_button_pressed.emit()

func _end_turn_button():
	print("end turn")
	end_turn_button_pressed.emit()
	
func show_menu():
	visible = true
	position = get_viewport().get_mouse_position() 
	if position.x + size.x > get_viewport().size.x:
		position.x -= size.x
	if position.y + size.y > get_viewport().size.y:
		position.y -= size.y
