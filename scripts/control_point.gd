extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var zone: Sprite2D = $Zone

var size: int = 2:
	set(value):
		faction = value
		if value == 2:
			zone.texture = load("uid://chgqpxehi7tfd")
		elif value == 3:
			zone.texture = load("uid://cerxfwe6g4m30")
		else:
			assert(false, "size 2 or 3 only")
	
var faction: Globals.Factions:
	set(value):
		set_color(value)
		faction = value
		
func _ready() -> void:
	faction = Globals.Factions.None

func set_color(value):
	print("setting color to " + str(value))
	match value:
		Globals.Factions.None:
			sprite_2d.modulate = Color.DARK_GRAY
			zone.modulate = Color.DARK_GRAY
		Globals.Factions.Red:
			sprite_2d.modulate = Color.RED
			zone.modulate = Color.RED
		Globals.Factions.Blue:
			sprite_2d.modulate = Color.BLUE
			zone.modulate = Color.BLUE
		Globals.Factions.White:
			sprite_2d.modulate = Color.WHITE
			zone.modulate = Color.WHITE
		Globals.Factions.Yellow:
			sprite_2d.modulate = Color.YELLOW
			zone.modulate = Color.YELLOW
		Globals.Factions.Green:
			sprite_2d.modulate = Color.GREEN
			zone.modulate = Color.GREEN
		Globals.Factions.Purple:
			sprite_2d.modulate = Color.PURPLE
			zone.modulate = Color.PURPLE
