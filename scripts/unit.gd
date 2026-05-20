class_name Unit
extends Node2D

var health: int = 100
var moved: bool = false

@export var unit_type: Globals.Units
@export var movement: int
@export var attack_move: int
@export var weapon_range: int
@export var ammo: int
@export var damage_table: Dictionary[Globals.Units, int]

func get_damage(target: Globals.Units) -> float:
	var hp: float = float(health) / 10
	var fullHp: int = ceil(hp)
	return damage_table[target] * float(fullHp) / 10.0
