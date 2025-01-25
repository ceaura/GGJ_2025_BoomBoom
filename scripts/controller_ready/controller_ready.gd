extends Control

@onready var devices = [
	$HBoxContainer/Player1,
	$HBoxContainer/Player2
]

@export var selection_level_scene = PackedScene.new()

func _ready():
	for id in Input.get_connected_joypads():
		devices[id].visible = true
		print(devices[id])
	Input.connect("joy_connection_changed",_on_Input_joy_connection_changed )
	
func _on_Input_joy_connection_changed(id,connected):
		devices[id].visible = connected

func _input(event):
	if event is InputEventJoypadButton:
		if event.button_index == JOY_BUTTON_A:
			if event.is_pressed():
				devices[event.device].is_ready = true
				print(devices[event.device])
				all_controls_ready()
				
func all_controls_ready():
	var ready_count = 0
	for device in devices:
		if device.is_ready:
			ready_count += 1
	if ready_count >= 2:
		print("All controls are ready!")
		get_tree().change_scene_to_packed(selection_level_scene)
