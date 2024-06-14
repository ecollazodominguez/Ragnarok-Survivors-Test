extends Control

var world1 = "res://scenes/game.tscn"
@onready var sound_click = $TextureRect/PanelContainer/VBoxContainer/StartButton/SoundClick
@onready var character_select = $Background/CharacterSelect
@onready var menu_buttons = $Background/MenuButtons
@onready var audio_settings = $Background/AudioSettings
@onready var character = $Background/CharacterSelect/CharacterBackground/Character



func _on_start_button_pressed():
	menu_buttons.visible = false
	character_select.visible = true
	
func _on_exit_button_pressed():
	get_tree().quit()


func _on_character_pressed():
	character.disabled = true
	var tween = self.create_tween()
	tween.tween_property(self,"modulate",Color(0,0,0,200),1.5).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.play()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file(world1)


func _on_options_button_pressed():
	menu_buttons.visible = false
	audio_settings.visible = true
	print(audio_settings.visible)


func _on_return_button_pressed():
	menu_buttons.visible = true
	character_select.visible = false
