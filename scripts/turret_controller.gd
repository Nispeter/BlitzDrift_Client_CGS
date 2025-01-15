extends Node3D

@export var rotation_speed: float = 3.0

func _process(delta: float) -> void:
	var aim_input: float = Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left")
	if aim_input != 0.0:
		rotate_y(aim_input * rotation_speed * delta)
