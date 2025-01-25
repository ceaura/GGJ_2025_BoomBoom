extends Control

@onready var timer = $Timer
@onready var audio_stream_player_2d = $"../AudioStreamPlayer2D"
@onready var audio_stream_player_2d_2 = $"../AudioStreamPlayer2D2"
@onready var HUD = $"../Controls"

@export var blur : TextureRect

signal startgame
var texture = preload("res://assets/sprites/icon/bubble/redStart.png")

var current_index = 0

func _on_timer_timeout():
	update_texture()
	play_audio()
	if current_index >= 7:
		timer.stop()

func update_texture():
	if current_index < 5:
		$HBoxContainer.get_child(current_index).texture = texture
	current_index += 1

func play_audio():
	if current_index < 6:
		audio_stream_player_2d.play()
	elif current_index == 6:
		for child in $HBoxContainer.get_children():
			child.visible = false
		startgame.emit()
		
		

	
	
		
