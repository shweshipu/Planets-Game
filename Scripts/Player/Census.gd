extends Node
class_name Census


#how many of each commodity do they have across their empire?
var commodityCensus = {}
#what units do they have across their empire?
var unitCensus = []
#what rockets do they have across their empire?
var rocketCensus = []
#what vessels do they have across their empire?
var vesselCensus = []
#what cities do they have across their empire?
var cityCensus = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func trackCommodityAdd(name : String,change : float):
	"""
	positively change the commodity named 'name' by 'change'
	"""
	commodityCensus[name] += change #positive please

func trackCommoditySubtract(name : String,change : float):
	"""
	negatively change the commodity named 'name' by 'change'
	"""
	commodityCensus[name] -= change #negative please


func addUnitToCensus(unit : Unit):
	"""
	add a unit to the list we track 
	"""
	unitCensus.append(unit)

func removeUnitFromCensus(unit: Unit):
	"""
	remove a given unit from the list we track 
	"""
	unitCensus.erase(unit)


func addRocketToCensus(rocket : Rocket):
	"""
	add a rocket to the list we track 
	"""
	rocketCensus.append(rocket)

func removeRocketFromCensus(rocket: Rocket):
	"""
	remove a given rocket from the list we track 
	"""
	rocketCensus.erase(rocket)


func addVesselToCensus(vessel : Vessel):
	"""
	add a vessel to the list we track 
	"""
	vesselCensus.append(vessel)

func removeVesselFromCensus(vessel: Vessel):
	"""
	remove a given vessel from the list we track 
	"""
	vesselCensus.erase(vessel)


func addCityToCensus(adminBuilding : Building_Admin):
	"""
	add a Building_Admin to the list we track ## this will prolly be changed.
	"""
	cityCensus.append(adminBuilding)

func removeCityFromCensus(adminBuilding: Building_Admin):
	"""
	remove a given Building_Admin from the list we track 
	"""
	cityCensus.erase(adminBuilding)
