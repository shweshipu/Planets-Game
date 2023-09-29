extends Node
"""
##TODO:

figure out why it only generates 3 points of a hexagon.

its prolly smth with how object pointers behave in godot vs javascript? not sure

that one print if "existing" is sus though (hexasphere 112)

"""


# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export(int) var radius = 2
export(int) var divisions = 3
var tileSize = 0.95

var hexasphere	

var tileHolder
#placeholder stuff instead of java Threejs face3 thing

var faces = [];
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

	hexasphere = load("res://Scripts/Hex_Sphere/Hexasphere.gd").new(radius, divisions, tileSize);

	tileHolder = Node.new()
	tileHolder.set_name("Tile_Holder")
	self.add_child(tileHolder)
	for i in range(0, len(hexasphere.tiles)):
		var t = hexasphere.tiles[i];
		var latLon = t.getLatLon(hexasphere.radius,null);

		#var geometry = new THREE.Geometry();
		var points = [];
		for j in range(0, len(t.boundary)):
			var bp = t.boundary[j];
			points.append(Vector3(bp.x, bp.y, bp.z));
			#print(bp.toString())
			#geometry.vertices.push(new THREE.Vector3(bp.x, bp.y, bp.z));
		var newFace = load("res://Scripts/Hex_Sphere/godotTile.gd").new();
		faces.append(newFace);

		print("new face here", i)
		#print(points[3])
		newFace.addTriangle(points[0],points[1],points[2]);
		newFace.addTriangle(points[0],points[2],points[3]);
		newFace.addTriangle(points[0],points[3],points[4]);
		#faces.append(
		"""
		geometry.faces.push(new THREE.Face3(0,1,2));
		geometry.faces.push(new THREE.Face3(0,2,3));
		geometry.faces.push(new THREE.Face3(0,3,4));
		"""
		#if(geometry.vertices.length > 5):
		if(len(points) > 5):
			newFace.addTriangle(points[0],points[4],points[5]);
			#geometry.faces.push(new THREE.Face3(0,4,5));

		#if(isLand(latLon.lat, latLon.lon)){
		#	material = meshMaterials[Math.floor(Math.random() * meshMaterials.length)]
		#else:
		#	material = oceanMaterial[Math.floor(Math.random() * oceanMaterial.length)]

		#material.opacity = 0.3;
		#var mesh = new THREE.Mesh(geometry, material.clone());
		#scene.add(mesh);
		newFace.set_name("tile " + String(i))
		tileHolder.add_child(newFace)
		newFace.draw() # do this if ready() doesnt work.
		#hexasphere.tiles[i].mesh = mesh; # not important? idk

func isLand(lat, long):
	# use with thing later
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	pass
