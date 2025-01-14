extends CharacterBody3D

@export var speed: float = 10.0
@export var turn_speed: float = 2.0
@export var gravity: float = -1		#NOTE: not sure if its simulated

var direction: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	var forward_input: float = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	var forward_motion: Vector3 = -transform.basis.z * forward_input * speed

	var turn_input: float = Input.get_action_strength("turn_left") - Input.get_action_strength("turn_right")
	rotation.y += turn_input * turn_speed * delta

	if not is_on_floor():
		direction.y += gravity * delta
	else:
		direction.y = 0
	
	direction.x = forward_motion.x
	direction.z = forward_motion.z
	velocity = direction  
	move_and_slide() 
