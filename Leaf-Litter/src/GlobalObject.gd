extends Node

#export var tile_map_location = "/TileMap"
export var tile_map_location = "/root/Game2/TileMap"
#onready var tile_map_location = $TileMap
#export var world_location = "/World"
export var world_location = "/root/Game2/World"
#export var quest_list_location = "/TileMap/PlayerAndGUI/GUI/Columns/QuestList"
export var quest_list_location = "/root/Game2/TileMap/PlayerAndGUI/GUI/Columns/QuestList"

export onready var tile_map
export onready var quest_list

func _ready():
	tile_map = get_node(tile_map_location)
#	tile_map = $TileMap
	quest_list = get_node(quest_list_location)
#	quest_list = $TileMap/PlayerAndGUI/GUI/Columns/QuestList
#	quest_list.initialize()
	get_node(quest_list_location).initialize()
#	$World.initialize()
	get_node(world_location).initialize()
