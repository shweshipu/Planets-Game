extends A_Celestial
class_name Star

var light = OmniLight.new()


#Override
func _init_orbitee() -> void:
	self.orbitee = get_node(orbitee)
	#if there is no orbitee, set to self
	if not is_instance_valid(orbitee) :
		orbitee = self
		orbitRadius = 0
	#if there is orbitee, leave it as is
