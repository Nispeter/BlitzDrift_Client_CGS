extends Node

@export var tank_preview: NodePath
#WARNING: how tf to make this file path global, now its repeating on tank_customization_loader
@export var file_path: String = "user://tank_config.json"


#TODO: eventualmente construir un resource para esto 

@export var base_paths := {
	"cannon": NodePath(""),
	"turret": NodePath(""),
	"chassis": NodePath("")
}

@export var part_selectors := {
	"cannon": NodePath(""),
	"turret": NodePath(""),
	"chassis": NodePath("")
}

# Indices seleccionados para cada parte
var selected_indices = {
	"cannon": 0,
	"turret": 0,
	"chassis": 0
}

# Opciones predefinidas para cada parte
var tank_parts = {
	"cannon": [
		{"mesh": preload("res://models/cannon1.tres"), "color": Color(0, 0, 1), "name": "cannon 1"},
		{"mesh": preload("res://models/cannon2.tres"), "color": Color(1, 1, 0), "name": "cannon 2"}
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

func _ready():
	update_preview()
	setup_selectors()
	
func setup_selectors():
	for part_name in part_selectors.keys():
		var selector_path = part_selectors[part_name]
		if not selector_path:
			print("Selector path not set for:", part_name)
			continue

		var selector = get_node(selector_path)
		if selector:
			selector.setup_selector(self, part_name)
		else:
			print("Selector node not found for:", part_name)

# Cambia la parte seleccionada según la entrada del usuario
func change_part(part_name: String, direction: int):
	if not tank_parts.has(part_name):
		print("Part name not found:", part_name)
		return
	
	var options = tank_parts[part_name]
	selected_indices[part_name] = (selected_indices[part_name] + direction) % options.size()
	if selected_indices[part_name] < 0:
		selected_indices[part_name] = options.size() - 1
	update_preview()

# Actualiza la vista previa en la escena 3D
func update_preview():
	if not tank_preview:
		print("Tank preview node path not set.")
		return
	
	var tank = get_node(tank_preview)
	for part_name in selected_indices.keys():
		if not tank_parts.has(part_name) or not base_paths.has(part_name):
			continue
		
		var base_node_path = base_paths[part_name]
		var base_node = tank.get_node(base_node_path)
		if not base_node:
			print("Base node not found for:", part_name)
			continue
		
		var part_options = tank_parts[part_name]
		var selected_option = part_options[selected_indices[part_name]]
		base_node.mesh = selected_option["mesh"]
		base_node.material_override = StandardMaterial3D.new()
		base_node.material_override.albedo_color = selected_option["color"]

# Guarda la configuración actual en un archivo
func save_configuration():
	var config = {}
	for part_name in selected_indices.keys():
		config[part_name] = selected_indices[part_name]
	var file = FileAccess.open(file_path, FileAccess.ModeFlags.WRITE)
	print("Saving tank configuration on: " + file_path)
	file.store_string(JSON.stringify(config))
	file.close()

# Carga una configuración guardada
func load_configuration():
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.ModeFlags.READ)
		if file:
			var content = file.get_as_text()
			file.close()
			var json = JSON.new()
			var parse_result = json.parse(content)
			if parse_result == OK:
				var config = json.data 
				for part_name in config.keys():
					selected_indices[part_name] = config[part_name]
				update_preview()
			else:
				print("Failed to parse JSON: ", parse_result)

# Cycle through las opciones
func cycle_part_option(part_name: String, direction: int):
	if not tank_parts.has(part_name):
		print("Part name not found:", part_name)
		return
	
	var options = tank_parts[part_name]
	selected_indices[part_name] = (selected_indices[part_name] + direction) % options.size()
	if selected_indices[part_name] < 0:
		selected_indices[part_name] = options.size() - 1
	
	update_preview()
