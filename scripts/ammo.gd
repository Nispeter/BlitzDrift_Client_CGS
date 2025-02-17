extends RigidBody3D
class_name Ammo

## Base script for bullets, controlls collisions 

@export var lifetime: float = 5.0 
@export var mag_size: int = 1
@export var total_ammo: int

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
	
# destroy or deal damage on collision 
func _on_collision(body: Node) -> void:
	if body == shooter:
		return
	if body is RigidBody3D:
		#need collision normal to calculate ricochet angle (this one is fake)
		var collision_normal: Vector3 = (global_transform.origin - body.global_transform.origin).normalized()
		var ammo_velocity: Vector3 = linear_velocity.normalized()
		var collision_angle: float = rad_to_deg(acos(ammo_velocity.dot(collision_normal)))
		#if collision_angle <= 15 and can_ricochet and current_bounces < max_bounces:
			#ricochet(collision_normal)
		#else:
			#on_hit(body)
			#queue_free()
		on_hit(body)
		queue_free()

# behaviour on hitting a collision body
func on_hit(body: Object) -> void:
	print("Bullet hit: ", body.name)
	if body.has_node("shootable"):
		
		var shootable = body.get_node("shootable")
		if shootable.has_method("take_damage"):
			shootable.take_damage(1, self)
			##CAmbiar por daño de la bala cuando ammo tenga daño xD
	else: 
		print("Tipo de body: ", body)

func _on_area_entered(area: Area3D) -> void:
	if area != shooter:
		on_hit(area)
		
#FIXME: this shit is cursed yo (needs more math)
func ricochet(normal: Vector3) -> void:
	var reflected_velocity: Vector3 = - linear_velocity + 2 * linear_velocity.dot(normal) * normal
	#var random_axis: Vector3 = reflected_velocity.cross(normal).normalized()
	#var random_angle: float = deg_to_rad(randf_range(0, 15)) 
	#reflected_velocity = reflected_velocity.rotated(random_axis, random_angle)
	linear_velocity = reflected_velocity * 0.8
	#print("ric " + str(linear_velocity))
	

		
#@export var can_ricochet: bool = true
#@export var ricochet_angle: int = 15
#@export var max_bounces: int = 2
#var current_bounces:int = 0

#FIXME: this shit is cursed yo (needs more math)
#func ricochet(normal: Vector3) -> void:
	#var reflected_velocity: Vector3 = - linear_velocity + 2 * linear_velocity.dot(normal) * normal
	##var random_axis: Vector3 = reflected_velocity.cross(normal).normalized()
	##var random_angle: float = deg_to_rad(randf_range(0, 15)) 
	##reflected_velocity = reflected_velocity.rotated(random_axis, random_angle)
	#linear_velocity = reflected_velocity * 0.8
	##print("ric " + str(linear_velocity))
	
'''
La idea era hacer un ricochet que siguiera la direccion del movimiento, sin utilizar bounce (por que es muy poco realista), 
pero los rigidBody3D no soportan obtener la normal de la superficie de colision fuera de _physics_process, pero desde ahi no se 
pueden modificar los parametros propios 
'''
