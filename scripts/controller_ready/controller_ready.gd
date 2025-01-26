extends Control

@onready var audio_stream_player_login = $AudioStreamPlayerLogin
@onready var devices = [
	$HBoxContainer/Player1,
	$HBoxContainer/Player2
]
@onready var main_label = $MainLabel
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	for id in Input.get_connected_joypads():
		devices[id].visible = true
	Input.connect("joy_connection_changed",_on_Input_joy_connection_changed )
	
func _on_Input_joy_connection_changed(id,connected):
		devices[id].visible = connected
		main_label.visible = false
		

func _input(event):
	if event is InputEventJoypadButton:
		if event.button_index == JOY_BUTTON_A:
			if event.is_pressed():
				devices[event.device].is_ready = true
				all_controls_ready()
				
func all_controls_ready():
	var ready_count = 0
	for device in devices:
		if device.is_ready:
			ready_count += 1
	if ready_count >= 2:
		MiniGameManager.launch_random_minigame()
