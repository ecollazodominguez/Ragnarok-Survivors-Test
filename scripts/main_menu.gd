extends Control

var world1 = "res://scenes/game.tscn"
@onready var sound_click = $TextureRect/PanelContainer/VBoxContainer/StartButton/SoundClick







func _on_start_button_button_up():
		get_tree().change_scene_to_file(world1)
	
func _on_exit_button_button_up():
	get_tree().quit()
