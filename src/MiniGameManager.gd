extends Node

# Tableau des scènes de mini-jeux
var mini_games = [
	{"path": "res://scenes/mini jeux/qte bubble/qte_bubble_main.tscn", "played": false},
	{"path": "res://scenes/mini jeux/spam bubble/spam_bubble_main.tscn", "played": false},
]

var score_player_1 = 0
var score_player_2 = 0

func launch_random_minigame():
	var unplayed_games = []
	for mini_game in mini_games:
		if not mini_game["played"]:
			unplayed_games.append(mini_game)
	
	if unplayed_games.size() == 0:
		print("Tous les mini-jeux ont été joués.")
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

# Réinitialiser les états des mini-jeux pour rejouer
func reset_minigames():
	for mini_game in mini_games:
		mini_game["played"] = false
	print("Tous les mini-jeux ont été réinitialisés.")
