extends interactable
class_name collectible 

@export_group("collectible properties")
@export var deactivate_on_collect : bool = true

func _ready():
	print("created")
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	#hint_string = "pick up"M

func _on_body_entered(body: Node) -> void:
	print("entra")
	if body.has_node("Chassis"):
		var tank_chassis = body.find_child("Chassis")
		if(tank_chassis.has_node("Buff_Controller")):
			var buff_controlloer = tank_chassis.find_child("Buff_Controller")
			collect(buff_controlloer)
		if deactivate_on_collect: queue_free()
		
		
	
	
	
func collect(body:Node):
	pass
