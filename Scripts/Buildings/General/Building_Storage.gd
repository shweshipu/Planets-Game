extends "res://Scripts/Buildings/A_Building.gd"

"""
This is a building which is responsible for resource management.

that means:
	- accepting incoming cargo from ships, as well as every building connected by roads.
	- Handing off cargo to cargo ships
	- subtracting fuel when a rocket leaves
	- Handing off fuel to Vessels.
	- subtracting resources when they are used by the administrative building when choosing a new thing to make
"""



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#CARGO IS OF TYPE Resource array
func acceptCargo(cargo):
	pass

#MATERIALS IS OF TYPE Resource array
func deductExpenses(materials):
	pass


