extends Node2D
@onready var label = $Label

@export var menu_scene : PackedScene
# En fonction du score choisir le bon fond et le bon label
# Called when the node enters the scene tree for the first time.
func _ready():
	if MiniGameManager.score_player_1 > MiniGameManager.score_player_2 : 
		label.text  = "VICTOIRE DU CHIEN"
	elif MiniGameManager.score_player_1 < MiniGameManager.score_player_2 : 
		label.text = "VICTOIRE DU CHAT"
	else : 
		label.text = "ÉGALITÉ"

func _on_button_pressed():
	MiniGameManager.reset_minigames()
	get_tree().change_scene_to_packed(menu_scene)
