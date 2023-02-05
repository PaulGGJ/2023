extends Node

export var tilemap_location = "TileMap"
export var world_location = "World"
export var quest_list_location = "TileMap"

func _ready():
	get_node("/root/Game/TileMap").Initialize()
	
