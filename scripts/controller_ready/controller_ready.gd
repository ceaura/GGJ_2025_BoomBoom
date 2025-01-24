extends Control

@onready var devices = [
	$HBoxContainer/Player1,
	$HBoxContainer/Player2
]

func _ready():
	for id in Input.get_connected_joypads():
		devices[id].visible = true
	Input.connect("joy_connection_changed",_on_Input_joy_connection_changed )
	
func _on_Input_joy_connection_changed(id,connected):
		devices[id].visible = connected

func _input(event):
	if event is InputEventJoypadButton:
		if event.button_index == JOY_BUTTON_A:
			if event.is_pressed():
				devices[event.device].is_ready = true
				
#func all_controls_ready():
	#for id in devices:
		#devices[id].is_ready
