extends Node
@onready var cpu_particles_2d_2 = $CPUParticles2D2
@onready var cpu_particles_2d_3 = $CPUParticles2D3
@onready var cpu_particles_2d_4 = $CPUParticles2D4
@onready var cpu_particles_2d_5 = $CPUParticles2D5
@onready var cpu_particles_2d_6 = $CPUParticles2D6

func _ready():
	for child in get_children():
		if child is CPUParticles2D:
			child.emitting = true
