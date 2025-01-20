extends Area3D

@export var boost_amount: float = 20.0   
@export var boost_duration: float = 5.0   

var boosted_tanks: Dictionary = {}

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _physics_process(delta: float) -> void:
	for tank in boosted_tanks.keys():
		boosted_tanks[tank] -= delta
		if boosted_tanks[tank] <= 0:
			_remove_boost(tank)

func _on_body_entered(body: Node) -> void:
	if body.has_node("Chassis"):
		var tank_chassis = body.find_child("Chassis")
		if tank_chassis.has_method("apply_speed_boost"): 
			if not boosted_tanks.has(body):  
				tank_chassis.apply_speed_boost(boost_amount)
				boosted_tanks[tank_chassis] = boost_duration

func _on_body_exited(body: Node) -> void:
	if boosted_tanks.has(body):
		_remove_boost(body)

func _remove_boost(tank: Node) -> void:
	if tank in boosted_tanks:
		if tank.has_method("apply_speed_boost"):
			tank.apply_speed_boost(-boost_amount) 
		boosted_tanks.erase(tank)
