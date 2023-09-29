extends A_CommodityFactory
class_name CommFactory_Traders
"""
this factory makes it so all commodities produced by the Traders civ get less regular goods, but more export goods.

overall this civ produces 1.5 times as much of all goods
"""


#Override
func produce( commodityName : String, amount : float):
	#holder for what the output will be
	var output = {}
	##call super method, but only give half the amount of domestic goods
	var domestic = ._createDomestic(commodityName, amount *0.5)
	#add it to dictionary
	output[domestic.getName()] = domestic
	
	##call super method, but give 3.5 times the normal amount of export goods (0.5 is default)
	var wrapper = ._createExport(commodityName, amount * 1.75)
	#add it to dictionary
	output[wrapper.getName()] = wrapper
	
	return output
