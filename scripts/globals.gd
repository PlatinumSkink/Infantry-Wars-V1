class_name Global
extends Node


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
	A_Copter,
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

enum MovementType {
	Foot,
	Wheel,
	Treads,
	Flying,
}
