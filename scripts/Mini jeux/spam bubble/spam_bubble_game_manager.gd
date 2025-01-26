extends Node
@onready var chrono = $"../Chrono"
@onready var spam_bubble = $"../SpamBubble1"
@onready var spam_bubble_2 = $"../SpamBubble2"
@onready var timer = $"../Control/Timer"
@onready var control = $"../Control"

var val_scale_player_1 = 1.1
var val_scale_player_2 = 1.1

var add_scale_player_1 = 0.05
var add_scale_player_2 = 0.05

@onready var audio_stream_player_2d_2 = $"../AudioStreamPlayer2D2"
@onready var win_label = $"../WinLabel"
@onready var timer_next_level = $"../TimerNextLevel"
@onready var icon_dog = $"../Icon"
@onready var icon_cat = $"../Icon2"

var is_game_playing = false

@export var menu_scene : PackedScene

func _ready():
	chrono.connect("endgame", _on_endgame)
	control.connect("startgame", _on_startgame)

	
func _process(delta):
	var vector_player_1 = Vector2(val_scale_player_1,val_scale_player_1)
	var vector_player_2 = Vector2(val_scale_player_2,val_scale_player_2)
	if is_game_playing: 
		if Input.is_action_just_pressed("spam_bubble") :		
			spam_bubble.scale = vector_player_1
			val_scale_player_1 += add_scale_player_1 
		if Input.is_action_just_pressed("spam_bubble2"):
			spam_bubble_2.scale = vector_player_2
			val_scale_player_2 += add_scale_player_2
	
func _on_endgame():
	is_game_playing = false
	compare_scale()
	
func _on_startgame():
	audio_stream_player_2d_2.play()
	chrono.visible = true
	control.visible = false
	icon_cat.visible = true
	icon_dog.visible = true
	icon_dog.refreshLabel()
	icon_cat.refreshLabel()
	is_game_playing = true

func compare_scale():
	if spam_bubble.get_scale() > spam_bubble_2.get_scale():
		win_label.text = "PLAYER 1 WIN"
		MiniGameManager.score_player_1 += 1
		icon_dog.refreshLabel()

	elif spam_bubble.get_scale() < spam_bubble_2.get_scale():
		win_label.text = "PLAYER 2 WIN"
		MiniGameManager.score_player_2 += 1
		icon_cat.refreshLabel()
	else: 
		win_label.text = "DRAW"
	win_label.visible = true
	chrono.visible = false
	timer_next_level.start(0)

# Launch start chrono 
func _on_cpu_particles_2d_2_finished():
	control.visible = true
	timer.start(0)


func _on_timer_next_level_timeout():
	MiniGameManager.launch_random_minigame()


func _on_button_pressed():
	MiniGameManager.reset_minigames()
	get_tree().change_scene_to_packed(menu_scene)
