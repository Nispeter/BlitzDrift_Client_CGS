extends Control

@export var next_button: Button
@export var prev_button: Button
@export var part_name_label: Label
@export var part_type_label: Label

var part_name: String = ""  # To identify which part this selector controls
var customization_system: Node  # Reference to the tank customization system

# Initializes the selector with the tank customization system and the part name
func setup_selector(customization_system: Node, part_name: String):
	self.customization_system = customization_system
	self.part_name = part_name
	part_type_label.text = part_name.capitalize()
	update_labels()

	# Connect button signals with Callable
	next_button.connect("pressed", Callable(self, "_on_next_button_pressed"))
	prev_button.connect("pressed", Callable(self, "_on_prev_button_pressed"))

# Updates the labels to show the current part's state
func update_labels():
	if customization_system and customization_system.tank_parts.has(part_name):
		var selected_index = customization_system.selected_indices[part_name]
		var selected_option = customization_system.tank_parts[part_name][selected_index]
		part_name_label.text = selected_option["name"]

# Handles the "next" button press
func _on_next_button_pressed():
	if customization_system:
		customization_system.change_part(part_name, 1)
		update_labels()

# Handles the "previous" button press
func _on_prev_button_pressed():
	if customization_system:
		customization_system.change_part(part_name, -1)
		update_labels()
