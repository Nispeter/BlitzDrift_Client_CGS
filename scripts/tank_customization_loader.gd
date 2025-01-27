extends Node

@export var file_path: String = "user://tank_config.json"
@export var base_paths := {
	"cannon": NodePath(""),
	"turret": NodePath(""),
	"chassis": NodePath("")
}

#TODO: Make it load on start game, and on open tank customization
func _ready():
	# load_configuration()
	pass

func load_configuration():
	if not FileAccess.file_exists(file_path):
		print("Configuration file not found at", file_path)
		return

	var file = FileAccess.open(file_path, FileAccess.READ)
	if file.error != OK:
		print("Failed to open configuration file:", file_path)
		return

	var config = JSON.parse_string(file.get_as_text())
	file.close()

	if config.error != OK:
		print("Failed to parse JSON from configuration file:", file_path)
		return

	var data = config.result

	for part_name in base_paths.keys():
		if not data.has(part_name):
			print("Configuration for part not found:", part_name)
			continue

		var base_node_path = base_paths[part_name]
		if not base_node_path:
			print("Base path not set for:", part_name)
			continue

		var base_node = get_node(base_node_path)
		if not base_node:
			print("Base node not found for:", part_name)
			continue

		var selected_part = data[part_name]
		if not selected_part.has("mesh") or not selected_part.has("color"):
			print("Invalid configuration for part:", part_name)
			continue

		base_node.mesh = ResourceLoader.load(selected_part["mesh"])
		base_node.material_override = StandardMaterial3D.new()
		var color_data = selected_part["color"]
		base_node.material_override.albedo_color = Color(color_data[0], color_data[1], color_data[2])

	print("Tank configuration loaded successfully.")
