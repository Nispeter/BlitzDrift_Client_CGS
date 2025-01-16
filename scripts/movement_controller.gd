extends Node3D

@export var base_speed: float = 10.0         # Base speed for the tank
@export var turn_speed: float = 2.0         # Turning speed
@export var gravity: float = -1             # Simulated gravity
@export var max_revolutions: int = 100      # Max revolutions needed to keep moving in high gears
@export var high_rev_threshhold: int = 70
@export var low_rev_threshold: int = 20     # Minimum revolutions to prevent stalling in high gears
@export var up_gear_revolution: int = 25
@export var down_gear_revolution :int = 65

# Gears and counters
var current_gear: String = "N"              # Start in Neutral ("N", "1", "2", "3", "4", "R")
var revolutions: int = 0                    # Revolution counter
var speed_multiplier: float = 0.0           # Speed multiplier based on gear
var speed_revolutions: float = 0.0

# Direction and parent reference
var direction: Vector3 = Vector3.ZERO
@onready var parent_body = get_parent()

# Labels for displaying information
@onready var revolution_label = $"../../GameUI/RevolutionLabel"
@onready var speed_label = $"../../GameUI/SpeedLabel"
@onready var gear_label = $"../../GameUI/GearLabel"


func _ready():
	update_labels()

func _physics_process(delta: float) -> void:
	# Handle turning input
	var turn_input: float = Input.get_action_strength("turn_left") - Input.get_action_strength("turn_right")
	rotation.y += turn_input * turn_speed * delta

	# Handle forward/backward motion based on gear
	if current_gear == "N":  # Neutral gear: no motion
		direction.x = 0
		direction.z = 0
	var dir_input: float = Input.get_action_strength("move_forward")
	speed_revolutions = speed_multiplier * revolutions/max_revolutions
	if dir_input: 
		if current_gear == "R":  # Reverse gear
			var reverse_input = dir_input
			var reverse_motion: Vector3 = transform.basis.z * reverse_input * base_speed 
			direction.x = reverse_motion.x 
			direction.z = reverse_motion.z 
			if(revolutions < max_revolutions): revolutions += int(reverse_input > 0)
		else:  # Forward gears
			var forward_input = dir_input
			var forward_motion: Vector3 = -transform.basis.z * forward_input * base_speed * speed_revolutions
			direction.x = forward_motion.x 
			direction.z = forward_motion.z 
			if forward_input > 0:
				if(revolutions < max_revolutions): revolutions += 1
	else:
		dir_input = Input.get_action_strength("move_backward")
		if dir_input:
			if(revolutions > 0): revolutions -= 2
		if(revolutions > 0): revolutions -= 1
	
	# Gravity logic
	if not parent_body.is_on_floor():
		direction.y += gravity * delta
	else:
		direction.y = 0

	# Apply movement
	parent_body.velocity = direction * speed_revolutions
	parent_body.move_and_slide()

	# Check for low revolutions and stall motor if needed
	if revolutions < low_rev_threshold and current_gear != "N" and current_gear != "R" and current_gear != "1":
		stop_motor()

	update_labels()

# Shift gear up
func shift_gear_up():
	if current_gear == "R":
		current_gear = "N"
		speed_multiplier = 0.0
	elif current_gear == "N":
		current_gear = "1"
		speed_multiplier = 0.5
	elif current_gear == "1":
		current_gear = "2"
		speed_multiplier = 1.0
	elif current_gear == "2":
		current_gear = "3"
		speed_multiplier = 1.5
	elif current_gear == "3":
		current_gear = "4"
		speed_multiplier = 2.0
	revolutions = up_gear_revolution
	
# Shift gear down
func shift_gear_down():
	if current_gear == "4":
		current_gear = "3"
		speed_multiplier = 1.5
	elif current_gear == "3":
		current_gear = "2"
		speed_multiplier = 1.0
	elif current_gear == "2":
		current_gear = "1"
		speed_multiplier = 0.5
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
	speed_label.text = "Speed: %.2f" %(base_speed * speed_multiplier * speed_revolutions)
	gear_label.text = "Gear: %s" % str(current_gear)
