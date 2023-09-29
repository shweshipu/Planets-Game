extends Spatial
class_name A_Celestial
"""
This is an abstract class for all celestial bodies, ie:
	suns
	planets
	comets
	asteroids
	asteroid belts?
	moons (planets)
	and everything else that is a landmass
"""

"""
Gameplay variables
"""

#the tiles and stuff
var HexManager = preload("res://Scripts/Planet/HexManager.gd")
var hexManager
#whats its gravity (only affects shipping)
var gravity

"""
Movement variables
"""
#what is it orbitting around?
#export(NodePath) onready var orbitee = get_node(orbitee)
export(NodePath) var orbitee 
#how fast it spinnnnn
export var rotationSpeed = 1 
#what quat we spin at
var rotationQuat
#what vector does that quat create? (based on rotating the up vector)
var _rotationAxis

#how far is it from its orbitee
export var orbitRadius = 10
#how fast it orbits (in 1000ths of radians
export var orbitSpeed = 1
#keeps track of what angle we are at in orbit, so we dont drift off
var currentOrbitAngle

var mass
const GRAV_CONSTANT = 6.674 /100 #6.674 * pow(10,-11) #realism is too small 

#vector2, position relative to orbitee
var currentOrbitPosition

#stuff passed to hexmanager. will be based on planet type prolly, and randomized too
export var radius = 10
export var divisions = 7
#big collider used for swapping camera focus of which planet.
#var PlanetCollider = preload("res://Prefabs/PlanetCollider.tscn").instance()
var PlanetAthmosphere = preload("res://addons/zylann.atmosphere/planet_atmosphere.tscn").instance()
var planetCollider
var atmosphere




func _init(new_orbitee,orbitRadius,mass,rotationspeed,radius,divisions):
	
	self.orbitee = new_orbitee
	self.orbitRadius = orbitRadius
	#self.orbitSpeed = orbitSpeed #TODO use math instead
	self.mass = mass
	#idk why A_celestial evaluates to spatial but oof me ig THESE BASTARDS WITH THEYRE CYCLIC REFERENCE BS
	if(new_orbitee.get_class() == "Spatial"):
		self.orbitSpeed = sqrt(GRAV_CONSTANT * (new_orbitee.mass + self.mass) / (orbitRadius))
	else:
		#print(new_orbitee.get_class())
		self.orbitSpeed = 0
	self.radius = radius
	self.rotationSpeed = rotationspeed /10.0
	self.divisions = divisions
	
	self.hexManager = HexManager.new(radius,divisions)
	#TODO make all this planetcollider and atmosphere bs work
	#self.planetCollider = PlanetCollider
	self.atmosphere = PlanetAthmosphere
	
	_fake_ready()



func _fake_ready():
##	###moved from init
##	self.hexManager = HexManager.new(radius,divisions) ##??? idk something like this though, i might have to redo the hexasphere architecture.
##	#self.orbitee = new_orbitee
##	#TODO make all this planetcollider and atmosphere bs work
##	self.planetCollider = PlanetCollider
##	self.atmosphere = PlanetAthmosphere
	### end moved from init
	#   add_child(self.planetCollider)
	#   self.planetCollider.transform.scaled(Vector3(radius*2,radius*2,radius*2))
	#add_child(self.atmosphere)
	self.atmosphere.set_planet_radius(radius)
	self.atmosphere.set_sun_path("../sun")
	add_child(self.hexManager)

	#set it to the path specified in inspector
	_init_orbitee()

	#place this planet at a random angle to start
	_place_at_random()
	##self.position = orbitee.position + Vector2(cos(angle), sin(angle)) * revolutionRadius


	#what quat we spin at
	self.rotationQuat = self.transform.basis.get_rotation_quat()
	#what vector does that quat create? (based on rotating the up vector)
	self._rotationAxis = rotationQuat.xform(Vector3.UP)
	print("celestial initialized")

	##this.rotatevelocity = rotationSpeed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	_orbit();
	_spin()
	#print(self.transform.origin)


#orbit around the thing
func _orbit() -> void:
	#causes drift, using angle instead
	#self.transform.origin = (orbitee.transform.origin + (self.transform.origin - orbitee.transform.origin).rotated(Vector3.UP,orbitSpeed /1000.0))
	currentOrbitAngle += orbitSpeed /1000.0
	self.transform.origin = orbitee.transform.origin + Vector3(cos(currentOrbitAngle),0, sin(currentOrbitAngle)) * orbitRadius

func _spin() -> void:
	#rotate it by negative spin so its clockwise and matches with orbit for tidally locked stuff
	rotate(_rotationAxis, - rotationSpeed/1000.0)

func _place_at_random() -> void:
	#place this thing at a random angle around its orbitee
	randomize()
	var angle = rand_range(0.0, TAU)
	print("angle of placement is:",angle)
	self.transform.origin = orbitee.transform.origin + Vector3(cos(angle),0, sin(angle)) * orbitRadius
	currentOrbitAngle = angle

#this is here so that Star can override it to nothing
func _init_orbitee() -> void:
	if(orbitee == null):
		#idk if this actually works lmao just trying it
		orbitee = self

func disableCollider():#gonna be using signals from the camera to call these functions.
	pass
func enableCollider():
	pass
