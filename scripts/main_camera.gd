extends Camera3D

@export var follow_distance: float = 10.0  # Distance behind the tank
@export var follow_height: float = 5.0    # Height above the tank
@export var follow_speed: float = 5.0     # Smooth following speed
@export var rotation_speed: float = 0.005 # Speed of camera rotation around the tank
@export var target_tank: Node3D           # Reference to the tank

var current_yaw: float = 0.0              # Horizontal rotation (yaw) around the tank
var current_pitch: float = 0.0            # Vertical rotation (pitch)
var min_pitch: float = -30.0              # Minimum pitch angle (in degrees)
var max_pitch: float = 45.0               # Maximum pitch angle (in degrees)

var rotating_camera: bool = false         # Whether the camera is being rotated

func _ready():
	if not target_tank:
		print("Warning: No target_tank assigned to the camera.")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta: float) -> void:
	if not target_tank:
		return

	var desired_position: Vector3 
	if rotating_camera:
		var rotation_basis: Basis = Basis(Vector3.UP, current_yaw) * Basis(Vector3.RIGHT, current_pitch)
		desired_position = target_tank.global_transform.origin \
						   + rotation_basis.z * follow_distance \
						   + Vector3.UP * follow_height
	else:
		current_yaw = target_tank.rotation.y
		current_pitch = 0.0
		desired_position = target_tank.global_transform.origin \
						   - target_tank.global_transform.basis.z * follow_distance \
						   + target_tank.global_transform.basis.y * follow_height


	global_transform.origin = global_transform.origin.lerp(desired_position, follow_speed * delta)
	look_at(target_tank.global_transform.origin, Vector3.UP)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and rotating_camera:
		current_yaw -= event.relative.x * rotation_speed*0.5
		current_pitch += event.relative.y * rotation_speed*0.5
		current_pitch = clamp(current_pitch, deg_to_rad(min_pitch), deg_to_rad(max_pitch))

	if event is InputEventMouseButton:
		if Input.get_action_strength("rotate_camera"):
			if event.pressed:
				rotating_camera = true
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			rotating_camera = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
