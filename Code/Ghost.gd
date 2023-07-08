extends AnimatedSprite2D

const START_POSITION : Vector2i = Vector2i(10, 11)

@onready var tile_map : TileMap = $"../TileMap"
@onready var pacman : Pacman = $"../Pacman"

const INVERT_DIRECTION = {
	GameInput.Direction.UP : GameInput.Direction.DOWN,
	GameInput.Direction.DOWN : GameInput.Direction.UP,
	GameInput.Direction.LEFT : GameInput.Direction.RIGHT,
	GameInput.Direction.RIGHT : GameInput.Direction.LEFT,
}

var pos : Vector2i
var direction : GameInput.Direction


func _ready() -> void:
	pos = Constant.BLINK_START_POSITION;
	position = tile_map.map_to_local(pos)
	#_select_direction(pacman.pos)


#func _select_direction(_pos : Vector2i) -> GameInput.Direction
	#tile_map.
