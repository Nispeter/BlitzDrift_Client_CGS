extends Ammo

@export var explosion_scene: PackedScene 
@export var explosion_offset: Vector3 = Vector3.ZERO

func _on_collision(body: Node) -> void:
	super._on_collision(body)

func on_hit(body):
	trigger_explosion()

func trigger_explosion():
	if explosion_scene:
		var explosion = explosion_scene.instantiate()
		explosion.global_transform.origin = global_transform.origin + explosion_offset
		get_parent().add_child(explosion)
		(explosion as Node3D).call_deferred("trigger_explosion")
	queue_free()
