class_name Screen
extends Control

@export var pauses_time: bool = false
@export var opens_on_top: bool = false
@export var starts_active: bool = false				#WARNING: don´t remember what this was made for
@export var is_base_screen: bool = false
@export var allows_pause: bool = true

var is_active: bool = starts_active

#NOTE: this class should work as a base for all screens in game 

func _ready():
	if !starts_active:
		deactivate()
	else: 
		activate()

func toggle():
	if is_active:
		deactivate()
	else:
		activate()

func activate() -> void:	
	is_active = true
	self.visible = true
	on_activate()

func deactivate() -> void:
	is_active = false
	self.visible = false
	on_deactivate()

func on_activate() -> void:
	pass

func on_deactivate() -> void:
	pass
