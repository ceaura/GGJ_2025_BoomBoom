extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@export var controller_selection : PackedScene

func _ready():
	animated_sprite_2d.play("idle")

func _on_play_pressed():
	get_tree().change_scene_to_packed(controller_selection)


func _on_quit_button_down():
	get_tree().quit()
