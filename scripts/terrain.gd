class_name Terrain
extends Node2D

@export var defense: int = 0
@export var hiding_defense: int = 0
@export var burnable: bool
@export var disbles_attacking: bool
@export var zero_defense_if_in_same_terrain: bool
@export_range(0, 100, 1) var fire_spread_chance: int = 0
@export_group("Movement Cost")
@export var movement_cost: Dictionary[Globals.MovementType, float]
@export var leave_cost: Dictionary[Globals.MovementType, float]
