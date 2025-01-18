extends RigidBody3D
class_name Ammo

@export var lifetime: float = 5.0 
@export var can_ricochet: bool = true
@export var ricochet_angle: int = 15
@export var max_bounces: int = 2
var current_bounces:int = 0

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
	if body is RigidBody3D:
		#need collision normal to calculate ricochet angle (this one is fake)
		var collision_normal: Vector3 = (global_transform.origin - body.global_transform.origin).normalized()
		var ammo_velocity: Vector3 = linear_velocity.normalized()
		var collision_angle: float = rad_to_deg(acos(ammo_velocity.dot(collision_normal)))
		if collision_angle <= 15 and can_ricochet and current_bounces < max_bounces:
			ricochet(collision_normal)
		else:
			on_hit(body)
			queue_free()

#FIXME: this shit is cursed yo (needs more math)
func ricochet(normal: Vector3) -> void:
	var reflected_velocity: Vector3 = - linear_velocity + 2 * linear_velocity.dot(normal) * normal
	#var random_axis: Vector3 = reflected_velocity.cross(normal).normalized()
	#var random_angle: float = deg_to_rad(randf_range(0, 15)) 
	#reflected_velocity = reflected_velocity.rotated(random_axis, random_angle)
	linear_velocity = reflected_velocity * 0.8
	#print("ric " + str(linear_velocity))
	


func on_hit(body: Node) -> void:
	print("Bullet hit: ", body.name)

func _on_area_entered(area: Area3D) -> void:
	if area != shooter:
		on_hit(area)
		

#extends RigidBody3D
#class_name Ammo
#
#@export var lifetime: float = 5.0 
#@export var can_ricochet: bool = true
#@export var ricochet_angle: int = 15
#@export var max_bounces: int = 2
#var current_bounces:int = 0
#
#
#var shooter: Node3D = null
#var lifetime_timer: Timer
#
#func _ready():
	#shooter = get_parent()
	#lifetime_timer = Timer.new()
	#lifetime_timer.wait_time = lifetime
	#lifetime_timer.one_shot = true
	#lifetime_timer.autostart = true
	#lifetime_timer.connect("timeout", Callable(self, "queue_free"))
	#add_child(lifetime_timer)
	#
#func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	## Check for collisions during the physics step
	#for contact in range(state.get_contact_count()):
		#var collider = state.get_contact_collider(contact)
		#var collision_normal = state.get_contact_local_normal(contact) # Get the collision normal
		#var collision_position = state.get_contact_local_position(contact)
		#
#
		## Ignore collisions with the shooter
		##if collider_body == shooter:
		##	continue
#
		## Calculate the ricochet angle
		#print("normal " + str(collision_normal))
		#var ammo_velocity = linear_velocity.normalized()
		#var collision_angle = rad_to_deg(acos(ammo_velocity.dot(collision_normal)))
		#print(collision_angle)
		#if can_ricochet and current_bounces < max_bounces and collision_angle <= ricochet_angle:
			#ricochet(collision_normal)
			#current_bounces += 1
		#else:
			## on_hit(collider)
			#queue_free()
			#break
#
##FIXME: this shit is cursed yo (needs more math)
#func ricochet(normal: Vector3) -> void:
	#var reflected_velocity: Vector3 = - linear_velocity + 2 * linear_velocity.dot(normal) * normal
	##var random_axis: Vector3 = reflected_velocity.cross(normal).normalized()
	##var random_angle: float = deg_to_rad(randf_range(0, 15)) 
	##reflected_velocity = reflected_velocity.rotated(random_axis, random_angle)
	#linear_velocity = reflected_velocity * 0.8
	##print("ric " + str(linear_velocity))
	#
#
#
#func on_hit(body: Node) -> void:
	#print("Bullet hit: ", body.name)
#
#func _on_area_entered(area: Area3D) -> void:
	#if area != shooter:
		#on_hit(area)
