extends Node
class_name shootable

@export var health: int  

func die():
	get_parent().queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func take_damage(damage: int, bullet: Node) -> void:
	pass
