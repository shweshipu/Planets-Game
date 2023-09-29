extends Node
class_name A_CommodityFactory
"""
we usin the factory pattern.

this is the abstract factory for commodities
"""

var census : Census

func produce( commodityName : String, amount : float):
	"""
	returns a new dictionary of commodities (dict keys are the commodity names)
	"""
	print("A_CommodityFactory should not be assigned to anything, because it is abstract")
	return {}

#private
func _createDomestic(commodityName : String, amount : float) -> Commodity:
	"""
	just make a commodity like normal. get the weight from CommodityDict
	"""
						#newName : String, amount:float, weight: float
	
	
	var commodity = Commodity.new(commodityName,amount,CommodityDict.getDict()[commodityName])
	self._addToCensus(commodity)
	return commodity

func _createExport(commodityName : String, amount : float) -> Commodity:
	"""
	just make a Export wrapper like normal. get the weight from CommodityDict
	"""
						#newName : String, amount:float, weight: float
	var wrapper = ExportWrapper.new(commodityName, amount, CommodityDict.getDict()[commodityName])
	self._addToCensus(wrapper)
	return wrapper

func _addToCensus(commodity : Commodity) -> void:
	"""
	send this commodity's info to the census
	"""
	census.trackCommodityAdd(commodity.getName(),commodity.getAmount())

func setSpecialties(specialties) -> void:
	"""
	this takes an array of Strings which are assumed to be Commodity names
	
	this is only implemented in DefaultCommodityFactory. the specialized ones will just have this do nothing.
	"""
	pass
