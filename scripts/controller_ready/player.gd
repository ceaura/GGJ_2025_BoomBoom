extends PanelContainer

var is_ready: bool: 
	set = _set_is_ready

@export var is_explaination = false

func _set_is_ready(value):
	is_ready = value
	if value:
		$VBoxContainer/Label.text = "READY"
	else:
		if is_explaination:
			$VBoxContainer/Label.text = "PRESS A TO SKIP"
		else: 
			$VBoxContainer/Label.text = "PRESS A TO JOIN"
			
		
