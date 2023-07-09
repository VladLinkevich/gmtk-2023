extends Control

@onready var button : Button = $Win/Button

func _ready() -> void:
	button.button_down.connect(_restart_scene)
	

func _restart_scene():
	get_tree().reload_current_scene()
