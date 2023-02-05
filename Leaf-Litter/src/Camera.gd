extends KinematicBody2D


onready var player = $Player
var music_player
var SPEED = 18000.0

func _ready():
	music_player = get_tree().get_root().find_node("MusicPlayer", true, false)

func _physics_process(delta):
	var left = (1 if Input.is_action_pressed("ui_left") else 0)
	var right = (1 if Input.is_action_pressed("ui_right") else 0)
	var up = (1 if Input.is_action_pressed("ui_up") else 0)
	var down = (1 if Input.is_action_pressed("ui_down") else 0)
	#print ("left %s right %s up %s down %s" % [left, right, up, down])
	if left != right or up != down:
		var _junk = move_and_slide(Vector2(right - left, down - up) * SPEED * delta)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var collider = collision.collider
		var layer = collider.get_collision_layer()
		if layer == 2:
			print("name: ", collider.name)
			$GUI/Columns/InventoryList.add_item(int(collider.name))
			$GUI/Columns/QuestList.remove_quest(int(collider.name))
			collider.queue_free()

	# Animate
	if right or left:
		player.frame = 0
	else:
		if up and !down:
			player.frame = 2
		else:
			player.frame = 1 # default
	player.scale.x = abs(player.scale.x) * (-1 if left and !right else 1)

	# Sound
	if left or right or up or down:
		music_player.play_walking()
	else:
		music_player.stop_walking()
	
