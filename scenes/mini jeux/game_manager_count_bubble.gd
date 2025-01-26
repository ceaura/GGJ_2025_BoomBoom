extends Node

@onready var particles = $"../IntroParticles/CPUParticles2D7"
@onready var answer_buttons = $"../Control/HBoxContainer"
@onready var result_label = $"../Control/HBoxContainer/Label"
@export var min_bubbles = 12
@export var max_bubbles = 15 
@export var total_bubbles = 8  

var bubbles_emitted = 0 
var is_game_active = false
var answers = []
var responses = {}  # Dictionnaire pour stocker les réponses des joueurs
@onready var audio_stream_player_2d = $"../AudioStreamPlayer2D"

@onready var bubble_player_2_group = $"../BubblePlayer2Group"
@onready var bubble_player_1_group = $"../BubblePlayer1Group"
@onready var refresh_timer = $"../RefreshTimer"
@onready var icon_dog = $"../Icon"
@onready var icon_cat = $"../Icon2"

var player_1_answers_amount = 0
var player_2_answers_amount = 0

func _ready():
	# Initialisation des valeurs
	
	particles.one_shot = true
	particles.emitting = false  
	start_game()

func start_game():
	# Réinitialiser le jeu
	total_bubbles = randi_range(min_bubbles, max_bubbles) 
	print(total_bubbles)
	answers = generate_answers()
	particles.amount = total_bubbles
	is_game_active = true
	bubbles_emitted = 0
	particles.emitting = true
	bubbles_emitted = particles.amount
	responses.clear()
	answer_buttons.visible = false
	icon_cat.visible = true
	icon_dog.visible = true
	icon_dog.refreshLabel()
	icon_cat.refreshLabel()

func generate_answers():
	var correct_answer = total_bubbles
	var answers = []

	# Ajoute la réponse correcte
	answers.append(correct_answer)

	# Génère 3 réponses incorrectes
	while answers.size() < 4:
		var random_answer = randi_range(correct_answer - 4, correct_answer + 4)  # Variation autour de la réponse correcte
		# Assure-toi que la réponse générée est unique
		if random_answer != correct_answer and random_answer not in answers:
			answers.append(random_answer)
	
	answers.shuffle()  # Mélange les réponses
	return answers
	
func randomize_button_answers():
	# Mélange les réponses et assigne les boutons
	answers.shuffle()
	var index = 1  
	for i in range(answer_buttons.get_child_count() - 1): 
		var button = answer_buttons.get_child(index)
		button.text = str(answers[i])
		index += 1  
	answer_buttons.visible = true

func _on_cpu_particles_2d_7_finished():
	# Quand les bulles finissent d'être émises, afficher les boutons
	randomize_button_answers()
	result_label.text = "Combien de bulles ?"


func end_game():
	# Affiche les résultats après les réponses des deux joueurs
	is_game_active = false
	
	# Vérifie les réponses pour chaque joueur
	for player_id in responses.keys():
		var player_answer = responses[player_id]
		print("Player " + str(player_id) + " Answer : " + str(player_answer))

		# Vérifie si la réponse est correcte et détruit un ballon
		if player_answer == total_bubbles:
			if player_id == 0:
				player_1_answers_amount += 1
				# Détruire un ballon pour player 1
				if bubble_player_1_group.get_child_count() > 0:
					bubble_player_1_group.get_child(0).queue_free() 
					audio_stream_player_2d.play() # Supprimer un ballon
			else:
				player_2_answers_amount += 1
				# Détruire un ballon pour player 2
				if bubble_player_2_group.get_child_count() > 0:
					bubble_player_2_group.get_child(0).queue_free()  # Supprimer un ballon
					audio_stream_player_2d.play() # Supprimer un ballo

	result_label.text = "Bonne réponse : " + str(total_bubbles)
	result_label.visible = true
	
	if player_1_answers_amount >=2 && player_2_answers_amount < 2 :
		MiniGameManager.score_player_1 += 1 
		MiniGameManager.launch_random_minigame()
	elif player_2_answers_amount >= 2 && player_1_answers_amount < 2  : 
		MiniGameManager.score_player_2 += 1 
		MiniGameManager.launch_random_minigame()
	elif player_1_answers_amount >= 2 && player_2_answers_amount >= 2 :
		MiniGameManager.score_player_1 += 1 
		MiniGameManager.score_player_2 += 1
		MiniGameManager.launch_random_minigame()
	refresh_timer.start(0)
	
# Gestion des clics de boutons
func _on_button_pressed():
	record_answer(int($"../Control/HBoxContainer/Button".text))

func _on_button_2_pressed():
	record_answer(int($"../Control/HBoxContainer/Button2".text))

func _on_button_3_pressed():
	record_answer(int($"../Control/HBoxContainer/Button3".text))

func _on_button_4_pressed():
	record_answer(int($"../Control/HBoxContainer/Button4".text))

func record_answer(selected_answer):
	# Enregistre les réponses via les boutons
	if not is_game_active or len(responses) >= 2:
		return
	
	# Si le joueur n'a pas encore répondu, enregistre sa réponse
	var player_id = len(responses)  # ID du joueur, 0 ou 1
	responses[player_id] = selected_answer

	# Vérifie si tous les joueurs ont répondu
	if len(responses) == 2:
		end_game()

func _on_refresh_timer_timeout():
	start_game()


				
