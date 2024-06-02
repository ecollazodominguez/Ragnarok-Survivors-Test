extends Node


#GUI LAYER
@onready var exp_bar = $GUILayer/GUI/ExpBar
@onready var label_level = $GUILayer/GUI/ExpBar/LabelLevel

func set_expbar(set_value = 1, set_max_value = 100):
	exp_bar.value = set_value
	exp_bar.max_value = set_max_value
	
func change_label_level(experience_level):
	label_level.text = str("Level: ", experience_level)
