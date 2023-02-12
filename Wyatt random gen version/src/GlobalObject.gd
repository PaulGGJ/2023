extends Node
class_name GlobalObject

export var tile_map_location = "/root/Game/TileMap"
export var world_location = "/root/Game/World"
export var quest_list_location = "/root/Game/TileMap/PlayerAndGUI/GUI/Columns/QuestList"

export onready var tile_map
export onready var quest_list

func _ready():
	tile_map = get_node(tile_map_location)
	quest_list = get_node(quest_list_location)
	get_node(quest_list_location).initialize(self)
	get_node(world_location).initialize(self)
