extends Terrain
class_name TerrainDecorator
"""
uses decorator pattern ish?
"""
#what terrain we decorating?
var heldterrain : Terrain


func _init(newName,newCost,newTerrain):
	terrain_name = newName
	move_cost = newCost
	heldterrain = newTerrain
	
#Override
func get_move_cost() -> int:
	var cost = move_cost
	if heldterrain != null:
		cost+= heldterrain.get_move_cost()
	return cost
#Override
func get_name() -> String:
	var returnName
	if heldterrain != null:
		returnName.append(heldterrain)
	return returnName.append(self.terrain_name)
