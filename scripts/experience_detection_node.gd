extends Node2D

@onready var game_manager = get_tree().get_first_node_in_group("GameManager")

var exp_required = 0
var exp_cap = 0
var experience = 0
var experience_level = 1
var collected_experience = 0

func _ready():
	game_manager.set_expbar(experience, calculate_experience_cap())

func calculate_experience(gem_exp = 0):
	exp_required = calculate_experience_cap()
	collected_experience += gem_exp
	if experience + collected_experience >= exp_required: #level up
		collected_experience = (experience + collected_experience) - exp_required
		experience = 0
		experience_level +=1
		game_manager.change_label_level(experience_level)
		exp_required = calculate_experience_cap()
		calculate_experience()
	else:
		experience += collected_experience
		collected_experience = 0
	game_manager.set_expbar(experience, exp_required)

func calculate_experience_cap():
	exp_cap = experience_level
	if experience_level < 20:
		exp_cap = experience_level*5
	elif experience_level < 40:
		exp_cap = 95 + (experience_level-19)*8
	else:
		exp_cap = 255 + (experience_level-39)*12
	return exp_cap
