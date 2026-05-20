extends Control

func _input(event):
	if event is InputEventKey and event.pressed:
		SceneChanger.change_scene("main")
