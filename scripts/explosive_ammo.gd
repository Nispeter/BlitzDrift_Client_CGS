extends Ammo

@export var explosion_radius: float = 5.0 
@export var explosion_force: float = 1000.0

var explosion_area: Area3D

func _ready():
	explosion_area = Area3D.new()
	var collision_shape = CollisionShape3D.new()
	var sphere_shape = SphereShape3D.new()
	sphere_shape.radius = explosion_radius
	collision_shape.shape = sphere_shape
	explosion_area.add_child(collision_shape)

	explosion_area.connect("body_entered", Callable(self, "_on_body_entered"))
	explosion_area.connect("area_entered", Callable(self, "_on_area_entered"))

	add_child(explosion_area)
	explosion_area.position = global_transform.origin
	super._ready()

func _on_collision(body: Node) -> void:
	super._on_collision(body)
	#TODO: get normal for ricochet
	explode()

func explode() -> void:
	print("ammo exploding")
	#explosion_area.disabled = false
	#for body in explosion_area.get_overlapping_bodies():
		#if body is RigidBody3D:
			#var direction = body.position - global_transform.origin
			#direction = direction.normalized()
			#body.apply_impulse(direction * explosion_force)
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body is RigidBody3D:
		var direction = body.position - global_transform.origin
		direction = direction.normalized()
		body.apply_impulse(direction * explosion_force)

func _on_area_entered(body: Node) -> void:
	if body is RigidBody3D:
		var direction = body.position - global_transform.origin
		direction = direction.normalized()
		body.apply_impulse(direction * explosion_force)
