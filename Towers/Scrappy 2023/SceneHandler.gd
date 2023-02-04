extends Node

func _ready():
	var _theTrash = get_node("MainMenu/M/VB/NewGame").connect("pressed", self, "on_new_game_pressed")
	_theTrash = get_node("MainMenu/M/VB/Quit").connect("pressed", self, "on_quit_pressed")


func on_new_game_pressed():
	get_node("MainMenu").queue_free()
	var game_scene = load("res://Scenes/Main Scenes/GameScene.tscn").instance()
	add_child(game_scene)

func on_quit_pressed():
	get_tree().quit()
