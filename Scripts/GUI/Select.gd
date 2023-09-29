extends "res://addons/goutte.camera.trackball/trackball_camera.gd"
"""
This class manages clicking stuff, bringing the proper ui up, and panning to it, if its on the same planet

"""


#var ray = RayCast.new()
##just moving these here so space doesnt have to be allocated on every click
var camera
var mousePos
var from
var to

var GuiFactory = preload("res://Scripts/GUI/GuiFactory.gd")
var guifact = GuiFactory.new()

export var RAY_LENGTH = 100

#what is our camera gonna focus? (ie a unit or building or smth)
var selectedObject

var focusing : bool = false


func _process(delta): # ive been told this helps with inheritence overriding
	process(delta)
func process(delta):
	handle_focusing()


func _input(event):# ive been told this helps with inheritence overriding
	click(event)


func click(event):
	if (event is InputEventMouseButton):
		if event.pressed and event.get_button_index() == BUTTON_LEFT:
			_leftClickHit()

func get_objects_under_mouse():
	"""
	raycast til we hit a relevant object.
	https://godotengine.org/qa/48523/raycast-from-mouse
	"""
	mousePos = get_viewport().get_mouse_position()
	camera = self
	from = camera.project_ray_origin(mousePos)
	#print(from)
	var to = from + camera.project_ray_normal(mousePos) * RAY_LENGTH
	#print(ray_to)
	return(multi_ray_cast(from,to))

func ray_cast(from,to) -> Node:
	var space_state = get_world().direct_space_state
	var selection = space_state.intersect_ray(from, to)
	if selection.empty():
		return null
	return selection["collider"] 

func multi_ray_cast(from,to):
	"""
	I want to raycast though multiple objects 
	but segment is only found in 2d?
	This function returns an array of dictionarys
	"""
	#i dont trust it to stop on its own so heres a catch
	var arbitrary_stop = 20
	var total_length = from.distance_to(to)
	var space_state = get_world().direct_space_state
	var intersections = []
	var selection = {"position":from}
	var i = 0
	
	while (not selection.empty()) and i < arbitrary_stop:
		selection = space_state.intersect_ray(selection["position"], to)
		if not selection.empty():
			intersections.append(selection)
		print("AAAAAAAAAA")
		i+=1
	
	return intersections 

func segment_cast(begin_pos, end_pos):
##UNUSED
	var space_state = get_world().get_direct_space_state()
	
	var segment = SegmentShape2D.new()
	segment.set_a(begin_pos)
	segment.set_b(end_pos)
	
	var query = Physics2DShapeQueryParameters.new()
	query.set_shape(segment)
	query.set_exclude([self]) # If you want to exclude the object casting the segment
	#query.set_layer_mask(Enums.collisionlayer.POLY)#GROUND_MASK) # Set the collision mask you want, or none if you want to hit anything
	
	var hits = space_state.intersect_shape(query, 32)
	print(hits)
	return hits


func _leftClickHit() -> void:
	
	var intersections = get_objects_under_mouse()
	if(not intersections.empty()):#if we clicked something
		self.selectedObject = _chooseObject(intersections)
		if(self.selectedObject != null): #if we clicked unit, building, etc. something thats not a polygon
			print(self.selectedObject)
			self.selectedObject.on_click() #<- remove later and do guifactory instead
			send_gui_popup(guifact.get_gui_popup(selectedObject))
			self.focus_object(recurse_til_planet(selectedObject))
		else:#if we clicked a polygon tile
			drop_gui_popup()
	
	else:#if we clicked nothing
		self.selectedObject = null
		drop_gui_popup()

func _chooseObject(intersections) -> Node:
	var cur_object
	
	#select the first object which isnt current planet. also return null if its just a tile.
	for selection in intersections:
		#print(selection)
		#i dont care about the collider, just give me what holds it.
		cur_object = selection["collider"].get_parent()
		#choose a new object, which also isnt the planet
		#if _is_focused_planet(cur_object):# or self.selectedObject == cur_object:
			#continue
		"""
		if selection["collider"].get_collision_layer_bit(Enums.collisionlayer.POLY):
			#Only clicked a tile.
			#I wish i knew a better way to typecheck for child classes in godot.
			#this is a bad way to do this.
			return null
		"""
		break
	return cur_object

func recurse_til_planet(cur):
	"""
	recurse up using get_parent until we find something thats a planet
	or return null if no planet found
	"""
	
	while(not(cur is A_Celestial)):
		if(cur == get_tree().get_root()):
			return null
		cur = cur.get_parent()
	return cur

func _is_focused_planet(Node) -> bool:
	#did we click a planet we are not currently parented to?
	return Node == self.get_parent()

func _rightClickHit() -> void:
	"""
	when a click is successful, do the appropriate actions.
	"""
	#hide old UI if we had one selected
	#bring up the hit object's UI
	#pan the camera to the object.
		#if its a planet, activate the trackball script


func focus_object(object:Spatial):
	"""
	move the camera to focus on an object
	if its another planet, then switch to there first
	
	
	Im not sure how to make it less jarring of a change,
	I think I'll have to rewrite how the trackball camera script works
	"""
	if(object == null):
		return
#	if not sameplanet:
#		self.switch_planet()
#	self.focusing = true
	#var cur_pos = self.global_transform.origin-object.global_transform.origin
	self.get_parent().remove_child(self)
	object.add_child(self)
	#self.global_transform.origin = object.global_transform.origin+cur_pos
	
	
	#ASSERT ITS A A_CELESTIAL
	if(self.get_parent() is A_Celestial):
		self.zoom_minimum = 1 * self.get_parent().radius 
		self.zoom_maximum = 30 # * self.get_parent().radius
	else:#is some space thing
		self.zoom_minimum = 0.5 * Consts.scale
		self.zoom_maximum = 500 * Consts.scale

func handle_focusing():
	"""
	add inertia until we move to be above the object radially.
	
	"""
	if not self.focusing :
		return
#	for i in range(100):
#		lerp()

func send_gui_popup(thing):
	pass
func drop_gui_popup():
	pass

func set_gui_factory(newfact: GuiFactory):
	self.guifact = newfact
	drop_gui_popup()
