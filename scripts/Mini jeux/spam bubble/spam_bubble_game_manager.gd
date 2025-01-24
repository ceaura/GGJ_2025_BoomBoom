extends Node

signal endgame

@onready var __game_manager__ = $"."
@onready var chrono = $"../Chrono"

@onready var player1 = $"../SpamBubble"
@onready var player2 = $"../SpamBubble2"

func _ready():
	chrono.connect("endgame", _on_endgame)

func _on_endgame():
	print("Le signal endgame a été reçu ! Le jeu est terminé.")
	compare_scale()

func compare_scale():
	if player1.get_scale() > player2.get_scale():
		print("player 1 win")
	elif player1.get_scale() < player2.get_scale():
		print("player 2 win")
	else: 
		print("egalité")
		
func _on_game_timer_timeout():
	pass # Replace with function body.
