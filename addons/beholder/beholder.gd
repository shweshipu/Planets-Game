extends Camera

export var speed: float = 5.0
export var zoom_scale: float = 2.0
export var slow_scale: float = 4.0
export var enable_collisions: bool = true
export var mount: bool = false
export(PackedScene) var emit_projectile = null
export var emit_force = 1000
export var max_emit_particles = 100

var zoom = false
var slow = false
var dragging = false
var kinematic = KinematicBody.new()
var collision_shape = CollisionShape.new()
var spot_light = SpotLight.new()

var _action_up: String = "beholder_up"
var _action_left: String = "beholder_left"
var _action_down: String = "beholder_down"
var _action_right: String = "beholder_right"
var _action_rize: String = "beholder_rize"
var _action_drop: String = "beholder_drop"
var _action_zoom: String = "beholder_zoom"
var _action_slow: String = "beholder_slow"
var _action_mount: String = "beholder_mount"
var _action_light: String = "beholder_flashlight"
var _action_emit: String = "beholder_emit"
var _particles: Array = []

func _ready() -> void:
	var global = global_transform.origin
	get_parent().call_deferred("add_child", kinematic)
	kinematic.add_child(spot_light)
	kinematic.add_child(collision_shape)
	spot_light.visible = false
	spot_light.spot_range = 30.0
	collision_shape.shape = BoxShape.new()
	collision_shape.shape.extents = Vector3(0.05, 0.05, 0.05)
	collision_shape.disabled = not enable_collisions
	kinematic.rotation = rotation
	kinematic.translation = translation


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if dragging:
			_mouse(event)
		return

	if (event is InputEventMouseButton and event.button_index == BUTTON_RIGHT):
		dragging = event.pressed
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED
							 if event.pressed else
							 Input.MOUSE_MODE_VISIBLE)

	if Input.is_action_pressed(_action_light):
		spot_light.visible = not spot_light.visible

	if Input.is_action_pressed(_action_mount):
		mount = not mount
		set_physics_process(not mount)

	if Input.is_action_pressed(_action_emit) and emit_projectile:
		var projectile_instance: RigidBody = emit_projectile.instance()
		projectile_instance.global_transform = kinematic.global_transform
		projectile_instance.add_central_force(
			-projectile_instance.transform.basis.z * emit_force
		)
		_particles.append(projectile_instance)
		get_tree().get_root().add_child(projectile_instance)

	slow = Input.is_key_pressed(KEY_ALT)
	zoom = Input.is_key_pressed(KEY_SHIFT)
	collision_shape.disabled = not enable_collisions

	if len(_particles) == max_emit_particles:
		var last = _particles.pop_front()
		last.get_parent().remove_child(last)


func _look_updown_rotation(rotation: float = 0.0) -> float:
	var ret_val = kinematic.get_rotation() + Vector3(rotation, 0.0, 0.0)
	ret_val.x = clamp(ret_val.x, PI / -2.0, PI / 2.0)
	return ret_val


func _look_leftright_rotation(rotation: float = 0.0) -> float:
	return kinematic.get_rotation() + Vector3(0.0, rotation, 0.0)


func _mouse(event: InputEventMouseMotion) -> void:
	kinematic.set_rotation(_look_leftright_rotation(event.relative.x / -200.0))
	var up_down_rotation = _look_updown_rotation(event.relative.y / -200.0)
	if up_down_rotation.x > -1.5:
		kinematic.set_rotation(_look_updown_rotation(event.relative.y / -200.0))


func _process(_delta: float) -> void:
	translation = kinematic.translation
	rotation = kinematic.rotation


func _physics_process(delta: float) -> void:
	var _speed = speed * zoom_scale if zoom else speed
	_speed = _speed / slow_scale if slow else _speed
	_speed = _speed * 60 * delta

	if (Input.is_action_pressed(_action_left)
			and Input.is_action_pressed(_action_right)):
		return
	elif Input.is_action_pressed(_action_right):
		kinematic.move_and_slide(kinematic.global_transform.basis.x * _speed)
	elif Input.is_action_pressed(_action_left):
		kinematic.move_and_slide(kinematic.global_transform.basis.x * -_speed)

	if (Input.is_action_pressed(_action_up)
			and Input.is_action_pressed(_action_down)):
		return
	elif Input.is_action_pressed(_action_up):
		kinematic.move_and_slide(kinematic.global_transform.basis.z * -_speed)
	elif Input.is_action_pressed(_action_down):
		kinematic.move_and_slide(kinematic.global_transform.basis.z * _speed)

	if Input.is_action_pressed(_action_rize):
		kinematic.move_and_slide(Vector3(0.0, speed, 0.0))
	if Input.is_action_pressed(_action_drop):
		kinematic.move_and_slide(Vector3(0.0, -speed, 0.0))
