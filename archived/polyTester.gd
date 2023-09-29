extends Spatial
class_name PolyTester



var poly = preload("res://Scripts/Hex_Sphere_C#/Polygon.gd").new()
# Called when the node enters the scene tree for the first time.
func _ready():
	poly.set_normal(Vector3(1,0,0))
	poly.add_vertex(Vector3(0,0,10))
	poly.add_vertex(Vector3(0,10,10))
	poly.add_vertex(Vector3(0,10,0))
	poly.add_vertex(Vector3(0,0,0))

	poly.draw()
	self.add_child(poly)
	for i in range(1,20):
		var temppoly = preload("res://Scripts/Hex_Sphere_C#/Polygon.gd").new()
		temppoly.set_normal(Vector3(1,0,0))
		temppoly.add_vertex(Vector3(i,0,10))
		temppoly.add_vertex(Vector3(i,10,10))
		temppoly.add_vertex(Vector3(i,10,0))
		temppoly.add_vertex(Vector3(i,0,0))

		temppoly.draw()
		self.add_child(temppoly)
