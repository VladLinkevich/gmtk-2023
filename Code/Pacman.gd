class_name Pacman
extends AnimatedSprite2D

const BORDER : int = 0
const POINT : int = 1
const START_POSITION : Vector2i = Vector2i(10, 11)

const DIRECTION = {
	GameInput.Direction.DOWN : Vector2i.DOWN,
	GameInput.Direction.UP : Vector2i.UP,
	GameInput.Direction.RIGHT : Vector2i.LEFT,
	GameInput.Direction.LEFT : Vector2i.RIGHT,
}

const DIRECTION_ANIMATION = {
	GameInput.Direction.DOWN : "down",
	GameInput.Direction.UP : "up",
	GameInput.Direction.RIGHT : "left",
	GameInput.Direction.LEFT : "right",
}

@export var speed : float
@export var coins_sound : Array[AudioStream]

@onready var tile_map : TileMap = $"../TileMap"
@onready var audio : AudioStreamPlayer2D = $Audio

var _pos : Vector2i
var _tween : Tween
var _direction : GameInput.Direction

func _ready() -> void:
	_pos = START_POSITION;
	position = to_global(tile_map.map_to_local(_pos))


func _process(_delta: float) -> void:

	if _tween == null\
	and _check_position(_direction):
		_move_to_direction(_direction)

func set_direction(direction : GameInput.Direction):
	_direction = direction

func _check_position(direction : GameInput.Direction) -> bool:
	if direction == GameInput.Direction.NONE:
		return false
		
	var pos : Vector2i = _pos + DIRECTION[direction];
	return tile_map.get_cell_tile_data(BORDER, pos) == null


func _move_to_direction(direction : GameInput.Direction):
	_pos += DIRECTION[direction];
	self.play(DIRECTION_ANIMATION[direction])
	
	_tween = create_tween()
	_tween.tween_property(self, ^"position", 2 * tile_map.map_to_local(_pos), 1.0 / speed)
	_tween.tween_callback(func(): _collect_point(_pos))
	_tween.tween_callback(func(): _tween = null)


func _collect_point(pos : Vector2i):
	if tile_map.get_cell_tile_data(POINT, pos) != null:
		tile_map.erase_cell(POINT, pos)	
		_play_collect_sound()


func _play_collect_sound():
	if audio.playing == false:
		audio.stream = coins_sound.pick_random();
		audio.play()
