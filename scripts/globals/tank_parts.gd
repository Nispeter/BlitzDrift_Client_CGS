extends Node
#NOTE: Global class that stores filepaths of customizable endpoints
var tank_loadout_fp = "user://tank_loadout.res"
var tank_parts = {
	"cannon": [
		{"mesh": preload("res://assets/models/cannon1.tres"), "color": Color(0, 0, 0.5), "name": "cannon 1"},
		{"mesh": preload("res://assets/models/cannon2.tres"), "color": Color(1, 0, 0), "name": "cannon 2"},
		{"mesh": preload("res://assets/models/cannon2.tres"), "color": Color(1, 1, 0), "name": "cannon 3"}
	],
	"turret": [
		{"mesh": preload("res://assets/models/turret1.tres"), "color": Color(0, 0, 0.5), "name": "turret 1"},
		{"mesh": preload("res://assets/models/turret1.tres"), "color": Color(1, 0, 0), "name": "turret 2"},
		{"mesh": preload("res://assets/models/turret2.tres"), "color": Color(0, 1, 0), "name": "turret 3"}
	],
	"chassis": [
		{"mesh": preload("res://assets/models/chassis1.tres"), "color": Color(0, 0, 0.5), "name": "chassis 1"},
		{"mesh": preload("res://assets/models/chassis1.tres"), "color": Color(0.5, 0.5, 0.5), "name": "chassis 2"},
		{"mesh": preload("res://assets/models/chassis2.tres"), "color": Color(0.2, 0.2, 0.2), "name": "chassis 3"}
	]
}
