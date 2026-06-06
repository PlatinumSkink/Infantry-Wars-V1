class_name Unit
extends Node2D

var health: int = 100:
	set(value):
		health = value
		hp_box.set_health(value)
		
var moved: bool = false
var faction: Globals.Factions = Globals.Factions.None:
	set(value):
		faction = value
		set_color(value)
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hp_box: Node2D = $HpBox

@export var unit_type: Globals.Units
@export var cost: int
@export var movement_type: Globals.MovementType
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

func set_color(value):
	match value:
		Globals.Factions.None:
			sprite_2d.modulate = Color.DARK_GRAY
		Globals.Factions.Red:
			sprite_2d.modulate = Color.RED
		Globals.Factions.Blue:
			sprite_2d.modulate = Color.BLUE
		Globals.Factions.White:
			sprite_2d.modulate = Color.WHITE
		Globals.Factions.Yellow:
			sprite_2d.modulate = Color.YELLOW
		Globals.Factions.Green:
			sprite_2d.modulate = Color.GREEN
		Globals.Factions.Purple:
			sprite_2d.modulate = Color.PURPLE
