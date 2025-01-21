extends Node3D

@export var shoot_force: float = 160.0
@export var fire_interval: float = 1.0

@onready var shoot_particles: GPUParticles3D = $"../ShootFire"
@onready var smoke_particles: GPUParticles3D = $"../ShootSmoke"
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var ammo_manager: Node = $"../AmmoManager"

var can_shoot: bool = true

func _ready():
	if ammo_manager == null:
		push_error("AmmoManager node is missing!")

func shoot():
	if !can_shoot:
		return
	if ammo_manager.consume_ammo():
		var ammo_instance: RigidBody3D = ammo_manager.current_ammo_data.ammo_scene.instantiate()
		get_parent().add_child(ammo_instance)
		ammo_instance.set_as_top_level(true)
		ammo_instance.global_transform.origin = global_transform.origin
		var direction = global_transform.basis.z
		ammo_instance.apply_impulse(-direction * shoot_force, Vector3.ZERO)

		# Animations n' shit
		shoot_particles.restart()
		smoke_particles.restart()
		if animation_player.has_animation("recoil"):
			animation_player.play("recoil")

		can_shoot = false
		await get_tree().create_timer(fire_interval).timeout
		can_shoot = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot()
	elif event.is_action_pressed("reload"):
		ammo_manager.reload()
	elif event.is_action_pressed("change_ammo"):
		ammo_manager.change_ammo()
