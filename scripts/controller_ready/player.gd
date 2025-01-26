extends PanelContainer

var is_ready: bool: 
	set = _set_is_ready

@export var is_explaination = false

func _set_is_ready(value):
	is_ready = value
	if value:
		$VBoxContainer/Label.text = "PRÊT"
	else:
		if is_explaination:
			$VBoxContainer/Label.text = "APPUIE A POUR SKIP"
		else: 
			$VBoxContainer/Label.text = "APPUIE SUR A POUR JOIN"
			
		
