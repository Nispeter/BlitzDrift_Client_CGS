extends RigidBody3D
class_name Ammo

@export var lifetime: float = 5.0 

var shooter: Node3D = null
var lifetime_timer: Timer

func _ready():
	shooter = get_parent()
	lifetime_timer = Timer.new()
	lifetime_timer.wait_time = lifetime
	lifetime_timer.one_shot = true
	lifetime_timer.autostart = true
	lifetime_timer.connect("timeout", Callable(self, "queue_free"))
	add_child(lifetime_timer)

func _on_collision(body: Node) -> void:
	if body == shooter:
		return
	on_hit(body)
	queue_free()

func on_hit(body: Node) -> void:
	print("Bullet hit: ", body.name)

func _on_area_entered(area: Area3D) -> void:
	if area != shooter:
		on_hit(area)
