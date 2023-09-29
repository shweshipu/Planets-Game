extends A_CommodityFactory
class_name CommFactory_Welsh
"""
this factory makes it so the Welsh also produce 1 ambergris for every hundred of anything they produce.
"""


#Override
func produce( commodityName : String, amount : float):
	#holder for what the output will be
	var output = {}
	##call super method
	var domestic = ._createDomestic(commodityName, amount)
	#add it to dictionary
	output[domestic.getName()] = domestic
	
	##call super method, but give a small amount of ambergris only
	var wrapper = ._createExport("Ambergris", amount * 0.01)
	#add it to dictionary
	output[wrapper.getName()] = wrapper
	
	return output
