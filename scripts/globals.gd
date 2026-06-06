class_name Global
extends Node

enum Factions {
	None,
	Red,
	Blue,
	White,
	Yellow,
	Green,
	Purple,
}

enum Units {
	Rifle,
	Shock,
	Armor,
	Bazooka,
	Sentry,
	Scout,
	Medic,
	Engineer,
	Flamethrower,
	Mortar,
	Sniper,
	Grenadier,
	Missile,
	Shield,
	Commando,
	Ghillie,
	Anti_Air,
	Artillery,
	Light_Tank,
	Heavy_Tank,
	LUV,
	APC,
	IFV,
	Fighter,
	Bomber,
	Gunship,
	T_Copter,
}

enum Terrain {
	Forest = 0,
	Grass = 1,
	Indoors = 2,
	Mud = 3,
	Road = 4,
	Rock = 5,
	Ruins = 6,
	Sand = 7,
	TallGrass = 8,
	Thicket = 9,
	Trench = 10,
	Wasteland = 11,
	Water = 12,
}

enum Cover {
	Fence,
	StoneWall,
	Sandbags,
	Bush,
	IndoorWall,
	GlassWindow,
	Door,
	ReinforcedWall,
}

# Left, Right, Up, Down
# SE, NE, NW, SW
enum Direction {
	Left,
	Right,
	Up,
	Down,
	SE,
	NE,
	NW,
	SW,
}

func GetDirectionCoordinateString(direction: String) -> Vector2:
	match direction:
		"Left":  return Vector2(0,1)
		"Right": return Vector2(2,1)
		"Up": return Vector2(1,0)
		"Down": return Vector2(1,2)
		"SE": return Vector2(2,2)
		"NE": return Vector2(2,0)
		"NW": return Vector2(0,0)
		"SW": return Vector2(0,2)
	assert(false, "not applicable direction")
	return Vector2(0,0)

func GetDirectionCoordinate(direction: Direction) -> Vector2:
	match direction:
		Direction.Left:  
			return Vector2(0,1)
		Direction.Right: 
			return Vector2(2,1)
		Direction.Up:   
			return Vector2(1,0)
		Direction.Down: 
			return Vector2(1,2)
		Direction.SE:  
			return Vector2(2,2)
		Direction.NE:  
			return Vector2(2,0)
		Direction.NW:  
			return Vector2(0,0)
		Direction.SW:  
			return Vector2(0,2)
	assert(false, "not applicable direction")
	return Vector2(0,0)

func GetDirectionName(direction: Direction) -> String:
	match direction:
		Direction.Left:  
			return "Left"
		Direction.Right: 
			return "Right"
		Direction.Up:   
			return "Up"
		Direction.Down: 
			return "Down"
		Direction.SE:  
			return "SE"
		Direction.NE:  
			return "NE"
		Direction.NW:  
			return "NW"
		Direction.SW:  
			return "SW"
	assert(false, "not applicable direction")
	return ""
	
enum MovementType {
	Foot,
	Wheel,
	Treads,
	Flying,
}

enum AIStyle {
	Inexperienced,
	Aggressive,
	Defensive,
	Balanced,
	Veteran,
}
