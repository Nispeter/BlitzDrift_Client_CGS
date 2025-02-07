extends Node

var points = 0
@export var speedBuffAmount = 20
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _getBuff():
	var random_value = randi() % 3  #CAmbiar esto por una lista de buffs?
	
	match random_value:
		0:
			var chasis = get_parent()
			if chasis and chasis.has_method("apply_speed_boost"):  
				chasis.apply_speed_boost(speedBuffAmount) 
				print("speeeed")
			
		1:
			_addPoints(500)
			print("Puntos up")
		2:
			print("shieldBuff")
		_:
			print("???????")


func _addPoints(pointsBuff: int):
	points += pointsBuff
	print(points)
