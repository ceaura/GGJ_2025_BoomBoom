extends Node

func _ready():
	for child in get_children():
		if child is CPUParticles2D:
			child.emitting = true
