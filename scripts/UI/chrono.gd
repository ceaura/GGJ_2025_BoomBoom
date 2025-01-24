extends CanvasLayer

@onready var label = $Label
@onready var timer = $Timer
@export var amount_time = 10

signal endgame

### Only work for seconds now

func _ready():
	timer.wait_time = amount_time
	timer.start()

func time_left_to_endgame():
	var time_left = timer.time_left
	var second = int(time_left) % 60
	return second
	
func _process(delta):
	label.text = "%02d" % time_left_to_endgame()


func _on_timer_timeout():
	endgame.emit()
	queue_free()
