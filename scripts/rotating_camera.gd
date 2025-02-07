extends Camera3D

@export var target_node_path: NodePath
@export var rotation_speed: float = 1.0 

var target_node: Node3D

func _ready():
	target_node = get_node_or_null(target_node_path)


func _process(delta: float):
	if not target_node:
		return

	var target_position = target_node.global_transform.origin
	var current_position = global_transform.origin

	var direction = current_position - target_position
	var distance = direction.length()
	
	var rotation_step = rotation_speed * delta
	direction = direction.rotated(Vector3.UP, deg_to_rad(rotation_step)).normalized() * distance

	global_transform.origin = target_position + direction
	look_at(target_position)
