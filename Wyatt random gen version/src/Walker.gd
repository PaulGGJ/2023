extends Node
class_name Walker

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var step_history = []
var steps_since_turn = 0
var rooms = []
var room_size_min = int(3)
var room_size_max = int(5)
var hall_min = 6
var hall_max = 100
var turn_chance = 1

func _init(starting_position, new_borders, room_s_min, room_s_max, hallway_minimum, hallway_max, turning_chance):
	assert(new_borders.has_point(starting_position))
	position = starting_position
	step_history.append(position)
	borders = new_borders
	room_size_min = room_s_min
	room_size_max = room_s_max
	hall_min = hallway_minimum
	hall_max = hallway_max
	turn_chance = turning_chance

func walk(steps, dir):
#	place_room(position)
	direction = dir
	for step in steps:
		if steps_since_turn >= hall_max or (steps_since_turn >= hall_min and randf() < turn_chance):
#		if hall_max or (steps_since_turn >= hall_min and randf() < turn_chance):
			change_direction()
		
		if step():
			step_history.append(position)
		else:
			change_direction()
	return step_history

func step():
	var target_position = position + direction
	if borders.has_point(target_position):
		steps_since_turn += 1
		position = target_position
		return true
	else:
		return false

func change_direction():
	place_room(position)
	steps_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()

func create_room(position, size):
	return {position = position, size = size}

func place_room(position):
	var size = Vector2(randi() % (room_size_max - room_size_min - 1) + room_size_min - 1, randi() % (room_size_max - room_size_min - 1) + room_size_min - 1)
	var top_left_corner = (position - size/2).ceil()
	rooms.append(create_room(position, size))
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x, y)
			if borders.has_point(new_step):
				step_history.append(new_step)

func get_end_room():
	var end_room = rooms.pop_front()
	var starting_position = step_history.front()
	for room in rooms:
		if starting_position.distance_to(room.position) > starting_position.distance_to(end_room.position):
			end_room = room
	return end_room

func get_rooms():
	return rooms
