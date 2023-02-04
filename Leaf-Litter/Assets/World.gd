extends Node2D

#const Player = preload("res://src/Actors/Player.tscn")
#const Exit = preload("res://src/Objects/ExitDoor.tscn")
#const Enemy_1 = preload("res://src/Actors/Enemy_1.tscn")
#const StartZone = preload("res://src/Objects/StartZone.tscn")
#const Retry = preload("res://src/UserInterface/RetryButton.tscn")

# borders defines the bounds of the generated area: 
#	first 2 numbers is top left corner position and second 2 numbers is bottom right position
export var borders = Rect2(1, 1, 38, 21) 
export var walker_start_pos = Vector2(19, 11)
var startPosition = Vector2()

onready var tileMap = $TileMap
#onready var playAgain = $CanvasLayer/PlayAgain



func _ready():
#	Player.connect("SignalDied", self, "show_label()")
#	Retry.connect("retry", self, "restart")
	randomize()
	generate_level()

func generate_level():
	var walker = Walker.new(walker_start_pos, borders)
#	var walker = Walker.new(Vector2(19, 11), borders)
	#walk(roomsize)
	var map = walker.walk(200)
	
	walker.queue_free()
	for location in map:
		tileMap.set_cellv(location, -1)
	tileMap.update_bitmask_region(borders.position, borders.end)
	
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
