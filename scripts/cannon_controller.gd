extends Node3D

@onready var GameUI: CanvasLayer = get_node("/root/Main/GameUI")
@onready var inner_crosshair: Sprite2D = GameUI.get_node("Crosshair/CrosshairInner")
@onready var outer_crosshair: Sprite2D = GameUI.get_node("Crosshair/CrosshairOuter")

@onready var main_cam: Camera3D = $"../../../Camera3D"
@onready var raycast: RayCast3D = $RayCast3D
@onready var viewport_size: Vector2 = get_viewport().get_visible_rect().size

const MIN_SCALE: float = 0.1
const MAX_SCALE: float = 1
const MAX_RAYCAST_DISTANCE: float = -30

var collision_point: Vector3
var distance: float
	

func _ready():
	raycast.enabled = true

func _process(delta):
	if raycast.is_colliding():
		var collider = raycast.get_collider()  
		if collider != null and !collider.is_in_group("Projectiles"):
			collision_point = raycast.get_collision_point()
			distance = collision_point.distance_to(main_cam.global_transform.origin)
	else:
		collision_point = raycast.global_transform.origin + raycast.global_transform.basis.z * MAX_RAYCAST_DISTANCE
		distance = MAX_RAYCAST_DISTANCE
		
	if _check_collision_on_screen(collision_point):
		var screen_pos: Vector2 = main_cam.unproject_position(collision_point)
		inner_crosshair.position = screen_pos
		outer_crosshair.position = screen_pos
		var scale_factor = lerp(MAX_SCALE, MIN_SCALE, clamp(-distance / MAX_RAYCAST_DISTANCE, 0.0, 1.0))
		if distance == MAX_RAYCAST_DISTANCE:
			scale_factor = 0.1
		outer_crosshair.scale = Vector2(scale_factor, scale_factor)

func _check_collision_on_screen(collision_point):
	var screen_position: Vector2 = main_cam.unproject_position(collision_point)
	var is_behind = main_cam.is_position_behind(collision_point)
	if screen_position.x >= 0 and screen_position.x <= viewport_size.x and screen_position.y >= 0 and screen_position.y <= viewport_size.y and !is_behind:
		return true
	else:
		return false
	
