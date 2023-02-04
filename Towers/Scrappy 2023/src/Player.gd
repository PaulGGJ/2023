extends Sprite

var map : TileMap

func _ready():
	map = get_parent()
	move_to_tile(Vector2(3, 4))

# Movement
var start_tile : Vector2
var goal_tile : Vector2
var shift_tile : Vector2
var SPEED = 0.4
func move_to_tile(posn : Vector2):
	# We'll need to know the start and end position
	start_tile = map.world_to_map(position)
	goal_tile = posn
	# as well as the progress variable (this moves from 0 to 1 in one or both dimensions)
	shift_tile = Vector2(0.0, 0.0)


#func _process(delta: float):
#	#var goal_world = map.map_to_world(goal_tile)
#	#var shift_x = position.x - goal_world.x
#	#var shift_y = position.y - goal_world.y
#	shift_tile += Vector2(delta * SPEED, delta * SPEED)
#	position.x = start_tile.x.lerp(goal_tile.x, shift_tile.x)
#
#	#position = start_tile.lerp(goal_tile, delta * SPEED)
#
#	#move_toward(position, goal_tile, delta)
