extends Node
#NOTE: Global class that stores filepaths of customizable endpoints
var tank_loadout_fp = "user://tank_loadout.res"
var tank_parts = {
	"cannon": [
		{"mesh": preload("res://models/cannon1.tres"), "color": Color(0, 0, 1), "name": "cannon 1"},
		{"mesh": preload("res://models/cannon2.tres"), "color": Color(1, 0, 0), "name": "cannon 2"},
		{"mesh": preload("res://models/cannon2.tres"), "color": Color(1, 1, 0), "name": "cannon 3"}
	],
	"turret": [
		{"mesh": preload("res://models/turret1.tres"), "color": Color(1, 0, 0), "name": "turret 1"},
		{"mesh": preload("res://models/turret2.tres"), "color": Color(0, 1, 0), "name": "turret 2"}
	],
	"chassis": [
		{"mesh": preload("res://models/chassis1.tres"), "color": Color(0.5, 0.5, 0.5), "name": "chassis 1"},
		{"mesh": preload("res://models/chassis2.tres"), "color": Color(0.2, 0.2, 0.2), "name": "chassis 2"}
	]
}
