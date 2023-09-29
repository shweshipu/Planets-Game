extends Node
class_name Goods

"""
This class is a holder for multiple commodities, because I realized I kept repeating myself 
and needed to redo some functions with Commodity anyway
"""

#an dictionary of Commodities. godot 3 doesnt have static typed commodities yet 
var commodities = {};
#how much does all this weigh?
var weight : float
#holds a reference to the census of the player that owns these goods
var census : Census
#the producer of our goods
var commodityFactory : A_CommodityFactory

func _init(player:Player):
	census = player.getCensus()
	commodityFactory = player.getCiv().getCommodityFactory()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func createCommodity( commodityName : String, amount : float) -> void:
	"""
	bring a new commodity(s) into existence named commodityName
	"""
	#get a dict of new commodities from factory
	var newComms = commodityFactory.produce(commodityName,amount)
	self._mergeCommodities(newComms, false)

func mergeGoods(incoming: Goods) -> void: 
	"""
	take in incoming goods, and add all its commodities to this one.
	
	im mainly just importing a whole Goods class because godot version 3 doesnt have static-typing for arrays/lists yet. (v4 will have)
	"""
	var imports = incoming.getCommodities()
	self._mergeCommodities(imports, false)
	#delete the goods object because we no longer need it.
	incoming.queue_free()

func getCommodities():##returns an array of Commodities
	return self.commodities

func mergeForeignGoods(incoming: Goods) -> void: 
	"""
	take in incoming goods from another player, and add all its commodities to this one.
	"""
	var imports = incoming.getCommodities()
	self._mergeCommodities(imports, true)
	#delete the goods object because we no longer need it.
	incoming.queue_free()

# underscore means private.
func _mergeCommodities(imports, isForeign: bool) -> void: #Takes a dictionary of commodities.
	for type in imports.values():
		
		if(isForeign):#I dont like this boolean thing, but it was quick and easy, so hopefully it doesnt do bad things to my design.
			if(type.is_class("ExportWrapper")): #check if its an export good, if so then unwrap it.
				type=type.unwrap();
			#tell the census we got new stuff.
			self.census.trackCommodityAdd(type.getName(),type.getAmount())
		
		#add stuff to this goods object
		self.weight += type.getWeight();
		if(self.commodities.has(type.getName())):
			self.commodities[type.getName()].addAmount(type.getAmount());
		else:
			self.commodities[type.getName()] = type
