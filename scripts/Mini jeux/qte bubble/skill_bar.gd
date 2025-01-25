extends Panel

@onready var cursor = $Curseur
@onready var target_zone = $"Zone cible"
@onready var bar = $Barre
@onready var right_marker_barre = $RightMarkerBarre
@onready var left_marker_barre = $LeftMarkerBarre

@export var cursor_speed = 400.0  # Vitesse du curseur
var cursor_direction = 1  # Direction de déplacement (1 = droite, -1 = gauche)
var is_active = true  # Mini-jeu actif ou non

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
	
	if Input.is_action_just_pressed("spam_bubble"):
		check_success()
	if Input.is_action_just_pressed("ui_accept"):
		randomize_target_zone()


func check_success():
	# Vérifie si le curseur est dans la zone cible
	var cursor_center_x = cursor.position.x + cursor.size.x / 2
	if cursor_center_x >= target_zone.position.x and cursor_center_x <= target_zone.position.x + target_zone.size.x:
		print("Succès !")
		is_active = false
		# Lancer un autre effet ou passer à la suite
	else:
		print("Échec !")
		is_active = false
	randomize_target_zone()
		
func randomize_target_zone():
	# Calcule les limites pour positionner la zone cible
	var left_limit = left_marker_barre.position.x
	var right_limit = right_marker_barre.position.x - target_zone.size.x

	# Définit une position aléatoire pour la zone cible
	var random_x = randf_range(left_limit, right_limit)
	target_zone.position.x = random_x
