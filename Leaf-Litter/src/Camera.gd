extends KinematicBody2D


onready var player = $Player
var SPEED = 18000.0

func _physics_process(delta):
	var left = (1 if Input.is_action_pressed("ui_left") else 0)
	var right = (1 if Input.is_action_pressed("ui_right") else 0)
	var up = (1 if Input.is_action_pressed("ui_up") else 0)
	var down = (1 if Input.is_action_pressed("ui_down") else 0)
	#print ("left %s right %s up %s down %s" % [left, right, up, down])
	if left != right or up != down:
		var _junk = move_and_slide(Vector2(right - left, down - up) * SPEED * delta)
	
	# Animate
	if right or left:
		player.frame = 0
	else:
		if up and !down:
			player.frame = 2
		else:
			player.frame = 1 # default
	player.scale.x = abs(player.scale.x) * (-1 if left and !right else 1)
