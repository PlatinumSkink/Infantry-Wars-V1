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
	if Globals.controlMode != Globals.ControlMode.AnywhereMenu:
		return
	commanders_button_pressed.emit()
	get_viewport().set_input_as_handled()

func _status_button():
	print("status")
	if Globals.controlMode != Globals.ControlMode.AnywhereMenu:
		return
	status_button_pressed.emit()
	get_viewport().set_input_as_handled()

func _options_button():
	print("options")
	if Globals.controlMode != Globals.ControlMode.AnywhereMenu:
		return
	options_button_pressed.emit()
	get_viewport().set_input_as_handled()

func _save_button():
	print("save")
	if Globals.controlMode != Globals.ControlMode.AnywhereMenu:
		return
	save_button_pressed.emit()
	get_viewport().set_input_as_handled()

func _end_turn_button():
	print("end turn")
	if Globals.controlMode != Globals.ControlMode.AnywhereMenu:
		return
	end_turn_button_pressed.emit()
	get_viewport().set_input_as_handled()
	
func show_menu():
	if Globals.controlMode != Globals.ControlMode.PlayerTurn:
		return
	
	Globals.controlMode = Globals.ControlMode.AnywhereMenu
	visible = true
	position = get_viewport().get_mouse_position() 
	if position.x + size.x > get_window().content_scale_size.x:
		position.x -= size.x
	if position.y + size.y > get_window().content_scale_size.y:
		position.y -= size.y

func hide_menu():
	Globals.controlMode = Globals.ControlMode.PlayerTurn
	visible = false

func _input(event: InputEvent) -> void: # When an action happened.
	if Globals.controlMode != Globals.ControlMode.AnywhereMenu:
		return
	#if event.is_action_pressed("click") && mouse_not_in_menu():
	#	hide_menu()
	if event.is_action_pressed("undo"):
		hide_menu()

func _unhandled_input(event: InputEvent) -> void:
	if Globals.controlMode != Globals.ControlMode.AnywhereMenu:
		return
	if event.is_action_pressed("click") && mouse_not_in_menu():
		hide_menu()

func mouse_not_in_menu() -> bool:
	var mousePosition: Vector2 = get_viewport().get_mouse_position()
	if mousePosition.x < position.x:
		return true
	if mousePosition.y < position.y:
		return true
	if mousePosition.x > position.x + size.x:
		return true
	if mousePosition.y > position.y + size.y:
		return true
	return false
