extends VBoxContainer
class_name QuestList

var quest_ids = []
var quests = []

func _ready():
	# Fill quest data
	randomize_quests()
	for q in quest_ids:
		print("quest id %d" % q)
		var item = QuestItem.new(q)
		quests.push_back(item)
	# Display
	reload()
	

func randomize_quests():
	var quest_count = QuestItem.get_count()
	#stub
	quest_ids.push_back(5)
	quest_ids.push_back(2)
	quest_ids.push_back(3)
	# replace with something like
	#quest_ids = Util.x_choose_y(1, quest_count)


var current_node
func reload():
	var template = get_node("QuestItem") # before it's removed
	Util.deleteExtraChildren(self, 1)
	for q in quests:
		current_node = template.duplicate()
		node("Name").text = q.name_nature
		add_child(current_node)

func node(s):
	return current_node.get_node(s)
