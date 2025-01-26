extends Node2D

@export var menu_scene : PackedScene
# En fonction du score choisir le bon fond et le bon label
# Called when the node enters the scene tree for the first time.
func _ready():
	if MiniGameManager.score_player_1 > MiniGameManager.score_player_2 : 
		print("victoire 1 ! ")
	elif MiniGameManager.score_player_1 < MiniGameManager.score_player_2 : 
		print("victoire 2 ! ")
	else : 
		print("draw")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	MiniGameManager.reset_minigames()
	get_tree().change_scene_to_packed(menu_scene)
