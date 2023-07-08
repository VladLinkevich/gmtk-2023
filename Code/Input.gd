class_name GameInput
extends Node2D

@onready var pacman : Pacman = $"../Pacman"

enum Direction {NONE, LEFT, RIGHT, UP, DOWN}

var f  = {
	Direction.NONE : func(): print("none"),
	Direction.LEFT : func(): print("LEFT"),
	Direction.RIGHT : func(): print("RIGHT"),
	Direction.UP : func(): print("UP"),
	Direction.DOWN : func(): print("DOWN"),
} 

var direction = []

func _init() -> void:
	direction.push_back(Direction.NONE)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("down"):
		direction.push_back(Direction.DOWN)
		
	if Input.is_action_just_pressed("up"):
		direction.push_back(Direction.UP)
		
	if Input.is_action_just_pressed("left"):
		direction.push_back(Direction.LEFT)
		
	if Input.is_action_just_pressed("right"):
		direction.push_back(Direction.RIGHT)
		
	if Input.is_action_just_released("down"):
		direction.erase(Direction.DOWN)
		
	if Input.is_action_just_released("up"):
		direction.erase(Direction.UP)
		
	if Input.is_action_just_released("left"):
		direction.erase(Direction.LEFT)
		
	if Input.is_action_just_released("right"):
		direction.erase(Direction.RIGHT)
	
	pacman.set_direction(direction.back())
	
