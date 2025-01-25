extends Node
@onready var __game_manager__ = $"."
@onready var spam_bubble = $"../QteBubble"
@onready var spam_bubble_2 = $"../QteBubble2"

@onready var target_zone = $"../Skill bar/Panel/Zone cible"
@onready var cursor = $"../Skill bar/Panel/Curseur"
@onready var bar = $"../Skill bar/Panel/Barre"
@onready var left_marker_barre = $"../Skill bar/Panel/LeftMarkerBarre"
@onready var right_marker_barre = $"../Skill bar/Panel/RightMarkerBarre"

@onready var player_1_balloons = $"../Player1Bubbles"
@onready var player_2_balloons = $"../Player2Bubbles"

@export var cursor_speed = 400.0  # Vitesse du curseur
var cursor_direction = 1  # Direction de déplacement (1 = droite, -1 = gauche)
var is_active = true  # Mini-jeu actif ou non
var is_player_1 = false

signal endgame  # Signal déclenché à la fin du jeu

func _ready():
	randomize_target_zone()

func _process(delta):
	var cursor_position = cursor.position
	cursor_position.x += cursor_speed * cursor_direction * delta
	var left_limit = left_marker_barre.position.x
	var right_limit = right_marker_barre.position.x - cursor.size.x

	if cursor_position.x <= left_limit or cursor_position.x >= right_limit:
		cursor_direction *= -1
	cursor.position = cursor_position
	
	# Détecte les entrées des joueurs
	if Input.is_action_just_pressed("spam_bubble"):
		is_player_1 = true
		check_success(is_player_1)
	if Input.is_action_just_pressed("spam_bubble2"):
		is_player_1 = false
		check_success(is_player_1)

func check_success(is_player_1):
	# Vérifie si le curseur est dans la zone cible
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
	# Explose un ballon dans le conteneur
	if balloon_container.get_child_count() > 0:
		var balloon = balloon_container.get_child(0)  # Prend le premier ballon
		balloon.queue_free()  # Détruit le ballon
		if balloon_container.get_child_count() == 0:
			emit_signal("endgame")  # Plus de ballons, déclenche la fin du jeu

func randomize_target_zone():
	# Calcule les limites pour positionner la zone cible
	var left_limit = left_marker_barre.position.x
	var right_limit = right_marker_barre.position.x - target_zone.size.x

	# Définit une position aléatoire pour la zone cible
	var random_x = randf_range(left_limit, right_limit)
	target_zone.position.x = random_x

func _on_endgame():
	print("Le signal endgame a été reçu ! Le jeu est terminé.")
	if player_1_balloons.get_child_count() == 0:
		print("Player 2 gagne !")
	elif player_2_balloons.get_child_count() == 0:
		print("Player 1 gagne !")
