class_name Pacman
extends AnimatedSprite2D

const BORDER : int = 0
const POINT : int = 1

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

var pos : Vector2i
var _tween : Tween
var direction : GameInput.Direction

func _ready() -> void:
	pos = Constant.PACMAN_START_POSITION;
	position = tile_map.map_to_local(pos)


func _process(_delta: float) -> void:

	if _tween == null\
	and _check_position(direction):
		_move_to_direction(direction)

func set_direction(_direction : GameInput.Direction):
	self.direction = _direction


func _check_position(_direction : GameInput.Direction) -> bool:
	if _direction == GameInput.Direction.NONE:
		return false
		
	var _pos : Vector2i = pos + DIRECTION[_direction];
	return tile_map.get_cell_tile_data(BORDER, _pos) == null


func _move_to_direction(_direction : GameInput.Direction):
	pos += DIRECTION[_direction];
	self.play(DIRECTION_ANIMATION[_direction])
	
	_tween = create_tween()
	_tween.tween_property(self, ^"position", tile_map.map_to_local(pos), 1.0 / speed)
	_tween.tween_callback(func(): _collect_point(pos))
	_tween.tween_callback(func(): _tween = null)


func _collect_point(_pos : Vector2i):
	if tile_map.get_cell_tile_data(POINT, _pos) != null:
		tile_map.erase_cell(POINT, _pos)	
		_play_collect_sound()


func _play_collect_sound():
	if audio.playing == false:
		audio.stream = coins_sound.pick_random();
		audio.play()
