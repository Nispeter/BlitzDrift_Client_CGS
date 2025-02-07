@tool
extends Path3D

@export var spawn_node: Node
@export_range(1,20) var targets_count:
	set(value):
		targets_count = value
		spawn_target()
	get: return targets_count
	
func spawn_target():
	var offsets = []
	
	#estas 2 variables son los puntos de la curva y sus vectores para spawnear objetos a lo largo de esta
	var points = curve.get_baked_points()
	var upvectors = curve.get_baked_up_vectors()
	print_tree()
	if spawn_node:
		for child in spawn_node.get_children():
			child.free()	
	else:
		print("Error: Nodo Spawn no asignado.")
			
	for i in range(targets_count):
		offsets.append(float(i)/float(targets_count+1))
		
	for offset in range(offsets.size()):
		var idx = clamp(int(points.size()*(offsets[offset])),0,points.size()-1)
		var point  = points[idx]
		var upVector = upvectors[idx]
		
		var target_ = Node3D.new()
		if spawn_node:
			
			target_.name = "target"
			spawn_node.add_child(target_)
			target_.translate(point)
		else:
			print("Error: spawn_node no asignado.")
		
		var breakableBox = preload("res://scenes/Enviroment/breakable_box.tscn").instantiate()
		breakableBox.name = "caja"
		target_.add_child(breakableBox)
		
		
		target_.position = point + Vector3(0,1,0)
		
		if(idx+1>points.size()-1):
			target_.look_at(points[0], upVector)
		else:
			target_.look_at_from_position(target_.position, points[idx + 1], upVector)

		
		target_.set_owner(get_tree().get_edited_scene_root())
		breakableBox.set_owner(get_tree().get_edited_scene_root())
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
