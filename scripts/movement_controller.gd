extends Node3D

@export var base_speed: float = 10.0         # Base speed for the tank
@export var turn_speed: float = 2.0         # Turning speed
@export var gravity: float = -1             # Simulated gravity
@export var base_jump_force: float = 6      # Force applied for a jump
@export var max_jumps: int = 2              # Maximum number of allowed jumps
@export var jump_tied_to_gear: bool = false
@export var max_revolutions: int = 100      # Max revolutions needed to keep moving in high gears
@export var high_rev_threshhold: int = 70
@export var low_rev_threshold: int = 20     # Minimum revolutions to prevent stalling in high gears
@export var up_gear_revolution: int = 25
@export var down_gear_revolution: int = 65

@onready var raycasts = [
	$RayCast3D_TopLeft,
	$RayCast3D_TopRight,
	$RayCast3D_BottomLeft,
	$RayCast3D_BottomRight
]	

var current_gear: String = "N"              # Start in Neutral ("N", "1", "2", "3", "4", "R")
var revolutions: int = 0                    # Revolution counter
var speed_multiplier: float = 0.0           # Speed multiplier based on gear
var speed_revolutions: float = 0.0
var jump_count: int = 0                     # Tracks the number of jumps performed
var jump_force: int = base_jump_force
var direction: Vector3 = Vector3.ZERO

@onready var parent_body = get_parent()
@onready var was_airborne: bool = parent_body.is_on_floor()

@onready var particle_effect = $DustLand
@onready var revolution_label = $"../../ScreenManager/GameUI/RevolutionLabel"
@onready var speed_label = $"../../ScreenManager/GameUI/SpeedLabel"
@onready var gear_label = $"../../ScreenManager/GameUI/GearLabel"

func _ready():
	update_labels()

func _physics_process(delta: float) -> void:
	var turn_input: float = Input.get_action_strength("turn_left") - Input.get_action_strength("turn_right")
	rotation.y += turn_input * turn_speed * delta

	if current_gear == "N":  
		direction.x = 0
		direction.z = 0
	var dir_input: float = Input.get_action_strength("move_forward")
	speed_revolutions = speed_multiplier * revolutions / max_revolutions
	
	if dir_input: 
		if current_gear == "R":  
			var reverse_motion: Vector3 = -transform.basis.z * dir_input * base_speed 
			direction.x = reverse_motion.x 
			direction.z = reverse_motion.z 
			if revolutions < max_revolutions: revolutions += int(dir_input > 0)
		else: 
			var forward_motion: Vector3 = transform.basis.z * dir_input * base_speed * speed_revolutions
			direction.x = forward_motion.x 
			direction.z = forward_motion.z 
			if dir_input > 0 and revolutions < max_revolutions:
				revolutions += 1
	else:
		if revolutions > 0:
			revolutions -= 2
			
	_handle_jump(delta)
	
	parent_body.velocity = direction * Vector3(speed_revolutions,1,speed_revolutions)
	parent_body.move_and_slide()
	
	align_to_floor(delta)

	if revolutions < low_rev_threshold and current_gear not in ["N", "R", "1"]:
		stop_motor()
	update_labels()

func _handle_jump(delta: float):
	if(jump_tied_to_gear): jump_force = base_jump_force * speed_multiplier
	else: jump_force = base_jump_force
	
	if !parent_body.is_on_floor():
		direction.y += gravity * delta
		if !was_airborne: was_airborne = true
		
	else:
		if was_airborne: 
			particle_effect.restart()
			particle_effect.emitting = true 
			was_airborne = false
		direction.y = 0
		jump_count = 0  
		
	if Input.is_action_just_pressed("jump") and jump_count < max_jumps:
		direction.y = jump_force
		jump_count += 1
		if !parent_body.is_on_floor():
			particle_effect.restart()
			particle_effect.emitting = true 

# Shift gear up
func shift_gear_up():
	if current_gear == "R":
		current_gear = "N"
		speed_multiplier = 0.0
	elif current_gear == "N":
		current_gear = "1"
		speed_multiplier = 0.4
	elif current_gear == "1":
		current_gear = "2"
		speed_multiplier = 0.8
	elif current_gear == "2":
		current_gear = "3"
		speed_multiplier = 1.2
	elif current_gear == "3":
		current_gear = "4"
		speed_multiplier = 1.6
	revolutions = up_gear_revolution
	
# Shift gear down
func shift_gear_down():
	if current_gear == "4":
		current_gear = "3"
		speed_multiplier = 1.2
	elif current_gear == "3":
		current_gear = "2"
		speed_multiplier = 0.8
	elif current_gear == "2":
		current_gear = "1"
		speed_multiplier = 0.4
	elif current_gear == "1":
		current_gear = "N"
		speed_multiplier = 0.0
	elif current_gear == "N":
		current_gear = "R"
		speed_multiplier = 0.5
	revolutions = down_gear_revolution

# Stop the motor
func stop_motor():
	current_gear = "N"
	speed_multiplier = 0.0
	revolutions = 0
	
func align_to_floor(delta: float) -> void:
	var total_normal = Vector3.ZERO
	var hit_count = 0

	for raycast in raycasts:
		if raycast.is_colliding():
			total_normal += raycast.get_collision_normal()
			hit_count += 1

	if hit_count > 0:
		var average_normal = total_normal / hit_count
		var target_transform = align_with_y(parent_body.global_transform, average_normal)
		parent_body.global_transform = parent_body.global_transform.interpolate_with(target_transform, 12 * delta)

func align_with_y(transform: Transform3D, normal: Vector3) -> Transform3D:
	var basis = Basis()
	basis.y = normal.normalized()
	basis.x = basis.y.cross(Vector3.FORWARD).normalized()
	basis.z = basis.x.cross(basis.y).normalized()
	transform.basis = basis
	return transform

# Handle input for gear shifting
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("gear_up") and (revolutions > high_rev_threshhold or current_gear == "N") and current_gear != "4" and current_gear != "R":
		shift_gear_up()
	elif event.is_action_pressed("gear_up") and current_gear == "R" and revolutions < low_rev_threshold:
		shift_gear_up()
	elif event.is_action_pressed("gear_down") and current_gear != "R":
		shift_gear_down()

# Update UI labels
func update_labels() -> void:
	revolution_label.text = "Revolutions: %d" % revolutions
	speed_label.text = "Speed: %.2f" % (base_speed * speed_multiplier * speed_revolutions)
	gear_label.text = "Gear: %s" % str(current_gear)
	
func apply_speed_boost(amount: float) -> void:
	base_speed += amount
	if base_speed < 0:  
		base_speed = 0
