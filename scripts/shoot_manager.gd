extends Node3D

@export var ammo_scene: PackedScene  
@export var max_ammo: int = 10 
@export var reload_duration: float = 2.0
@export var shoot_force: float = 160.0
@export var recoil_animation: String = "recoil"

var ammo_pool: Array = []
var cannon: Node3D  
var animation_player: AnimationPlayer

var fire_interval: float = 0.5 
var can_shoot: bool = true
var is_reloading: bool = false  

func _ready():
	cannon = get_parent()  
	animation_player = cannon.get_node("AnimationPlayer") 
	for i in range(max_ammo):
		var ammo_instance = ammo_scene.instantiate()
		ammo_instance.queue_free()  
		ammo_pool.append(ammo_instance)

#TODO: Pool the ammo instead of instantiating 

func shoot():
	print("Shooting...")
	if !can_shoot:
		return
	can_shoot = false
	var ammo: RigidBody3D = ammo_scene.instantiate() 
	# get_tree().root.add_child(ammo)  
	get_parent().add_child(ammo)
	ammo.set_as_top_level(true)
	ammo.global_transform.origin = global_transform.origin
	var direction = cannon.global_transform.basis.z  
	ammo.apply_impulse(-direction * shoot_force, Vector3.ZERO) 
	#if animation_player.has_animation(recoil_animation):
		#animation_player.play(recoil_animation) 
	# await(get_tree().create_timer(recoil_duration))
	print("Shooting is complete")
	await(get_tree().create_timer(fire_interval))
	can_shoot = true

func get_available_ammo() -> Node:
	for ammo in ammo_pool:
		if ammo.is_queued_for_deletion():
			return ammo
	return null  

func refill_ammo():
	var current_count = ammo_pool.size()
	for i in range(max_ammo - current_count):
		var ammo_instance = ammo_scene.instantiate()
		ammo_instance.queue_free()  
		ammo_pool.append(ammo_instance)
		
func reload():
	if is_reloading: 
		return
	is_reloading = true
	print("Reloading...")
	await(get_tree().create_timer(reload_duration))
	refill_ammo()

	is_reloading = false
	print("Reload complete!")
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reload"): 
		reload()
	elif event.is_action_pressed("shoot"): 
		shoot()
