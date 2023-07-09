class_name Pacman
extends AnimatedSprite2D

@export var speed : float
@export var coins_sound : Array[AudioStream]

@onready var tile_map : TileMap = $"../TileMap"
@onready var audio : AudioStreamPlayer2D = $Audio
@onready var ghost : Ghost = $"../Blinky"

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
		
	var _pos : Vector2i = pos + Constant.DIRECTION[_direction];
	return tile_map.get_cell_tile_data(Constant.BORDER, _pos) == null


func _move_to_direction(_direction : GameInput.Direction):
	pos += Constant.DIRECTION[_direction];
	self.play(Constant.DIRECTION_ANIMATION[_direction])
	
	_bridge_swap()
	
	_tween = create_tween()
	_tween.tween_property(self, ^"position", tile_map.map_to_local(pos), 1.0 / speed)
	_tween.tween_callback(func(): _collect_point(pos))
	_tween.tween_callback(func(): _collect_power_up(pos))
	_tween.tween_callback(func(): _tween = null)


func _collect_power_up(_pos : Vector2i):
	if tile_map.get_cell_tile_data(Constant.POWER_UP, _pos) != null:
		tile_map.erase_cell(Constant.POWER_UP, _pos)	
		ghost.rage_mode();


func _collect_point(_pos : Vector2i):
	if tile_map.get_cell_tile_data(Constant.POINT, _pos) != null:
		tile_map.erase_cell(Constant.POINT, _pos)	
		_play_collect_sound()


func _play_collect_sound():
	if audio.playing == false:
		audio.stream = coins_sound.pick_random();
		audio.play()


func _bridge_swap():
	if pos == Constant.LEFT_BRIDGE:
		position = tile_map.map_to_local(Constant.RIGHT_BRIDGE)
		pos = Constant.RIGHT_BRIDGE + Vector2i.LEFT
	elif pos == Constant.RIGHT_BRIDGE:
		position = tile_map.map_to_local(Constant.LEFT_BRIDGE)
		pos = Constant.LEFT_BRIDGE + Vector2i.RIGHT
