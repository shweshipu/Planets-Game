extends Node
class_name Player

#what civ are they?
var civ

var tradesList
#the thing which keeps track of this player's empire's stuff
var census
#keeps track of what upgrades this player made in the Culture tree thing
var upgrades

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func getTradesList():
	return self.tradesList

func getCiv() -> A_Civ:
	return self.civ

func getCensus() -> Census:
	return self.census
