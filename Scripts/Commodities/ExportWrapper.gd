extends Commodity
class_name ExportWrapper

"""
This class wraps a commodity so it cannot be used until it has been exported to another civ
"""

var commodity : Commodity

func _init(newName : String, amount:float, weight: float).(newName, amount, weight):
	#assign stuff so this still can be passed as a commodity.
	self.commodityName = "Export " + newName
	self.amount = amount;
	self.unitWeight = weight
	#assign our wrapped commodity with the same specs as this class has.
	self.commodity = Commodity.new(newName, amount, weight)


func unWrap() -> Commodity:
	##I think this works?
	self.queue_free()
	return self.commodity
