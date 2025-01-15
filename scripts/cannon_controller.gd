extends Node3D

@onready var GameUI: CanvasLayer = get_node("/root/Main/GameUI")
@onready var inner_crosshair: Sprite2D = GameUI.get_node("Crosshair/CrosshairInner")
@onready var outer_crosshair: Sprite2D = GameUI.get_node("Crosshair/CrosshairOuter")

@onready var main_cam: Camera3D = $"../../../Camera3D"
@onready var raycast: RayCast3D = $RayCast3D

const MIN_SCALE: float = 0.1
const MAX_SCALE: float = 1
const MAX_RAYCAST_DISTANCE: float = 30

func _ready():
	raycast.enabled = true

func _process(delta):
	var collision_point: Vector3
	var distance: float

	if raycast.is_colliding():
		collision_point = raycast.get_collision_point()
		distance = collision_point.distance_to(main_cam.global_transform.origin)
	else:
		collision_point = raycast.global_transform.origin + raycast.global_transform.basis.z * MAX_RAYCAST_DISTANCE
		distance = MAX_RAYCAST_DISTANCE

	var screen_pos: Vector2 = main_cam.unproject_position(collision_point)

	inner_crosshair.position = screen_pos
	outer_crosshair.position = screen_pos

	var scale_factor = lerp(MAX_SCALE, MIN_SCALE, clamp(distance / MAX_RAYCAST_DISTANCE, 0.0, 1.0))
	if distance == MAX_RAYCAST_DISTANCE:
		scale_factor = 0.1

	outer_crosshair.scale = Vector2(scale_factor, scale_factor)
