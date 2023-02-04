extends Node
class_name QuestItem

var name_nature
var name_industry
var descr_nature

func _init(item_id):
	load_from_file(item_id)


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
	print("name %s aka %s: %s" % [name_nature, name_industry, descr_nature])


static func get_count():
	# Open file
	var file = File.new()
	if not file.open(FILE_PATH, file.READ) == OK:
		return
	file.seek(0)
	# Parse lines
	var line_count = 0
	var current_line : String
	#while !file.eof_reached():
	#	line_count += 1 # Human-readable, so first line is 1
	return line_count
