extends A_CommodityFactory
class_name DefaultCommodityFactory ##freaking heck thats long
"""
this is the default factory for every civ which doesnt need special treatment with commodities.
"""
var specialties

#Override
func produce( commodityName : String, amount : float):
	#holder for what the output will be
	var output = {}
	##call super method
	var domestic = ._createDomestic(commodityName, amount)
	#add it to dictionary
	output[domestic.getName()] = domestic
	
	#if this is this civ's specialty to produce it, do export-commodities
	if(specialties.has(commodityName)):
		##call super method, but only give half the amount of export goods
		var wrapper = ._createExport(commodityName, amount * 0.5)
		#add it to dictionary
		output[wrapper.getName()] = wrapper
	
	return output

#Override
func setSpecialties(specialties):
	"""
	set the specialties
	"""
	self.specialties = specialties
