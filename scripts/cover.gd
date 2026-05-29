class_name Cover
extends Node2D

@export var cover_name: String
@export var defense: int
@export var health: int
@export var movement_cost: int
@export var blocks: bool
@export var destroyable_by_vehicles: bool
@export var can_be_lit_on_fire: bool
@export var burn_chance: int
var direction: Global.Direction

func set_direction(directions):
	self.look_at(directions)
	match directions:
		Vector2(-1,-1):
			direction = Global.Direction.NW
		Vector2(-1,0):
			direction = Global.Direction.Left
		Vector2(-1,1):
			direction = Global.Direction.SW
		Vector2(0,-1):
			direction = Global.Direction.Up
		Vector2(0,1):
			direction = Global.Direction.Down
		Vector2(1,-1):
			direction = Global.Direction.NE
		Vector2(1,0):
			direction = Global.Direction.Right
		Vector2(1,1):
			direction = Global.Direction.SE
