extends Node
class_name CommodityDict
"""
This class contains all Commodities which are NOT player specific Commodities.
as well as all their weights.
its literally just a dictionary

format is:
	commodityname : unitweight
"""
const commodities = {##hmm i should prolly organize this differently. Nah i can just append any future dictionaries in getDict()
	#7 basic resources
	"Ohtusha" : 0.2,
	"Conductium" : 1.6,
	"Yellorium" : 3.0,
	"Biolo" : 0.8,
	"Hydrum" : 0.9,
	"Toxicia" : 0.5,
	"Metallium" : 4.0,
	#the magic space rock resource
	"Pueditia" : 2.0,
	#manufactured resources
	"Fuel" : 1.0,
	"Pueditia Fuel" : 1.0,
	"Microchips" : 1.7,
	"Food" : 0.9,
	#misc stuff
	"Ambergris" : 5.0,
}

static func getDict() -> Dictionary:
	return commodities
