class_name AmmoData
extends Resource

## Resouce used by ammo manager to handle ammmo change

@export var ammo_name: String
@export var ammo_scene: PackedScene
@export var mag_size: int 				#mag size
@export var max_ammo: int 				#total ammo
var current_ammo: int			#total ammo remaining
var current_mag: int 			#ammo left on mag
var is_active: bool

func _init():
	current_ammo = max_ammo
	current_mag = 0
