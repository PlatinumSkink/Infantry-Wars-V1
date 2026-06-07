class_name TileCamera
extends Node2D

@onready var camera_2d: Camera2D = $Camera2D
@export var camera_speed: int = 1200

var map_width_pixels: int = 0
var map_height_pixels: int = 0

var pixels: int = 128

var camera_position_x: float = 0:
	set(value):
		camera_position_x = value
		position.x = camera_position_x

var camera_position_y: float = 0:
	set(value):
		camera_position_y = value
		position.y = camera_position_y

var viewport_size
var twenty_percent_of_width
var zoomed_viewport_size

func setup(map_width: int, map_height: int) -> void:
	map_width_pixels = map_width
	map_height_pixels = map_height
	camera_position_x = horizontal_middle()
	camera_position_y = vertical_middle()
	viewport_size = get_viewport_rect().size
	twenty_percent_of_width = viewport_size / 5
	zoomed_viewport_size = viewport_size / camera_2d.zoom


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.controlMode != Globals.ControlMode.PlayerTurn:
		return
	var viewportMousePos: Vector2 = get_viewport().get_mouse_position()
	
	if map_wider_than_viewport():
		if mouse_close_to_left_edge(viewportMousePos):
			camera_position_x -= horizontal_camera_speed(delta)
			if camera_about_to_go_outside_left():
				camera_position_x = camera_not_outside_left()
		if mouse_close_to_right_edge(viewportMousePos):
			camera_position_x += horizontal_camera_speed(delta)
			if camera_about_to_go_outside_right():
				camera_position_x = camera_not_outside_right()
	else:
		camera_position_x = horizontal_middle()
	if map_taller_than_viewport():
		if mouse_close_to_top_edge(viewportMousePos):
			camera_position_y -= vertical_camera_speed(delta)
			if camera_about_to_go_outside_top():
				camera_position_y = camera_not_outside_top()
		if mouse_close_to_bottom_edge(viewportMousePos):
			camera_position_y += vertical_camera_speed(delta)
			if camera_about_to_go_outside_bottom():
				camera_position_y = camera_not_outside_bottom()
	else:
		camera_position_y = vertical_middle()

func map_wider_than_viewport() -> bool:
	return zoomed_viewport_size.x < map_width_pixels
func map_taller_than_viewport() -> bool:
	return zoomed_viewport_size.y < map_height_pixels
func mouse_close_to_left_edge(viewportMousePos: Vector2) -> bool:
	return viewportMousePos.x < twenty_percent_of_width.x
func mouse_close_to_right_edge(viewportMousePos: Vector2) -> bool:
	return viewportMousePos.x > viewport_size.x - twenty_percent_of_width.x
func mouse_close_to_top_edge(viewportMousePos: Vector2) -> bool:
	return viewportMousePos.y < twenty_percent_of_width.y
func mouse_close_to_bottom_edge(viewportMousePos: Vector2) -> bool:
	return viewportMousePos.y > viewport_size.y - twenty_percent_of_width.y
func horizontal_camera_speed(delta: float) -> float:
	return camera_speed / camera_2d.zoom.x * delta
func vertical_camera_speed(delta: float) -> float:
	return camera_speed / camera_2d.zoom.y * delta
func camera_about_to_go_outside_top():
	return camera_position_y < zoomed_viewport_size.y / 2
func camera_about_to_go_outside_bottom():
	return camera_position_y + zoomed_viewport_size.y / 2 > map_height_pixels
func camera_about_to_go_outside_left():
	return camera_position_x < zoomed_viewport_size.x / 2
func camera_about_to_go_outside_right():
	return camera_position_x + zoomed_viewport_size.x / 2 > map_width_pixels
func camera_not_outside_left() -> float:
	return zoomed_viewport_size.x / 2
func camera_not_outside_right() -> float:
	return map_width_pixels - zoomed_viewport_size.x / 2
func camera_not_outside_top() -> float:
	return zoomed_viewport_size.y / 2
func camera_not_outside_bottom() -> float:
	return map_height_pixels - zoomed_viewport_size.y / 2
func vertical_middle() -> float:
	return map_height_pixels / 2 # middle
func horizontal_middle() -> float:
	return map_width_pixels / 2 # middle

var zoom_minimum = Vector2(.1, .1) 
var zoom_maximum = Vector2(2.5, 2.5)
var zoom_speed = Vector2(.5, .5)

func _input(event: InputEvent) -> void: # When an action happened.	
	if event.is_action_pressed("zoom_in"):
		if camera_2d.zoom > zoom_minimum:
			camera_2d.zoom -= zoom_speed
			zoomed_viewport_size = viewport_size / camera_2d.zoom
			
	if event.is_action_pressed("zoom_out"):
		if camera_2d.zoom < zoom_maximum:
			camera_2d.zoom += zoom_speed
			zoomed_viewport_size = viewport_size / camera_2d.zoom
