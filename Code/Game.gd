extends Node2D

@onready var pacman : Pacman = $Pacman
@onready var ghost : Ghost = $Blinky
@onready var win : Control = $Control

func _process(delta: float) -> void:
	if pacman.pos == ghost.pos:
		if ghost.is_rage():
			ghost.catched()
		else:
			win.show()
