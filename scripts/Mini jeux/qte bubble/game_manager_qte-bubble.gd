extends Node
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
@onready var timer_cooldown_player_1 = $"../TimerCooldownPlayer1"
@onready var timer_cooldown_player_2 = $"../TimerCooldownPlayer2"
@onready var bubble_explode = $"../BubbleExplode"

@onready var icon_cat = $"../Icon2"
@onready var icon_dog = $"../Icon"

@export var menu_scene : PackedScene
@export var cursor_speed = 500.0
var cursor_direction = 1  
var is_game_playing = false 
var is_player_1 = false
var player_1_can_shoot = true
var player_2_can_shoot = true

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
	if is_game_playing:
		if Input.is_action_just_pressed("spam_bubble") && player_1_can_shoot:
			is_player_1 = true
			check_success(is_player_1)
		if Input.is_action_just_pressed("spam_bubble2") && player_2_can_shoot:
			is_player_1 = false
			check_success(is_player_1)

func check_success(is_player_1):
	var cursor_center_x = cursor.position.x + cursor.size.x / 2
	if cursor_center_x >= target_zone.position.x and cursor_center_x <= target_zone.position.x + target_zone.size.x:
		if is_player_1:
			explode_balloon(player_1_balloons)
		else:
			explode_balloon2(player_2_balloons)
		randomize_target_zone()
		cursor_speed += 50.0  
	else:
		if is_player_1:
			player_1_can_shoot = false
			timer_cooldown_player_1.start(0)
		else:
			player_2_can_shoot = false
			timer_cooldown_player_2.start(0)
		randomize_target_zone()

func explode_balloon(balloon_container):
	if balloon_container.get_child_count() > 0:
		print(balloon_container.get_child_count())
		var balloon = balloon_container.get_child(0) 
		balloon.queue_free()  
		bubble_explode.play()
	if balloon_container.get_child_count() == 1:
		_on_endgame() 
		
func explode_balloon2(balloon_container):
	if balloon_container.get_child_count() > 0:
		print(balloon_container.get_child_count())
		var balloon = balloon_container.get_child(0) 
		balloon.queue_free()  
		bubble_explode.play()
	if balloon_container.get_child_count() == 2:
		_on_endgame() 

func randomize_target_zone():
	var left_limit = left_marker_barre.position.x
	var right_limit = right_marker_barre.position.x - target_zone.size.x

	var random_x = randf_range(left_limit, right_limit)
	target_zone.position.x = random_x

func _on_endgame():
	is_game_playing = false
	if player_1_balloons.get_child_count() == 1 && player_2_balloons.get_child_count() == 2:
		win_label.text = "DRAW"
	elif player_1_balloons.get_child_count() == 1:
		win_label.text = "Player 1 WIN"
		MiniGameManager.score_player_1 += 1
		icon_dog.refreshLabel()

	elif player_2_balloons.get_child_count() == 2:
		win_label.text = "Player 2 WIN"
		MiniGameManager.score_player_2 += 1
		icon_cat.refreshLabel()
	HUD.visible = false
	win_label.visible = true
	timer_next_level.start(0)

# Launch start chrono 
func _on_startgame():
	control.visible = false
	blur.visible = false
	HUD.visible = true
	is_game_playing = true
	audio_stream_player_2d_2.play()
	icon_cat.visible = true
	icon_dog.visible = true
	icon_dog.refreshLabel()
	icon_cat.refreshLabel()
	
	
# Launch start chrono 
func _on_cpu_particles_2d_2_finished():
	control.visible = true
	blur.visible = true
	timer.start(0)


func _on_timer_next_level_timeout():
	MiniGameManager.launch_random_minigame()

func _on_timer_cooldown_player_1_timeout():
	print(player_1_can_shoot)
	player_1_can_shoot = true
	

func _on_timer_cooldown_player_2_timeout():
	player_2_can_shoot = true


func _on_button_pressed():
	MiniGameManager.reset_minigames()
	get_tree().change_scene_to_packed(menu_scene)
