extends Node

@export var reload_duration: float = 2.0
@export var ammo_catalogue: Array[AmmoData] = []

@onready var ammo_section = get_node("/root/Main/ScreenManager/GameUI/AmmoSection")
@onready var reload_indicator = get_node("/root/Main/ScreenManager/GameUI/Crosshair/CrosshairOuter/Reloadbar")

var current_ammo_index: int = 0
var current_ammo_data: AmmoData
var is_reloading: bool = false

func _ready():
	for ammo_data in ammo_catalogue:
		if ammo_data:
			ammo_data.current_ammo = ammo_data.max_ammo
			ammo_data.current_mag = 0
			ammo_data.is_active = true
	
	if ammo_catalogue.size() > 0:
		_create_ammo_labels()
		_change_ammo(0) 
	else:
		push_error("Ammo catalogue is empty!")

func _create_ammo_labels():
	for child in ammo_section.get_children():
		child.queue_free()

	for ammo_data in ammo_catalogue:
		var ammo_label = Label.new()
		ammo_label.text = _format_ammo_label_text(ammo_data)
		ammo_label.modulate = Color(1, 1, 1, 0.3)  # Default to 30% opacity
		ammo_section.add_child(ammo_label)

	_update_ammo_labels()

func _update_ammo_labels():
	for i in range(ammo_catalogue.size()):
		var ammo_label: Label = ammo_section.get_child(i)
		ammo_label.visible = ammo_catalogue[i].current_ammo > 0 or ammo_catalogue[i].current_mag
		
		if !ammo_label.visible:
			ammo_catalogue[i].is_active = false
			return
		
		ammo_label.modulate = Color(1, 1, 1, 1) if i == current_ammo_index else Color(1, 1, 1, 0.3)
		ammo_label.text = _format_ammo_label_text(ammo_catalogue[i])
		

func _format_ammo_label_text(ammo_data: AmmoData) -> String:
	return "%s MAG: %d | TOTAL: %d" % [
		ammo_data.ammo_name,
		ammo_data.current_mag,
		ammo_data.current_ammo,
	]

func _change_ammo(index: int):
	if is_reloading or index < 0 or index >= ammo_catalogue.size():
		return
	while !ammo_catalogue[index].is_active:
		index = (index+ 1) % ammo_catalogue.size()
	print(index)
	current_ammo_index = index
	current_ammo_data = ammo_catalogue[index]
	_update_ammo_labels()

func consume_ammo() -> bool:
	if current_ammo_data.current_mag > 0:
		current_ammo_data.current_mag -= 1
		_update_ammo_labels()  
		return true
	else:
		if current_ammo_data.current_ammo <= 0:
			#TODO: change ammo on deplete, right now is updating on consuue ammo (no good)
			change_ammo()
			current_ammo_data.is_active = false
		_update_ammo_labels()
	return false

func reload():
	if is_reloading or current_ammo_data.current_mag == current_ammo_data.mag_size or current_ammo_data.current_ammo <= 0:
		return
	is_reloading = true
	var elapsed_time = 0.0

	while elapsed_time < reload_duration:
		elapsed_time += get_process_delta_time()
		reload_indicator.value = (elapsed_time / reload_duration) * 100
		await get_tree().process_frame

	var reload_amount = min(
		current_ammo_data.current_ammo,
		current_ammo_data.mag_size
	)
	current_ammo_data.current_mag = reload_amount
	current_ammo_data.current_ammo -= reload_amount
	is_reloading = false
	_update_ammo_labels()

func change_ammo():
	var new_index = (current_ammo_index + 1) % ammo_catalogue.size()
	_change_ammo(new_index)
	
func create_ammo(mag_size: int, max_ammo: int) -> void:
	#TODO: create a new ammunition adder 
	_create_ammo_labels()
