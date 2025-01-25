extends Control

@onready var label = $VBoxContainer/Label

func refreshLabel():
	if label != null :
		label.text = str(MiniGameManager.score_player_2)
