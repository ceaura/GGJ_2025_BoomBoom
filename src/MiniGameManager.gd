extends Node

# Tableau des scènes de mini-jeux
var mini_games = [
	{"path": "res://scenes/explication_spam.tscn", "played": false},
	{"path": "res://scenes/explication_qte.tscn", "played": false},
]

var final_score_scene_path = "res://scenes/finalScoreScreen.tscn"
var final_score_scene : PackedScene

var score_player_1 = 0
var score_player_2 = 0

func _ready():
	final_score_scene = load(final_score_scene_path)

func launch_random_minigame():
	var unplayed_games = []
	for mini_game in mini_games:
		if not mini_game["played"]:
			unplayed_games.append(mini_game)
	
	if unplayed_games.size() == 0:
		print("Tous les mini-jeux ont été joués.")
		all_mini_game_played()
		return

	var random_game = unplayed_games[randi() % unplayed_games.size()]
	
	for mini_game in mini_games:
		if mini_game["path"] == random_game["path"]:
			mini_game["played"] = true
			break
			
	var mini_game_scene = load(random_game["path"])
	if mini_game_scene:
		print(mini_game_scene.to_string())
		get_tree().change_scene_to_packed(mini_game_scene)
	else:
		print("Erreur : Impossible de charger la scène ", random_game["path"])

func all_mini_game_played():
	get_tree().change_scene_to_packed(final_score_scene)

# Réinitialiser les états des mini-jeux pour rejouer
func reset_minigames():
	score_player_1 = 0
	score_player_2 = 0
	for mini_game in mini_games:
		mini_game["played"] = false
	print("Tous les mini-jeux ont été réinitialisés.")
