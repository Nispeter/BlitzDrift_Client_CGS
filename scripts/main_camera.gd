extends Camera3D

@export var follow_distance: float = 10.0  # Distance behind the tank
@export var follow_height: float = 5.0    # Height above the tank
@export var follow_speed: float = 5.0     # Smooth rotation speed
@export var target_tank: Node3D           # Reference to the tank

func _ready():
	if not target_tank:
		print("Warning: No target_tank assigned to the camera.")

func _process(delta: float) -> void:
	if not target_tank:
		return

	# Calculate the desired position relative to the tank's orientation
	var desired_position: Vector3 = target_tank.global_transform.origin \
									- target_tank.global_transform.basis.z * follow_distance \
									+ target_tank.global_transform.basis.y * follow_height

	# Smoothly interpolate the camera's position to follow the tank
	global_transform.origin = global_transform.origin.lerp(desired_position, follow_speed * delta)

	# Ensure the camera is always looking at the tank (center of the screen)
	look_at(target_tank.global_transform.origin, Vector3.UP)
