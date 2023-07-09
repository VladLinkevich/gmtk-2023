class_name Ghost
extends AnimatedSprite2D

const START_POSITION : Vector2i = Vector2i(10, 11)

@export var speed : float
@export var rage_speed : float

@onready var tile_map : TileMap = $"../TileMap"
@onready var pacman : Pacman = $"../Pacman"

const INVERT_DIRECTION = {
	GameInput.Direction.NONE : GameInput.Direction.NONE,
	GameInput.Direction.UP : GameInput.Direction.DOWN,
	GameInput.Direction.DOWN : GameInput.Direction.UP,
	GameInput.Direction.LEFT : GameInput.Direction.RIGHT,
	GameInput.Direction.RIGHT : GameInput.Direction.LEFT,
}

var _rage : bool
var _rage_time : float
var _tween : Tween
var pos : Vector2i
var direction : GameInput.Direction


func _ready() -> void:
	pos = Constant.BLINK_START_POSITION;
	position = tile_map.map_to_local(pos)
	_update_direction()


func _process(delta: float) -> void:
	if _rage:
		_rage_time -= delta
		if _rage_time < 0:
			_rage = false

func rage_mode():
	_rage = true
	_rage_time = Constant.RAGE_TIME
	direction = GameInput.Direction.NONE

func _select_target_direction(_target_pos : Vector2i) -> GameInput.Direction:
	
	var target = []
	
	if pos.x > _target_pos.x:
		target.push_front(GameInput.Direction.RIGHT if _rage == false else GameInput.Direction.LEFT)
	if pos.x < _target_pos.x:
		target.push_front(GameInput.Direction.LEFT if _rage == false else GameInput.Direction.RIGHT)
	if pos.y < _target_pos.y:
		target.push_front(GameInput.Direction.DOWN if _rage == false else GameInput.Direction.UP)
	if pos.y > _target_pos.y:
		target.push_front(GameInput.Direction.UP if _rage == false else GameInput.Direction.DOWN)
	
	var flag = [GameInput.Direction.DOWN, GameInput.Direction.UP, GameInput.Direction.RIGHT, GameInput.Direction.LEFT]
	target.erase(INVERT_DIRECTION[direction])
	flag.erase(INVERT_DIRECTION[direction])

	if _check_position(GameInput.Direction.DOWN) == false:
		target.erase(GameInput.Direction.DOWN)
		flag.erase(GameInput.Direction.DOWN)
		
	if _check_position(GameInput.Direction.UP) == false:
		target.erase(GameInput.Direction.UP)
		flag.erase(GameInput.Direction.UP)
		
	if _check_position(GameInput.Direction.RIGHT) == false:
		target.erase(GameInput.Direction.RIGHT)
		flag.erase(GameInput.Direction.RIGHT)
		
	if _check_position(GameInput.Direction.LEFT) == false:
		target.erase(GameInput.Direction.LEFT)
		flag.erase(GameInput.Direction.LEFT)
	
	if target.size() != 0:
		return target.pick_random()
		
	return flag.pick_random()
	
func _check_position(_direction : GameInput.Direction) -> bool:
	if _direction == GameInput.Direction.NONE:
		return false
		
	var _pos : Vector2i = pos + Constant.DIRECTION[_direction];
	return tile_map.get_cell_tile_data(Constant.BORDER, _pos) == null

func _update_direction():
	direction = _select_target_direction(pacman.pos)
	_move_to(direction)

func _move_to(_direction : GameInput.Direction):
	pos += Constant.DIRECTION[_direction];
		
	_select_animation(Constant.DIRECTION_ANIMATION[_direction])
	_bridge_swap()

	_tween = create_tween()
	_tween.tween_property(self, ^"position", tile_map.map_to_local(pos), 1.0 / (rage_speed if _rage else speed))
	_tween.tween_callback(func(): _update_direction())
	_tween.tween_callback(func(): _tween = null)


func _select_animation(anim):
	if _rage == false:
		self.play(anim)
	else:
		if (_rage_time < Constant.WHITE_GHOST_TIME_START_1 and _rage_time > Constant.WHITE_GHOST_TIME_END_1)\
		or (_rage_time < Constant.WHITE_GHOST_TIME_START_2 and _rage_time > Constant.WHITE_GHOST_TIME_END_2)\
		or (_rage_time < Constant.WHITE_GHOST_TIME_START_3 and _rage_time > Constant.WHITE_GHOST_TIME_END_3):
			self.play(Constant.RAGE_WHITE_ANIMATION)
		else:
			self.play(Constant.RAGE_ANIMATION)
		

func _bridge_swap():
	if pos == Constant.LEFT_BRIDGE:
		position = tile_map.map_to_local(Constant.RIGHT_BRIDGE)
		pos = Constant.RIGHT_BRIDGE + Vector2i.LEFT
	elif pos == Constant.RIGHT_BRIDGE:
		position = tile_map.map_to_local(Constant.LEFT_BRIDGE)
		pos = Constant.LEFT_BRIDGE + Vector2i.RIGHT
