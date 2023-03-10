extends KinematicBody2D


onready var player = $Player
onready var player_coll = $PlayerCollider
onready var cam = $Camera2D
onready var gui = $GUI
onready var mgr = $SceneManager
var music_player
var SPEED = 36000.0

var name_nature
var name_industry
var descr_nature
var direction : int

func _ready():
	music_player = get_tree().get_root().find_node("MusicPlayer", true, false)
	map_y = cam.position.y # We set these at the start and reference them later for panning
	tree_y = map_y - 365
	map_scale = cam.zoom
	tree_scale = map_scale * 3.1
	start_intro()
	
func start_intro():
	gui.hide()
	mgr.BeginScene("intro")

func get_remaining():
	var quests = $GUI/Columns/QuestList.quests
	var num_in_dir = {}
	for d in QuestItem.HUNT_DIR:
		num_in_dir[QuestItem.HUNT_DIR[d]] = 0
	for q in quests:
		num_in_dir[quests[q].direction] += 1
	return num_in_dir

var game_over = false
func game_win():
	if game_over: # We already did this
		 return false
	else:
		var quests = $GUI/Columns/QuestList.quests
		game_over = quests.size() == 0
		return game_over

func wordify(n : int):
	return Util.wordifyWith0(n, "no")

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
	if game_win():
		mgr.BeginScene("conclusion")
	elif scene_mode == MODE.NORMAL and !game_over:
		gui.hide()
		position.x = 3260
		pan(tree_y, tree_scale)
		scene_mode = MODE.PAN_UP
func pan_to_map():
	if scene_mode == MODE.DONESCENE:
		pan(map_y, map_scale)
		scene_mode = MODE.PAN_DOWN

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
			if !change_y and !change_scale and !game_over:
				pan_complete()
				scene_mode = MODE.CUTSCENE
				# Set direction variables
				var num_in_dir = get_remaining()
				mgr.SetVar("west", wordify(num_in_dir[QuestItem.HUNT_DIR.WEST]))
				mgr.SetVar("east", wordify(num_in_dir[QuestItem.HUNT_DIR.EAST]))
				mgr.SetVar("south", wordify(num_in_dir[QuestItem.HUNT_DIR.SOUTH]))
				# And, play dialogue
				mgr.BeginScene("hints")
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
				gui.show()
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
			#print("name: ", collider.name)
			if layer == 2:
				music_player.play_pickup()
				$GUI/Columns/InventoryList.add_item(int(collider.name))
				var collider_name = int(collider.name)
				popup_appear(collider_name)
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
	
func popup_appear(i):
	var root = get_parent().get_parent()
	var popup = root.get_node("ArtifactFound")
	#var popup = get_node("ArtifactFound")
	
	""""
	var desc
	print("i is ", i)
	var quest_items = get_parent().get_node("ScavengerItems").get_children()
	for item in quests:
		if item.name == String(i):
			desc = item.descr_nature
	"""
	var quests = $GUI/Columns/QuestList.quests
	if !quests.has(i):
		return
	var desc = quests[i].descr_nature
	print("description: ", desc)

	var label = popup.get_node("Description")
	label.text = desc
	
	var texture = Util.getTexture("Assets/litter/%s.png" % quests[i].image_file)
	var sprite = popup.get_node("Sprite")
	sprite.set_texture(texture)
	
	var sx = position.x * 2
	var sy = position.y * 2
	
	popup.rect_position.x = sx - 280
	popup.rect_position.y = sy -150
	
	popup.visible = true;
	$GUI/Columns/QuestList.remove_quest(i)
	
	#Copied out of quest item because yay

const FILE_PATH = "assets/quest_items.txt"
func load_from_file(line_requested : int):
	# Open file
	var file = File.new()
	if not file.open(FILE_PATH, file.READ) == OK:
		return
	file.seek(0)
	# Parse lines
	var line_count = 0     # For reporting errors
	var current_line : String
	while line_count <= line_requested and !file.eof_reached():
		current_line = file.get_line()
		line_count += 1 # Human-readable, so first line is 1
		var dash = current_line.find("-")
		if dash >= 0:
			var names = current_line.substr(0, dash).strip_edges()
			descr_nature = current_line.substr(dash + 1).strip_edges()
			var begin_bracket = names.find("(")
			if begin_bracket >= 0:
				name_nature = names.substr(0, begin_bracket).strip_edges()
				name_industry = names.substr(begin_bracket + 1).strip_edges()
				name_industry = name_industry.replace(")", "")
