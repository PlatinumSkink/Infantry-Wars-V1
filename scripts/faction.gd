class_name Faction
extends Resource

@export var faction: Globals.Factions
@export var commander: Commander
@export var funds: int
@export var team: int # Characters with the same "team" will be allies.
@export var player_controlled: bool
@export var ai_style: Globals.AIStyle
