extends Control

var cam_script
func _ready():
	cam_script = get_parent()
	



func _on_Next_pressed():
	cam_script._on_Next_pressed()
