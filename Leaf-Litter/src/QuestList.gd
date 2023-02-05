extends VBoxContainer
class_name QuestList

var ScavengerItems

const HUNT_SIZE = 8
var quest_ids = []
var quests = {}

func _ready():
	ScavengerItems = get_tree().get_root().find_node("ScavengerItems", true, false)
	var quest_scene = load("res://Scenes/QuestItem.tscn")
	# Fill quest data
	randomize_quests()
	var count = 0 # Track this so we put them in different directions
	for q in quest_ids:
		#print("quest id %d" % q)
		var obj = quest_scene.instance()
		var item = QuestItem.new(q)
		item.add_object(obj)
		item.set_direction(count % 3)
		quests[q] = item
		ScavengerItems.add_child(obj)
		count += 1
	# Display
	reload()
	

func randomize_quests():
	var quest_count = QuestItem.get_count()
	var tempQ = Util.XchooseY(quest_count-1, HUNT_SIZE)
	for q in tempQ:
		quest_ids.push_back(q)

func remove_quest(target):
	var i = 0
	var removed = false
	var size = quest_ids.size()
	while i < size and !removed:
		if target == quest_ids[i]:
			removed = true
			quest_ids.remove(i)
			quests.erase(target)
		i = i + 1

var current_node
func reload():
	var template = get_node("QuestItem") # before it's removed
	Util.deleteExtraChildren(self, 1)
	# We are now displaying only the # of items in each direction, not all items with names
	var count = [0, 0, 0]
	for q in quests:
		count[quests[q].direction] += 1
	for dir in count.size():
		#print ("Checking in %s" % dir)
		current_node = template.duplicate()
		var text = "%s: %d" % [QuestItem.direction_name[dir], count[dir]]
		#print ("text %s " % text)
		node("Name").text = text
		add_child(current_node)
		
#	for q in quests:
#		current_node = template.duplicate()
#		node("Name").text = q.name_nature
#		add_child(current_node)

func get_quest_by_pos(i):
	return quests[quest_ids[i]]

func node(s):
	return current_node.get_node(s)
