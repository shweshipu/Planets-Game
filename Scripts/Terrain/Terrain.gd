extends Node
class_name Terrain
#how difficult to move through? used in Astar
var move_cost:int
#what kinda terrain to tell the player?
var terrain_name : String


func get_move_cost() -> int:
	return move_cost

func get_name() -> String:
	return terrain_name
