class_name MoveNode
extends Resource

var position: Vector2
var step_number: int
var steps_here: float
var distance_to_goal: float
var previous_node: Vector2

func _init(here: Vector2, goal: Vector2, stepsToHere: float, previousNode: Vector2) -> void:
	position = here
	distance_to_goal = here.distance_to(goal)
	steps_here = stepsToHere
	previous_node = previousNode

func getComputeDistance() -> float:
	return steps_here + distance_to_goal
