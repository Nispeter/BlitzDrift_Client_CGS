extends shootable


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func take_damage(damage: int, bullet: Node) -> void:
	var turret  = bullet.get_parent()
	if(turret.has_method("_getBuff")):
		turret._getBuff()
	print("mhmmmmhm")
	die()
