extends MeshInstance
class_name Polygon
"""
this class acts as a rendering of a hexagon or pentagon in the hexasphere, and also manages collision for activating a hex/pentagon

https://docs.godotengine.org/en/stable/tutorials/content/procedural_geometry/arraymesh.html#doc-arraymesh
"""

var st
var _default_normal
var _default_color = Color.green
#grumble grumble godot's create_trimesh_collision() wont frickin work
var corners = []
var shape = ConvexPolygonShape.new()
var collision = CollisionShape.new()

var _center : Vector3

var _neighbors = [] #setget set_neighbors,get_neighbors

var _material = preload("res://assets/materials/default_spatialmaterial.tres")

#var manager = self.get_parent().get_parent() #prolly not a good practice but eh, i dont really expect to have tiles floating without a hexmanager class

"""
not sure if this stuff could be better organized in a subclass, but it seems aight to put here for now
"""
#if we have a building
var building
#if we have a unit, or two
var units
#what kinda terrain we got (use decorator pattern for hills and stuff if u wanna do that)
var terrainType

func _ready():
	pass
	set_surface_material(0,SpatialMaterial.new())
	get_surface_material(0).albedo_color = _default_color
	print("new poly initted!")
	

func _init():
	st = SurfaceTool.new()
	
	st.begin(Mesh.PRIMITIVE_TRIANGLE_FAN)
	set_surface_material(0,_material)
	

func set_color(color : Color):
	_default_color = color
	get_surface_material(0).albedo_color = _default_color
func set_normal(norm : Vector3):
	_default_normal = norm
func add_vertex(vert : Vector3):
	st.add_normal(_default_normal)
	st.add_uv(Vector2(0,1))
	st.add_color(_default_color)
	st.add_vertex(vert)
	corners.append(vert)
func draw():
	# Create indices, indices are optional.
	st.index()

	# Commit to a mesh.
	mesh = st.commit()
	shape.set_points(corners)
	collision.set_shape(shape)
	var sb = StaticBody.new()
	add_child(sb)
	sb.add_child(collision)
	sb.set_collision_layer_bit(Enums.collisionlayer.POLY,true)
	#sb.transform.origin = _center
	#print(_center)
	#have to manually make a shape smh
	#create_trimesh_collision()

func set_center(newcenter : Vector3):
	_center = newcenter
func get_center() -> Vector3:
	return _center	

func on_click():
	"""
	#i dont think i need observer pattern here so im not using it
	this sends data to the HexManager of which tile was clicked.
	"""
	#manager.polyClick(self)
	print("eyoo!")
	set_color(Color.rebeccapurple)

func set_neighbors(newNeighbors):
	_neighbors = newNeighbors
func get_neighbors():
	return _neighbors
