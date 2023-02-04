extends VBoxContainer
class_name InventoryList

var found_ids = []
var found_items = []

func _ready():
	add_item(3)
	reload()

func add_item(i : int):
	#if not found_ids.contains(i):
	#	found_ids.push(i)
	#	var item = QuestItem.new(i)
	#	found_items[i] = item
	reload()

var current_node
func reload():
	var template = get_node("InventoryItem") # before it's removed
	Util.deleteExtraChildren(self, 1)
	for f in found_ids:
		current_node = template.duplicate()
		node("Name").text = found_items[f].name_nature
		add_child(current_node)

func node(s):
	return get_node(s)