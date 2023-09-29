extends Node

var planets_and_moons = []

var scale = Consts.scale

# Called when the node enters the scene tree for the first time.
func _ready():
	#_init(new_orbitee,orbitRadius,mass,rotationspeed,radius,divisions)
	
	#make sun parented to sun object
	make_planet(get_node("sun"),0,10,10,10,3)
	
	randomized_system()
func make_planet(new_orbitee,orbitRadius,mass,rotationspeed,radius,divisions):
	var new_planet = A_Celestial.new(new_orbitee,orbitRadius,mass,rotationspeed,radius,divisions)
	self.add_child(new_planet)
	self.planets_and_moons.append([new_planet])

func rand_planet(new_orbitee, i):
	var BUFFER = 200 * scale #min distance from another planet
	var mass = rand_range(1,5)
	var rotationspeed = rand_range(-1,5)
	var radius = rand_range(15 * scale,50 * scale)
	var orbitRadius = new_orbitee.radius + BUFFER * (i) + rand_range(-10 * scale,10 * scale) #+ radius
	var divisions = int(sqrt((radius/scale) / 2))
	
	make_planet(new_orbitee,orbitRadius,mass,rotationspeed,radius,divisions)

func make_moon(new_orbitee,orbitRadius,mass,rotationspeed,radius,divisions,p):
	var new_moon = A_Celestial.new(new_orbitee,orbitRadius,mass,rotationspeed,radius,divisions)
	self.add_child(new_moon)
	self.planets_and_moons[p].append(new_moon)

func rand_moon(new_orbitee, p,m):
	var BUFFER = 15 * scale#min distance from another moon
	
	var mass = rand_range(1,500)
	var rotationspeed = rand_range(-2,10)
	var radius = rand_range(3 * scale,10 * scale)
	var orbitRadius = new_orbitee.radius + rand_range(BUFFER * m, BUFFER * (m+1)) # + radius
	var divisions = int(sqrt((radius/scale) / 2))
	
	make_moon(new_orbitee,orbitRadius,mass,rotationspeed,radius,divisions,p)
func randomized_system():
	#below is a formula for planet._init() because godot doesnt have tooltips ;(
	#_init(new_orbitee,orbitRadius,mass,rotationspeed,radius,divisions)
	
	#assume 0 index is preinitialized as the sun
	assert(planets_and_moons[0][0] != null)
	
	for p in range(1, int(rand_range(4,9))):
		rand_planet(planets_and_moons[0][0], p)
		for m in range(1 + int(rand_range(5,10))):
			rand_moon(planets_and_moons[p][0] ,p,m)
