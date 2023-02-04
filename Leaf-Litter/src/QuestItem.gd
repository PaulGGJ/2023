extends StaticBody2D
class_name QuestItem

enum HUNT_DIR { SOUTH, WEST, EAST }
const direction_name = { HUNT_DIR.SOUTH: "South", HUNT_DIR.WEST: "West", HUNT_DIR.EAST: "East" }

var id : int
var tile_x : int
var tile_y : int
var obj # The prefab / scene

var name_nature
var name_industry
var descr_nature
var direction : int
var image_file

# Scene objects
var sprite : Sprite
var Collider : CollisionObject2D

func _init(item_id):
	id = item_id
	load_from_file(item_id)

func add_object(o):
	obj = o
	# Set position, create a sprite, etc accordingly
	set_tile(tile_x, tile_y)
	set_tile(2, 4)
	#print("Loading: res://Assets/litter/%s.png" % image_file)
	#get_node("Sprite").texture = load("res://Assets/litter/%s.png" % image_file)
	#get_node("Sprite").texture = Util.getImage("Assets/litter/%s.png" % image_file)

func set_direction(dir : int):
	direction = dir
func set_tile(x, y):
	obj.position = Vector2(x * 32, y * 32)

# File stuff
const FILE_PATH = "assets/quest_items.txt"

#Example format
#Tall Staff (straw) - Perhaps for fighting, or guiding their people through the land.
#Warrior’s Boat (shoe) - Washed up on the shore. Surely they must have crossed the pond in this craft.

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
	image_file = name_nature.replace(" ", "_").replace("'", "")
	print("name %s aka %s (%s)" % [name_nature, name_industry, image_file])


static func get_count():
	# Open file
	var file = File.new()
	if not file.open(FILE_PATH, file.READ) == OK:
		return
	var lineCount = 0
	while !file.eof_reached():
		lineCount = lineCount + 1
		file.get_line()
	
	print("lineCount", lineCount)
	return lineCount
