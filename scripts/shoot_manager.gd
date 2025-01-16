extends Node3D

@export var ammo_scene: PackedScene  
@export var max_ammo: int = 2
@export var reload_duration: float = 2.0
@export var shoot_force: float = 160.0
@export var recoil_animation: String = "recoil"
@export var fire_interval: float = 1

@onready var ammo_label = $"../../../../../GameUI/AmmoLabel"
@onready var reload_indicator = $"../../../../../GameUI/Crosshair/CrosshairOuter/Reloadbar"

var current_ammo: int = max_ammo
var cannon: Node3D  
var animation_player: AnimationPlayer

var can_shoot: bool = true
var is_reloading: bool = false  
var needs_reload: bool = false

func _ready():
	cannon = get_parent()  
	animation_player = cannon.get_node("AnimationPlayer") 
	_update_ammo_label()
	
func _update_ammo_label():
	ammo_label.text = "AMMO: " + str(current_ammo)
	
#TODO: Pool the ammo instead of instantiating 

func shoot():
	#End condition
	if !can_shoot or needs_reload:
		return
	can_shoot = false
	
	#Shooting logic
	var ammo: RigidBody3D = ammo_scene.instantiate() 
	get_parent().add_child(ammo)
	ammo.set_as_top_level(true)
	ammo.global_transform.origin = global_transform.origin
	var direction = cannon.global_transform.basis.z  
	ammo.apply_impulse(-direction * shoot_force, Vector3.ZERO) 
	
	#Ammo counter
	current_ammo -= 1
	if current_ammo <= 0:
		needs_reload = true
	_update_ammo_label()
	
	#Animations and stuff
	if animation_player.has_animation(recoil_animation):
		animation_player.play(recoil_animation) 
	await(get_tree().create_timer(fire_interval).timeout)
	can_shoot = true
		
func reload():
	if is_reloading or current_ammo == max_ammo	: 
		return
	is_reloading = true
	
	var elapsed_time = 0.0
	while elapsed_time < reload_duration:
		elapsed_time += get_process_delta_time()
		reload_indicator.value = (elapsed_time/reload_duration)*100
		await get_tree().process_frame
	
	current_ammo = max_ammo
	_update_ammo_label()
	needs_reload = false
	is_reloading = false
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reload"): 
		reload()
	elif event.is_action_pressed("shoot"): 
		shoot()
