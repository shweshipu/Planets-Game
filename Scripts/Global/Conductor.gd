extends Node

"""
This script keeps track of sending out end of turn signals
It is the 'conductor' of the universe

it also counts the turn. 
"""

#what turn is it?
var turnCount;

signal next_turn;

# Called when the node enters the scene tree for the first time.
func _ready():
	"""
	use GlobalSignal to make it so this can signal globally to all the listeners out there that need it
	"""
	GlobalSignal.add_emitter('next_turn', self)


func nextTurn():
	turnCount+=1
	emit_signal("next_turn")
