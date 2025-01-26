extends CharacterBody2D

# Vitesse de déplacement
var speed = 200

func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("JoyAxisPlayer1") :		
		var input_vector = get_input_vector()
		apply_movement(input_vector)
		move_and_slide()
	
func get_input_vector():
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return input_vector.normalized() if input_vector.length() > 1 else input_vector
	
func apply_movement(input_vector):
	velocity.x = input_vector.x * speed
	velocity.y = input_vector.y * speed
