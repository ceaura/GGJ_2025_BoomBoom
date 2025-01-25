extends Node
@onready var __game_manager__ = $"."
@onready var spam_bubble = $"../QteBubble"
@onready var spam_bubble_2 = $"../QteBubble2"

@onready var target_zone = $"../Controls/Panel/Zone cible"
@onready var cursor = $"../Controls/Panel/Curseur"
@onready var bar = $"../Controls/Panel/Barre"
@onready var left_marker_barre = $"../Controls/Panel/LeftMarkerBarre"
@onready var right_marker_barre = $"../Controls/Panel/RightMarkerBarre"

@onready var player_1_balloons = $"../Player1Bubbles"
@onready var player_2_balloons = $"../Player2Bubbles"

@onready var timer = $"../StartGame/Timer"
@onready var control = $"../StartGame"
@onready var blur = $"../Player2Bubbles/Blur"
@onready var HUD = $"../Controls"
@onready var audio_stream_player_2d_2 = $"../AudioStreamPlayer2D2"
@onready var win_label = $"../WinLabel"
@onready var timer_next_level = $"../TimerNextLevel"

@export var cursor_speed = 400.0
var cursor_direction = 1  
var is_active = true 
var is_player_1 = false

signal startgame 

func _ready():
	randomize_target_zone()
	control.connect("startgame", _on_startgame)


func _process(delta):
	var cursor_position = cursor.position
	cursor_position.x += cursor_speed * cursor_direction * delta
	var left_limit = left_marker_barre.position.x
	var right_limit = right_marker_barre.position.x - cursor.size.x

	if cursor_position.x <= left_limit or cursor_position.x >= right_limit:
		cursor_direction *= -1
	cursor.position = cursor_position
	if Input.is_action_just_pressed("spam_bubble"):
		is_player_1 = true
		check_success(is_player_1)
	if Input.is_action_just_pressed("spam_bubble2"):
		is_player_1 = false
		check_success(is_player_1)

func check_success(is_player_1):
	var cursor_center_x = cursor.position.x + cursor.size.x / 2
	if cursor_center_x >= target_zone.position.x and cursor_center_x <= target_zone.position.x + target_zone.size.x:
		print("Succès !")
		if is_player_1:
			explode_balloon(player_1_balloons)
		else:
			explode_balloon(player_2_balloons)
		randomize_target_zone()
	else:
		print("Échec !")
		randomize_target_zone()

func explode_balloon(balloon_container):
	if balloon_container.get_child_count() > 0:
		var balloon = balloon_container.get_child(0) 
		balloon.queue_free()  
	print(balloon_container.get_child_count())
	if balloon_container.get_child_count() == 1:
		_on_endgame() 

func randomize_target_zone():
	var left_limit = left_marker_barre.position.x
	var right_limit = right_marker_barre.position.x - target_zone.size.x

	var random_x = randf_range(left_limit, right_limit)
	target_zone.position.x = random_x

func _on_endgame():
	if player_1_balloons.get_child_count() == 1 && player_2_balloons.get_child_count() == 1:
		win_label.text = "DRAW"
	elif player_1_balloons.get_child_count() == 1:
		win_label.text = "Player 1 WIN"
	elif player_2_balloons.get_child_count() == 1:
		win_label.text = "Player 2 WIN"
	HUD.visible = false
	win_label.visible = true
	timer_next_level.start(0)

# Launch start chrono 
func _on_startgame():
	control.visible = false
	blur.visible = false
	HUD.visible = true
	audio_stream_player_2d_2.play()
	
# Launch start chrono 
func _on_cpu_particles_2d_2_finished():
	control.visible = true
	blur.visible = true
	timer.start(0)


func _on_timer_next_level_timeout():
	MiniGameManager.launch_random_minigame()
