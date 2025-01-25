extends Node
@onready var __game_manager__ = $"."
@onready var chrono = $"../Chrono"
@onready var spam_bubble = $"../SpamBubble1"
@onready var spam_bubble_2 = $"../SpamBubble2"

var val_scale_player_1 = 1.1
var val_scale_player_2 = 1.1

var add_scale_player_1 = 0.05
var add_scale_player_2 = 0.05

signal endgame

func _ready():
	chrono.connect("endgame", _on_endgame)
	
func _process(delta):
	var vector_player_1 = Vector2(val_scale_player_1,val_scale_player_1)
	var vector_player_2 = Vector2(val_scale_player_2,val_scale_player_2)
	if Input.is_action_just_pressed("spam_bubble") :		
		spam_bubble.scale = vector_player_1
		val_scale_player_1 += add_scale_player_1 
	if Input.is_action_just_pressed("spam_bubble2"):
		spam_bubble_2.scale = vector_player_2
		val_scale_player_2 += add_scale_player_2
	
func _on_endgame():
	compare_scale()

func compare_scale():
	if spam_bubble.get_scale() > spam_bubble_2.get_scale():
		print("player 1 win")
	elif spam_bubble.get_scale() < spam_bubble_2.get_scale():
		print("player 2 win")
	else: 
		print("egalité")
	MiniGameManager.launch_random_minigame()
	

# Launch start chrono 
func _on_cpu_particles_2d_2_finished():
	pass # Replace with function body.
