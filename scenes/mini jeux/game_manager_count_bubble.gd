extends Node

@onready var particles = $"../IntroParticles/CPUParticles2D7"
@onready var result_label = $"../Control/HBoxContainer/Label"
@export var min_bubbles = 12
@export var max_bubbles = 15 
@export var total_bubbles = -1 
@onready var timer_n_ext_level = $"../TimerNExtLevel"

var bubbles_emitted = 0 
var is_game_active = false

@onready var audio_stream_player_2d = $"../AudioStreamPlayer2D"
@onready var bubble_player_2_group = $"../BubblePlayer2Group"
@onready var bubble_player_1_group = $"../BubblePlayer1Group"
@onready var refresh_timer = $"../RefreshTimer"
@onready var icon_dog = $"../Icon"
@onready var icon_cat = $"../Icon2"
@onready var label = $"../Label"

var player_1_answers_amount = 0
var player_2_answers_amount = 0
var player_1_count = 0
var player_2_count = 0

func _ready():
	# Initialisation des valeurs
	particles.one_shot = true
	particles.emitting = false  
	refresh_timer.start(0)

func _input(event):
	if is_game_active: 
		if Input.is_action_just_pressed("spam_bubble") :		
			player_1_count += 1
		if Input.is_action_just_pressed("spam_bubble2"):
			player_2_count += 1
			
func start_game():
	# Réinitialiser le jeu
	total_bubbles = randi_range(min_bubbles, max_bubbles) 
	print(total_bubbles)
	particles.amount = total_bubbles
	is_game_active = true
	bubbles_emitted = 0
	particles.emitting = true
	bubbles_emitted = particles.amount
	result_label.visible = false
	icon_cat.visible = true
	icon_dog.visible = true
	icon_dog.refreshLabel()
	icon_cat.refreshLabel()
	player_1_count = 0
	player_2_count = 0

func _on_cpu_particles_2d_7_finished():
	# Fin du jeu, affichage des scores
	is_game_active = false
	if total_bubbles == -1:
		result_label.text = "Comptez les bulles !"
	else :
		result_label.text = "Score Chien : %d | Score Chat : %d | Total bulles : %d" % [player_1_count, player_2_count, total_bubbles]
		
	result_label.visible = true
	# Vérifie si la réponse est correcte et détruit un ballon
	if player_1_count == total_bubbles:
		player_1_answers_amount += 1
		# Détruire un ballon pour player 1
		if bubble_player_1_group.get_child_count() > 0:
			bubble_player_1_group.get_child(0).queue_free() 
			audio_stream_player_2d.play() # Supprimer un ballon
	if player_2_count == total_bubbles:
		player_2_answers_amount += 1
			# Détruire un ballon pour player 2
		if bubble_player_2_group.get_child_count() > 0:
			bubble_player_2_group.get_child(0).queue_free()  
			audio_stream_player_2d.play() # Supprimer un ballon
	
	# Check if the mini game is finished 
	if player_1_answers_amount >=2 && player_2_answers_amount < 2 :
		MiniGameManager.score_player_1 += 1 
		timer_n_ext_level.start(0)
		label.text = "VICTOIRE DU CHIEN"
		icon_dog.refreshLabel()
		label.visible = true
		
	elif player_2_answers_amount >= 2 && player_1_answers_amount < 2  : 
		MiniGameManager.score_player_2 += 1 
		timer_n_ext_level.start(0)
		label.text = "VICTOIRE DU CHAT"
		icon_cat.refreshLabel()
		label.visible = true

	elif player_1_answers_amount >= 2 && player_2_answers_amount >= 2 :
		MiniGameManager.score_player_1 += 1 
		MiniGameManager.score_player_2 += 1
		timer_n_ext_level.start(0)
		label.text = "EGALITE"
		label.visible = true
		
	refresh_timer.start(0)

func _on_refresh_timer_timeout():
	start_game()

func _on_timer_n_ext_level_timeout():
	MiniGameManager.launch_random_minigame()
