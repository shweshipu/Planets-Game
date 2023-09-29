extends Node
class_name Commodity

"""
This is a class for Commodities like fuel, metal, etc.
"""

##constant
var commodityName:String;

var amount:float;
#how much does an amount of 1 weigh?
var unitWeight:float;



func _init(newName : String, amount:float, weight: float):
	self.commodityName = newName
	self.amount = amount;
	self.unitWeight = weight
	


func addAmount(change : float) -> float:
	amount+=change
	return amount;

func subAmount(change : float) -> float:
	amount-=change
	return amount;

func getAmount() -> float:
	return amount;

func canTransact(proposal:float) -> bool:
	"""returns true if there is enough of this Commodity to be consumed"""
	return amount>=proposal

func transact(cost) -> bool:
	"""returns true if there is enough of this Commodity to be consumed. also consumes the Commodity if true"""
	if(canTransact(cost)):
		subAmount(cost)
		return true
	else:
		return false

func getWeight() -> float:
	return amount*unitWeight;

func getName() -> String:
	return self.commodityName
