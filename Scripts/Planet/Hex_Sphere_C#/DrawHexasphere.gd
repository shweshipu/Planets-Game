extends Spatial


class_name DrawHexasphere


var surfacetool : SurfaceTool

#hold the hexes and pents
var _polygons = []
const Polygon = preload("res://Scripts/Planet/Hex_Sphere_C#/Polygon.gd")


func _ready():
	#_meshFilter = GetComponent<MeshFilter>();
	#DrawHexasphereMesh();
	pass


func DrawHexasphereMesh(hexasphereTiles,radius):

	for tile in hexasphereTiles:
		#prepare new polygon
		var poly = Polygon.new()#preload("res://Scripts/Hex_Sphere/godotTile.gd").new()
		var center = tile.get_center().get_Position()
		var normal = center.normalized()
		poly.set_normal(normal)
		
		#sort the points and add them
		
		var corners = [null,null,null,null,null,null]
		var tilePoints = tile.get_Points()
		for i in range(0,tilePoints.size()):
			corners[i] = tilePoints[i].get_Position()
		shorten(corners)
		
		""" trying to minmax speed so im using the array statically instead of this nice clean code //frick it barely did anything
		var corners = []
		for point in tile.get_Points():
			corners.append(point.get_Position())
		"""
		corners = sortCorners(center,corners,normal)
		for corn in corners:
			poly.add_vertex(corn)
		
		#ending stuff
		#give poly a center for stuff
		poly.set_center(center)
		tile.set_poly(poly)
		var polyNeighbors = []
		"""
		smh yet another loop over every tile on the planet. so slow. 
		maybe i could get around it or delay it til later but then the code wouldnt be so pretty
		im not sure its that important to do anyway
		"""
		for neighbor in tile.get_Neighbours():
			#whatever ill just keep the appends in, it didnt speed it up much anyway
			polyNeighbors.append(neighbor.get_poly())
		poly.set_neighbors(polyNeighbors) #british and american mix and match. combined with godots lack of typing is ech.
		#var centerpoint = tile.get_center()
		#poly.set_center(centerpoint.ProjectToSphere(radius,0.0).get_Position())
		_polygons.append(poly)
		poly.draw()
		self.add_child(poly)
	return _polygons
func shorten(array):
	"""
	used so i can make arrays static for a little more speed
	"""
	if array[5] == null:
		array.resize(5)

func sortCorners(center:Vector3, vectors, normal:Vector3):
	"""
	takes an array of vector3s, as well as a center, and sorts the vector 3s in clockwise order based on their rotational degrees.
	
	in other words, this will (should?) sort the corners of any convex polygon
	
	https://newbedev.com/how-to-sort-vertices-of-a-polygon-in-counter-clockwise-order
	"""
	#consider the first vector as UP. and the rest of is clockwise
	
	##2d array
	var vectAndAngles=[null,null,null,null,null,null]
	for i in range(vectors.size()):
		var angle = findAngle(center,vectors[0],vectors[i],normal)
		vectAndAngles[i] = [vectors[i] , angle]
		#vectAndAngles.append([vectors[i] , angle])
	shorten(vectAndAngles)
	#had to put them in a 2d array so i could sort it easily in godot
	vectAndAngles.sort_custom(self,"sortPointFromAngle")
	
	var returnArray = [null,null,null,null,null,null]
	for i in range(vectAndAngles.size()):
		returnArray[i] = vectAndAngles[i][0]
	shorten(returnArray)
	"""
	for vectAng in vectAndAngles:
		print(vectAng[1]) #i do not know why this seems to only print float rounding errors of the 360, but it works so ¯\\_ (ツ)_/¯
		returnArray.append(vectAng[0])
		"""
	return returnArray
	
	
func findAngle(center:Vector3,from:Vector3,to:Vector3,normal:Vector3) -> float:
	"""
	uses vector3 get angle to check the angle between two vectors, but makes sure its relative to a center point
	it views positive and negative from the perspective of outside of the tile using opposite of normal (which is the direction pointing toward hexasphere center)
	"""
	var start = from - center
	var end = to - center
	#note the negative on the normal
	var angle = start.signed_angle_to(end,-normal)
	angle = angle+360
	return angle
	

static func sortPointFromAngle(a,b):
	"""
	used for array.sort_custom so that i can sort the points based on another array
	
	takes two lists with a form of [vector,angle]
	"""
	if a[1] < b[1]:
		return true
	return false

