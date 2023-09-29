extends "res://Scripts/GUI/Select.gd"
"""
this camera script is way to frickin long dude. I think this is bad architecture

this class manages swapping planets that the camera focuses

so:
	if the camera is zoomed out far:
		zoom out, all the way above the solar system while rotating to face down.
		disable literally everything in the parent scripts? or maybe just focus the same planet but far out. and up above.
		disable finding entity and tile hitboxes
		enable finding planet hitboxes
		focus_planet() if a planet hitbox is clicked.
		focus planet will:
			change camera parent to planet
			look at planet
			zoom into planet
			rotate until at equator
			reenable all the stuff disabled
"""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
