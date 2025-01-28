extends Node

@export var tank_config: TankConfigData
@export var base_paths := {
	"cannon": NodePath(""),
	"turret": NodePath(""),
	"chassis": NodePath("")
}

var file_path: String = TankParts.tank_loadout_fp

func _ready():
	if load_tank_resource():
		apply_tank_parts()

func load_tank_resource() -> bool:
	if ResourceLoader.exists(TankParts.tank_loadout_fp):
		var tank_data = ResourceLoader.load(TankParts.tank_loadout_fp)
		if tank_data != null:
			print("Data loaded successfully.")
			tank_config = tank_data as TankConfigData
			return true
	return false

func apply_tank_parts():
	for part_type in ["cannon", "turret", "chassis"]:
		if part_type in TankParts.tank_parts and part_type in tank_config.selected_indices:
			var part_index = tank_config.selected_indices[part_type]
			var part_data = TankParts.tank_parts[part_type][part_index]
			
			if part_data.has("mesh") and base_paths[part_type] != NodePath(""):
				var part_node = get_node(base_paths[part_type])
				if part_node and part_node is MeshInstance3D:
					part_node.mesh = part_data["mesh"]
					part_node.material_override = create_material_with_color(part_data["color"])
					print("Applied part: ", part_data["name"], " at ", part_type)

func create_material_with_color(color: Color) -> Material:
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	return material
