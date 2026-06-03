class_name Unit
extends Node2D

var health: int = 100
var moved: bool = false
var faction: Globals.Factions = Globals.Factions.None

@export var unit_type: Globals.Units
@export var cost: int
@export var movement: int
@export var attack_move: int
@export var minimum_range: int = 0
@export var weapon_range: int
@export var ammo: int
@export var size: int
@export var vision: int
@export var can_damage_items: bool
@export var damage_table: Dictionary[Globals.Units, int]
@export var use_ammo_when_targetting: Dictionary[Globals.Units, bool]

func get_damage(target: Globals.Units) -> float:
	var hp: float = float(health) / 10
	var fullHp: int = ceil(hp)
	return damage_table[target] * float(fullHp) / 10.0
