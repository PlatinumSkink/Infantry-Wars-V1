extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

var faction: Globals.Factions:
	set(value):
		set_color(value)
		faction = value
		
func _ready() -> void:
	faction = Globals.Factions.None

func set_color(value):
	match value:
		Globals.Factions.None:
			sprite_2d.modulate = Color.WEB_GRAY
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
