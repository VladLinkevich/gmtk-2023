class_name Constant
extends Node

const DIRECTION = {
	GameInput.Direction.DOWN : Vector2i.DOWN,
	GameInput.Direction.UP : Vector2i.UP,
	GameInput.Direction.RIGHT : Vector2i.LEFT,
	GameInput.Direction.LEFT : Vector2i.RIGHT,
}

const DIRECTION_ANIMATION = {
	GameInput.Direction.DOWN : "down",
	GameInput.Direction.UP : "up",
	GameInput.Direction.RIGHT : "right",
	GameInput.Direction.LEFT : "left",
}

const RAGE_ANIMATION = "ghost"
const RAGE_WHITE_ANIMATION = "ghost_white"

const BORDER : int = 0
const POINT : int = 1
const POWER_UP : int = 2

const RAGE_TIME = 8
const WHITE_GHOST_TIME_START_1 : float = 3
const WHITE_GHOST_TIME_START_2 : float = 2
const WHITE_GHOST_TIME_START_3 : float = 1
const WHITE_GHOST_TIME_END_1 : float = 2.5
const WHITE_GHOST_TIME_END_2 : float = 1.5
const WHITE_GHOST_TIME_END_3 : float = 0.5

const PACMAN_START_POSITION : Vector2i = Vector2i(10, 11)
const BLINK_START_POSITION : Vector2i = Vector2i(10, 7)
const LEFT_BRIDGE : Vector2i = Vector2i(-1, 9)
const RIGHT_BRIDGE : Vector2i = Vector2i(21, 9)
