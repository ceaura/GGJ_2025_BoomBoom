extends PanelContainer

var is_ready: bool: 
	set = _set_is_ready

func _set_is_ready(value):
	is_ready = value
	if value:
		$VBoxContainer/Label.text = "READY"
	else:
		$VBoxContainer/Label.text = "PRESS A TO JOIN"
		
