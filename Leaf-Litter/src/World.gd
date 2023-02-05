extends Node2D

#const Player = preload("res://src/Actors/Player.tscn")
#const Exit = preload("res://src/Objects/ExitDoor.tscn")
#const Enemy_1 = preload("res://src/Actors/Enemy_1.tscn")
#const StartZone = preload("res://src/Objects/StartZone.tscn")
#const Retry = preload("res://src/UserInterface/RetryButton.tscn")

# borders defines the bounds of the generated area: 
#	first 2 numbers is top left corner position and second 2 numbers is bottom right position
export var borders = Rect2(1, 1, 49, 15) 
#export var walker_start_pos = Vector2(16, 2)
export var walker_left_start_pos = Vector2(18, 1)
export var walker_down_start_pos = Vector2(25, 1)
export var walker_right_start_pos = Vector2(32, 1)
export var room_min_size = int(3)
export var room_max_size = int(5)
export var hall_min_length = int(6)
export var hall_max_length = 100
export var turn_chance = 1
var startPosition = Vector2()

onready var tileMap = $TileMap
#onready var playAgain = $CanvasLayer/PlayAgain



#func initialize():
func _ready():
	var someQuest = $TileMap/PlayerAndGUI/GUI/Columns/QuestList.get_quest_by_pos(0)
	someQuest.set_tile(22,0)
#	Player.connect("SignalDied", self, "show_label()")
#	Retry.connect("retry", self, "restart")
	randomize()
	generate_level()

func generate_level():
#	var walker = Walker.new(walker_start_pos, borders, room_min_size, room_max_size)
	var walker = Walker.new(walker_left_start_pos, borders, room_min_size, room_max_size, hall_min_length, hall_max_length, turn_chance)
#	var walker = Walker.new(Vector2(19, 11), borders)
	#walk(roomsize)
#	var map = walker.walk(200)
#	var map = walker.walk(75, Vector2.LEFT)
	var maps = []
#	var maps = [[]]
	var rooms = [[]]
	maps += (walker.walk(75, Vector2.LEFT))
	rooms[0] = walker.get_rooms()
	walker.queue_free()
	walker = Walker.new(walker_down_start_pos, borders, room_min_size, room_max_size, hall_min_length, hall_max_length, turn_chance)
	maps += (walker.walk(75, Vector2.DOWN))
	rooms.append(walker.get_rooms())
	walker.queue_free()
	walker = Walker.new(walker_right_start_pos, borders, room_min_size, room_max_size, hall_min_length, hall_max_length, turn_chance)
	maps += (walker.walk(75, Vector2.RIGHT))
	rooms.append(walker.get_rooms())
	walker.queue_free()
	var i = 0
#	for map in maps:
#		for location in map:
#			tileMap.set_cellv(location, 2)
	for location in maps:
		tileMap.set_cellv(location, 2)

	tileMap.update_bitmask_region(borders.position - Vector2(1, 1), borders.end + Vector2(1,1))
	
		#place items in walker's path:
	var items = [QuestItem]
	items = $TileMap/PlayerAndGUI/GUI/Columns/QuestList
	var items2 = [[]]
#	var west_items = []
#	var south_items = []
#	var east_items = []

#	for item in items:
#		var dir = item.HUNT_DIR
#		var index = randi() % rooms[dir].size   
#		var location = Vector2(randi() % rooms[dir][index].size.x, 
#		randi() % rooms[dir][index].size.y)
#		item.position = location
#		rooms[dir].remove(index)
#	i = 0
#	while i < items.size:
#		items[items[i].HUNT_DIR].append(items[i])
#		if items[i].HUNT_DIR == 0:
#			west_items
#		i += 1
#	while items.size() > 0:
#		var index = randi() % rooms[0].size   
#		var location = Vector2(randi() % rooms[0][index].size.x, 
#		randi() % rooms[0][index].size.y)
#		items[0].position = location
#		items.pop_front()

	#old code for reference:
#	var startZone = StartZone.instance()
#	add_child(startZone)
#	startZone.position = map.front()*64
	
#	var player = Player.instance()
#	add_child(player)
#	player.position = map.front()*64
#	player.collidable = false
	#end of old cold

func reload_level():
	get_tree().reload_current_scene()

func _input(event):
	if event.is_action_pressed("restart_level"):
		restart()
	if event.is_action_pressed("reset_level"):
		reload_level()

func show_label():
#	playAgain.visible = true
	pass

func restart():
#	var player = Player.instance()
#	add_child(player)
#	player.position = startPosition
#	player.collidable = false
	pass
