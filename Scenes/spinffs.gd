extends RigidBody



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.add_torque(Vector3(0.5,0,0))
