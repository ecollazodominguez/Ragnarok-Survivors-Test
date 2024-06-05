extends Node



#GUI LAYER
#EXPBAR
@onready var exp_bar = $GUILayer/GUI/ExpBar
@onready var label_level = $GUILayer/GUI/ExpBar/LabelLevel

#LVLUP
@onready var level_up = $GUILayer/GUI/LevelUp
@onready var lbl_level_up = $GUILayer/GUI/LevelUp/MarginContainer/GridContainer/lbl_levelUp
@onready var upgrade_options = $GUILayer/GUI/LevelUp/MarginContainer/GridContainer/UpgradeOptions
@onready var sound_effect = $GUILayer/GUI/LevelUp/SoundEffect
@onready var itemOptions = preload("res://scenes/item_option.tscn")

#Player
@onready var player = get_tree().get_first_node_in_group("player")
var level = 1


func set_expbar(set_value = 1, set_max_value = 100):
	exp_bar.value = set_value
	exp_bar.max_value = set_max_value
	
func change_label_level():
	label_level.text = str("Level: ", player.level)
	
func levelup():
	get_tree().paused = true
	level +=1
	player.level = level
	sound_effect.play()
	change_label_level()
	var tween = level_up.create_tween()
	tween.tween_property(level_up, "scale", Vector2(1,1),0.4).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	level_up.visible = true
	var options = 0
	var optionsMax = 3
	while options < optionsMax:
		var option_choice = itemOptions.instantiate()
		upgrade_options.add_child(option_choice)
		options +=1

	
func upgrade_character(upgrade):
	var options_children = upgrade_options.get_children()
	for item in options_children:
		item.queue_free()
	level_up.visible = false
	level_up.set_deferred("scale", Vector2(0.1,0.1))
	get_tree().paused = false
