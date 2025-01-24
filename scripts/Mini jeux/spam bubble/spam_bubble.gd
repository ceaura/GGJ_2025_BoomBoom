extends AnimatedSprite2D

enum PlayerID{
	Player1,
	Player2
}
@onready var spam_bubble = $"."

var valScale = 2.5

@export var playerId = PlayerID.Player1

# Called when the node enters the scene tree for the first time.	
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var vec = Vector2(valScale,valScale)
	if Input.is_action_just_pressed("spam_bubble") && playerId == PlayerID.Player1:		
		spam_bubble.scale = vec
		valScale += 0.5 
	if Input.is_action_just_pressed("spam_bubble") && playerId == PlayerID.Player2:
		spam_bubble.scale = vec
		valScale += 0.5 
	
