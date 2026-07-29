extends Node2D

const ARROWHEAD = preload("uid://dkubpl4ax0nwk")
const CORNER = preload("uid://dwoppmpcsevnb")
const STRAIGHT = preload("uid://lflg154o7ep3")
const BEGIN = preload("uid://lflg154o7ep3")

@onready var arrows: Array[Sprite2D] = []

func _ready() -> void:
	for i in 50:
		arrows.append(Sprite2D.new())
		arrows[i].visible = false
		add_child(arrows[i])
	
func placeArrows(path: Array[Vector2]):
	print("trying to place arrows")
	hideArrows()
	var previousDirection: Globals.Direction = Globals.Direction.Right
	if path.size() < 2:
		print("less than 2 items, leaving")
		return
	for i in path.size():
		var node = path[i]
		arrows[i].visible = true
		arrows[i].position = node * Globals.pixels
		var half =  Globals.pixels / 2
		arrows[i].position += Vector2(half, half)
		arrows[i].z_index = Globals.ZIndex.ArrowLayer
	for i in path.size():
		var node = path[i]
		if i == path.size()-1: # it is the last one.
			print(str(path[i]) + " is the last one!")
			arrows[i].texture = ARROWHEAD
			var nextTile = Globals.GetDirection(previousDirection) * Globals.pixels
			print("nextTile: " + str(nextTile))
			arrows[i].look_at(arrows[i].position + nextTile)
			break
		if i == 0:
			print(str(path[i]) + " is the first one!")
			arrows[i].texture = BEGIN
			var nextNode: Vector2 = arrows[i+1].position
			arrows[i].look_at(nextNode) # start will look at the first next path.
		elif getArrowDirection(path[i], path[i+1]) == previousDirection:
			print(str(path[i]) + " is a straight!")
			arrows[i].texture = STRAIGHT
			var nextNode: Vector2 = arrows[i+1].position
			arrows[i].look_at(nextNode)
			previousDirection = getArrowDirection(path[i], path[i+1])
		else:
			print(str(path[i]) + " is a turn!")
			arrows[i].texture = CORNER
			var nextNode: Vector2 = arrows[i+1].position
			arrows[i].look_at(nextNode)
			arrows[i].rotate(deg_to_rad(90))
			if turnedLeft(previousDirection, node, path[i+1]):
				print("A LEFT turn!")
				arrows[i].rotate(deg_to_rad(180))
			else:
				print("A RIGHT turn!")
				arrows[i].rotate(deg_to_rad(-90))
		previousDirection = getArrowDirection(path[i], path[i+1])
		print("facing " + str(previousDirection) + "!")

func hideArrows():
	for arrow in arrows:
		arrow.visible = false

func getArrowDirection(from: Vector2, to: Vector2) -> Globals.Direction:
	var result: Vector2 = to - from
	match result:
		Vector2(-1, 0):
			return Globals.Direction.Left
		Vector2(1, 0):
			return Globals.Direction.Right
		Vector2(0, -1):
			print("from: " + str(from))
			print("to: " + str(to))
			print("from - to: " + str(result))
			return Globals.Direction.Up
		Vector2(0, 1):
			return Globals.Direction.Down
	assert(false, "vector2 is not a direction")
	return Globals.Direction.Up # only to make it stop complaining.

func turnedLeft(previousDirection: Globals.Direction, pos: Vector2, nextPos: Vector2) -> bool:
	var direction: Globals.Direction = getArrowDirection(pos, nextPos)
	match previousDirection:
		Globals.Direction.Left:
			return direction == Globals.Direction.Down
		Globals.Direction.Up:
			return direction == Globals.Direction.Left
		Globals.Direction.Right:
			return direction == Globals.Direction.Up
		Globals.Direction.Down:
			return direction == Globals.Direction.Right
	return false

func placeArrow(pos: Vector2):
	pass
