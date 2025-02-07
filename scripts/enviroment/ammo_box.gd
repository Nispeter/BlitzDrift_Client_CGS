extends collectible

@export var bounce_height: float = 0.1  
@export var bounce_speed: float = 2.5  

var initial_position: Vector3
var boosters = ["speed_boost", "shield", "score_up"] 
func _ready():
	super._ready() 
	initial_position = transform.origin  

func _process(delta):
	transform.origin.y = initial_position.y + sin(Time.get_ticks_msec() / 1000.0 * bounce_speed) * bounce_height

func collect(body:Node):
	if(body.has_method("_getBuff")):
		body._getBuff()
			
	
	
