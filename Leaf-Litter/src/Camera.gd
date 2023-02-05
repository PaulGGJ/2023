extends KinematicBody2D


onready var player = $Player
onready var player_coll = $PlayerCollider
onready var cam = $Camera2D
onready var gui = $GUI
var music_player
var SPEED = 36000.0

func _ready():
	music_player = get_tree().get_root().find_node("MusicPlayer", true, false)
	map_y = cam.position.y # We set these at the start and reference them later for panning
	tree_y = map_y - 365
	map_scale = cam.zoom
	tree_scale = map_scale * 3.1
	#pan_to_tree()

enum MODE { NORMAL, PAN_UP, PAN_DOWN, CUTSCENE, DONESCENE }
var scene_mode = MODE.NORMAL
var pan_start_y        # We may be in progress of a pan from here...
var pan_end_y          # ... to here.
var pan_start_scale
var pan_end_scale
var map_y # We set these at the start and reference them later for panning
var tree_y
var map_scale
var tree_scale
func pan_to_tree():
	if scene_mode == MODE.NORMAL:
		gui.hide()
		position.x = 3260
		pan(tree_y, tree_scale)
		scene_mode = MODE.PAN_UP
func pan_to_map():
	if scene_mode == MODE.DONESCENE:
		pan(map_y, map_scale)
		scene_mode = MODE.PAN_DOWN
		gui.show()

func pan(to_y, to_scale):
	togglePanColliders(false)
	pan_start_y = cam.position.y
	pan_end_y = to_y
	pan_start_scale = cam.scale.x # I'm assuming they're the same
	pan_end_scale = to_scale
func pan_complete():
	togglePanColliders(true)
	player_coll.position = player.position
func togglePanCollider(obj_noun, e):
	pass
#	var obj_name = "PanTo%s/CollisionShape2D" % obj_noun
#	print("toggle ", obj_name)
#	get_node("/root/Game/TileMap/Triggers/" + obj_name).disabled = e
#	get_node("/root/Game/TileMap/Triggers/PanTo%s" % obj_noun).set_collision_layer_bit(3, e)
func togglePanColliders(e):
	pass
	#togglePanCollider("Map", e)
	#togglePanCollider("Tree", e)

func _physics_process(delta):
	
	# Depending on our mode, we may be panning up or down
	if scene_mode == MODE.PAN_UP || scene_mode == MODE.PAN_DOWN:
		var cam_speed = SPEED * delta / 200.0
		if scene_mode == MODE.PAN_UP:
			var change_y = cam.position.y > pan_end_y
			var change_scale = cam.zoom < pan_end_scale
			if change_y:
				cam.position.y -= cam_speed
				player.position.y -= cam_speed / 1.8
			if change_scale:
				cam.zoom *= 1.0 + (0.5 * delta)
			if !change_y and !change_scale:
				pan_complete()
				scene_mode = MODE.CUTSCENE
				#FIXME: Do some cutscene stuff
				scene_mode = MODE.DONESCENE
		elif scene_mode == MODE.PAN_DOWN:
			var change_y = cam.position.y < pan_end_y
			var change_scale = cam.zoom > pan_end_scale
			if change_y:
				cam.position.y += cam_speed
				player.position.y += cam_speed / 1.8
			if change_scale:
				cam.zoom /= 1.0 + (0.5 * delta)
			if !change_y and !change_scale:
				pan_complete()
				scene_mode = MODE.NORMAL
	
	# Or in regular movement mode
	if scene_mode == MODE.NORMAL or scene_mode == MODE.DONESCENE:
		# Player can move around, which may also trigger sounds and animations
		var left = (1 if Input.is_action_pressed("ui_left") else 0)
		var right = (1 if Input.is_action_pressed("ui_right") else 0)
		var up = (1 if Input.is_action_pressed("ui_up") else 0)
		var down = (1 if Input.is_action_pressed("ui_down") else 0)
		# Perform the movement
		if left != right or up != down:
			var _junk = move_and_slide(Vector2(right - left, down - up) * SPEED * delta)
		
		# Check for collisions
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			var collider = collision.collider
			var layer = collider.get_collision_layer()
			print("Colliding: %d" % layer)
			print("name: ", collider.name)
			if layer == 2:
				$GUI/Columns/InventoryList.add_item(int(collider.name))
				$GUI/Columns/QuestList.remove_quest(int(collider.name))
				collider.queue_free()
			if layer == 4: # This is in bits, so 3 in interface = 3rd bit, 001 -> 100 so 4
				if collider.name == "PanToTree":
					pan_to_tree()
				elif collider.name == "PanToMap":
					pan_to_map()

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
	
