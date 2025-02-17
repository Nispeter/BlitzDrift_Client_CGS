extends Camera3D
## Script that handles the movement of the camera of the  tank customization menu.
#NOTE: making a new camera controller was a bad idea, it was better to make a rotation script for each tank object with a scatic camera

# Adjustable parameters
@export var zoom_speed: float = 10.0
@export var rotation_speed: float = 0.1
@export var min_distance: float = 2.0
@export var max_distance: float = 20.0

# Target to orbit around
@export var target: Node3D

# Internal state variables
var distance: float = 10.0
var horizontal_angle: float = 0.0
var vertical_angle: float = 0.0

func _ready():
	if not target:
		push_error("Target node is not assigned.")

func _input(event):
	if event is InputEventMouseMotion and Input.is_action_pressed("rotate_camera"):
		horizontal_angle -= event.relative.x * rotation_speed
		vertical_angle = clamp(vertical_angle + event.relative.y * rotation_speed, -1.5, 1.5)
	elif event is InputEventMouseButton:
		if event.is_action_pressed("zoom_in") and event.pressed:
			distance -= zoom_speed * 0.1
		elif event.is_action_pressed("zoom_out") and event.pressed:
			distance += zoom_speed * 0.1

	distance = clamp(distance, min_distance, max_distance)

func _process(delta: float):
	update_camera_position()

func update_camera_position():
	if not target:
		return

	var target_position = target.global_transform.origin
	var offset = Vector3(
		distance * cos(vertical_angle) * sin(horizontal_angle),
		distance * sin(vertical_angle),
		distance * cos(vertical_angle) * cos(horizontal_angle)
	)
	global_transform.origin = target_position + offset
	look_at(target_position)
