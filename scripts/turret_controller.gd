extends Node3D

@export var rotation_speed: float = 3.0
@export var min_pitch: float = -20.0  
@export var max_pitch: float = 20.0   

var current_pitch: float = 0.0  

func _process(delta: float) -> void:
	var aim_input_x: float = Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left")
	if aim_input_x != 0.0:
		rotate_y(aim_input_x * rotation_speed * delta)

	var aim_input_y: float = Input.get_action_strength("aim_up") - Input.get_action_strength("aim_down")
	if aim_input_y != 0.0:
		current_pitch += aim_input_y * rotation_speed*4 * delta
		current_pitch = clamp(current_pitch, min_pitch, max_pitch)
		rotation_degrees.x = current_pitch
