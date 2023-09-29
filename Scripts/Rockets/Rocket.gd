extends Node
class_name Rocket

"""
This is probably going to be one of the most complex classes in here, at least mathematically. (besides hexasphere)

This class defines what is common about every "rocket" type unit.
"Rocket" means that they go directly from point A to point B, and have no input while on the way. (a vessel would)

there will be alot of vague rocket sciencey math in here that is partially based on stuff, but mostly made up.

note: this class is NOT abstract.
"""

#how much fuel we got? WAIT I DONT CARE OH FRICK I CAN JUST TRACK IT IN THE SENDING BUILDING
#var fuel:Resource_Fuel
#IS TYPE any
var cargo : Object

#BOOLEAN
var isTraveling : bool

#CARGOSHIP OR STORAGEBUILDING. what are we headed towards?
var destination : Object
#INT how many turns til we get there?
var timeTillDestination : int


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignal.add_listener('next_turn', self, '_advance')


# Called every turn.i put the underscore cuz i just learned that can mean private whoops
func _advance() -> void:
	_travel()

func chooseDestination() -> void:
	"""
	choose a planet to travel to
	"""
	pass
func startTraveling() -> void:
	if(destination != null):
		isTraveling = true

func _travel() -> void:
	"""
	animate moving closer to the destination...
	uhh....
	somehow with maths
	or maybe make it go outside the orbital plane?
	"""
	if(isTraveling):
		pass

#func calcTravelCost(start, destination, speed) -> float: ##put this in the shipping building class?
#	"""
#	find the curved path around the solar system to the destination that would make sense based on simple physics
#
#	use starting momentum, then calc change in speed required for speed up and how much fuel.
#	then make something up about how much gravity will affect the cost (in the place of apoapsis pareapsis stuff)
#	then do a potential rotation to how far it will be to reach the target destination at where it is IN THE FUTURE 
#	(this will always be the same cost. but i suppose the player could choose to speed it up and burn hella fuel)
#	then calc change in speed to slow down and how much fuel is required
#
#	After calculating, this value is sent back, to the caller, who will then subtract it from storage building expenses when we send
#	"""
#	pass
#	"""
#
#	"""
#
#func calcTimeCost(start, destination, speed) -> int:
#	"""
#	find the curved path around the solar system to the destination that would make sense based on simple physics
#
#	use starting momentum, then calc change in speed required for speed up and how much fuel.
#	then make something up about how much gravity will affect the cost (in the place of apoapsis pareapsis stuff)
#	then do a potential rotation to how far it will be to reach the target destination at where it is IN THE FUTURE 
#	(this will always be the same cost. but i suppose the player could choose to speed it up and burn hella fuel)
#	then calc change in speed to slow down and how much fuel is required.
#
#	or just make something up based on those?
#	"""
#	pass
#	"""
#
#	"""

#abstract
func arrive() -> void:
	"""
	implemented in inheriting classes
	"""
	pass

func areWeThereYet():
	pass
