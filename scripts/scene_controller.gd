extends Node

@export var scene_paths: Dictionary = {
	"Main": "res://scenes/main.tscn",
	"TankCustomization": "res://scenes/tank_customization.tscn",
	"MainMenu": "res://scenes/main_menu.tscn"
}

# Change to the specified scene by name
func change_scene(scene_name: String):
	if not scene_paths.has(scene_name):
		print("Error: Scene name not found in paths.")
		return

	var scene_path = scene_paths[scene_name]
	# var new_scene = ResourceLoader.load(scene_path)

	get_tree().change_scene_to_file(scene_path)
	print("Scene changed to", scene_name)

func to_main_menu():
	change_scene("MainMenu")
	
func to_main():
	change_scene("Main")
	
func to_tank_customization():
	change_scene("TankCustomization")
