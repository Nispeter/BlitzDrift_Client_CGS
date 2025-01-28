extends Node

@export var tank_preview: NodePath
@export var tank_config: TankConfigData
var saved_resources: Dictionary = {}

@export var base_paths: Dictionary = {
	"cannon": NodePath(""),
	"turret": NodePath(""),
	"chassis": NodePath("")
}

@export var part_selectors: Dictionary = {
	"cannon": NodePath(""),
	"turret": NodePath(""),
	"chassis": NodePath("")
}

func _ready():
	setup_selectors()
	load_tank_resource()
	update_preview()

# Configura los nodos selectores para las partes del tanque
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

# Cambia la parte seleccionada
func change_part(part_name: String, direction: int):
	if not TankParts.tank_parts.has(part_name):  
		print("Part name not found:", part_name)
		return
	
	var options = TankParts.tank_parts[part_name]
	tank_config.selected_indices[part_name] = (tank_config.selected_indices[part_name] + direction) % options.size()
	if tank_config.selected_indices[part_name] < 0:
		tank_config.selected_indices[part_name] = options.size() - 1
	update_preview()

# Actualiza la vista previa en el nodo del tanque
func update_preview():
	if not tank_preview:
		print("Tank preview node path not set.")
		return
	
	var tank = get_node(tank_preview)
	for part_name in tank_config.selected_indices.keys():
		if not TankParts.tank_parts.has(part_name) or not base_paths.has(part_name):
			continue
		
		var base_node_path = base_paths[part_name]
		var base_node = tank.get_node(base_node_path)
		if not base_node:
			print("Base node not found for:", part_name)
			continue
		
		var part_options = TankParts.tank_parts[part_name]
		var selected_option = part_options[tank_config.selected_indices[part_name]]
		base_node.mesh = selected_option["mesh"]
		base_node.material_override = StandardMaterial3D.new()
		base_node.material_override.albedo_color = selected_option["color"]

func save_tank():
	print("Saving tank resource to: ",TankParts.tank_loadout_fp )
	ResourceSaver.save(tank_config, TankParts.tank_loadout_fp)
	
func load_tank_resource() -> bool:
	if ResourceLoader.exists(TankParts.tank_loadout_fp):
		var tank_data = ResourceLoader.load(TankParts.tank_loadout_fp)
		if tank_data != null:
			print("Data loaded successfully.")
			tank_config = tank_data as TankConfigData
			return true
	return false
