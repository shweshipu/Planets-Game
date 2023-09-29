extends Node
class_name A_Civ
"""
this class is an abstract class for a dataholder for what a specific Civilization has specialties in.
"""



"""
list datatype. what are this Civ's comparative advantages? (Economics term)
"""
const commoditySpecialties = []
#factory which produces teh commodities (this can be any abstract factory, but godot was giving me a bugged error when i tried to typecast
var commodityFactory : A_CommodityFactory = DefaultCommodityFactory 

#what type of unique trade item does this Civ have?
const uniqueItems = []

# Called when the node enters the scene tree for the first time.
func _ready():
	commodityFactory.setSpecialties(commoditySpecialties) ## only defaultFactory needs this list


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#func sendItemToTradeList():
#	if(uniqueItem != null):
#		self.get_parent().tradesList.addCard(self.uniqueItem) ##find player and add item into tradeslist
func getCommodityFactory() -> A_CommodityFactory:
	return self.commodityFactory
