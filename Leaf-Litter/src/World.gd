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
export var room_min = int(3)
export var room_max = int(5)
var startPosition = Vector2()

onready var tileMap = $TileMap
#onready var playAgain = $CanvasLayer/PlayAgain



func _ready():
#	Player.connect("SignalDied", self, "show_label()")
#	Retry.connect("retry", self, "restart")
	randomize()
	generate_level()

func generate_level():
#	var walker = Walker.new(walker_start_pos, borders, room_min, room_max)
	var walker = Walker.new(walker_left_start_pos, borders, room_min, room_max)
#	var walker = Walker.new(Vector2(19, 11), borders)
	#walk(roomsize)
#	var map = walker.walk(200)
	var map = walker.walk(75, Vector2.LEFT)
	walker = Walker.new(walker_down_start_pos, borders, room_min, room_max)
	map += walker.walk(75, Vector2.DOWN)
	walker = Walker.new(walker_right_start_pos, borders, room_min, room_max)
	map += walker.walk(75, Vector2.RIGHT)
	print(tileMap.get_cell(0,0))
	print(tileMap.get_cell(1,1))
	walker.queue_free()
	for location in map:
#		print(tileMap.get_cell(location.x, location.y))
		tileMap.set_cellv(location, 2)
#		print(tileMap.get_cell(location.x, location.y))
#		tileMap.set_cellv(location, 1)
	tileMap.update_bitmask_region(borders.position - Vector2(1, 1), borders.end + Vector2(1,1))
	
	startPosition = map.front()*64
	
#	var startZone = StartZone.instance()
#	add_child(startZone)
#	startZone.position = map.front()*64
	
#	var player = Player.instance()
#	add_child(player)
#	player.position = map.front()*64
#	player.collidable = false
	
	

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
