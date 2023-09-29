extends A_Civ
class_name Civ_Stocks

"""
this civ is very unique, in that it has stockbroking mechanics.

stocks in the civ's cities can be traded. these DO NOT represent ownership. 

they pay out dividends to whoever holds them. 
This dividend amount is always 15 percent of the stock Civ's total resources. (using float datatype)
but this 10 percent is then divided and distributed among all of the stock holders.

this civ can create one stock for each city(main building of it (tbd) they found.
"""


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
