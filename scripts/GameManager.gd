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

#TIMER
@onready var lbl_timer = $GUILayer/GUI/lbl_timer
var pass_time = 0

#COLLECTED ITEMS
@onready var collected_weapons = $GUILayer/GUI/CollectedItems/VBoxContainer/CollectedWeapons
@onready var collected_upgrades = $GUILayer/GUI/CollectedItems/VBoxContainer/CollectedUpgrades
@onready var item_container = preload("res://scenes/Item_container.tscn")


#Player
@onready var player = get_tree().get_first_node_in_group("player")
var level = 1

#UPGRADES
var collected_upgrades_list = []
var upgrade_options_list = []

#BOSS
var bossDead = false

#RESULTS
@onready var lbl_result = $GUILayer/GUI/EndingPanel/MarginContainer/GridContainer/lbl_result
@onready var ending_panel = $GUILayer/GUI/EndingPanel
@onready var victory_sound = $GUILayer/GUI/EndingPanel/VictorySound

#STAGE MUSIC
@onready var stage_music = $"../StageMusic"



#Fix relation between gamemanager and experience node
@onready var experience_manager = get_tree().get_first_node_in_group("experience")

func _physics_process(delta):
	pass_time +=delta
	change_time()

func adjust_gui_collection(upgrade):
	#var upgraded_displayname = UpgradeDb.UPGRADES[upgrade]["display_name"]
	var type = UpgradeDb.UPGRADES[upgrade]["type"]
	if UpgradeDb.UPGRADES[upgrade]["level"] == "Level: 1":
		var new_item_container = item_container.instantiate()
		new_item_container.upgrade = upgrade
		match type:
			"weapon":
				collected_weapons.add_child(new_item_container)
			"upgrade":
				collected_upgrades.add_child(new_item_container)

func change_time():
	if pass_time >= 0 && bossDead:
		end_stage()
	var time = int(pass_time)
	var minutes = int(time/60.0)
	var seconds = time % 60
	if minutes < 10:
		minutes = str(0,minutes)
	if seconds < 10:
		seconds = str(0,seconds)
	lbl_timer.text = str(minutes,":",seconds)
	
func setBossDead():
	bossDead = !bossDead
	
func end_stage():
	stage_music.stop()
	if bossDead:
		victory_sound.play()
	else:
		await get_tree().create_timer(1.5).timeout
	change_label_result()
	get_tree().paused = true
	ending_panel.visible = true
	var tween = ending_panel.create_tween()
	tween.tween_property(ending_panel,"position", Vector2(396,126),1.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	
	

func set_expbar(set_value = 1, set_max_value = 100):
	exp_bar.value = set_value
	exp_bar.max_value = set_max_value
	
func change_label_level():
	label_level.text = str("Level: ", player.level)
	
func change_label_result():
	if bossDead:
		lbl_result.text = "Victory !!"
	else:
		lbl_result.text = "Game Over"
	
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
		option_choice.item = get_random_item()
		upgrade_options.add_child(option_choice)
		options +=1
	

	
func upgrade_character(upgrade):
	apply_upgrade_levels(upgrade)
	adjust_gui_collection(upgrade)
	player.attack() #refresh weapons
	var options_children = upgrade_options.get_children()
	for item in options_children:
		item.queue_free()
	upgrade_options_list.clear()
	collected_upgrades_list.append(upgrade)
	level_up.visible = false
	level_up.set_deferred("scale", Vector2(0.1,0.1))
	get_tree().paused = false
	experience_manager.calculate_experience()
	
func apply_upgrade_levels(upgrade):
	match upgrade:
		"ice_spear1":
			player.icespear_level = 1
			player.icespear_baseammo = 1
		"ice_spear2":
			player.icespear_level = 2
			player.icespear_baseammo += 1
		"ice_spear3":
			player.icespear_level = 3
		"ice_spear4":
			player.icespear_level = 4
			player.icespear_baseammo += 2
		"tornado1":
			player.tornado_level = 1
			player.tornado_baseammo = 1
		"tornado2":
			player.tornado_level = 2
			player.tornado_baseammo += 1
		"tornado3":
			player.tornado_level = 3
			player.tornado_attackspeed -= 0.5
		"tornado4":
			player.tornado_level = 4
			player.tornado_baseammo += 1
		"javelin1":
			player.javelin_level = 1
			player.javelin_ammo = 1
		"javelin2":
			player.javelin_level = 2
		"javelin3":
			player.javelin_level = 3
		"javelin4":
			player.javelin_level = 4
		"armor1","armor2","armor3","armor4":
			player.armor += 1
		"speed1","speed2","speed3","speed4":
			player.movement_speed += 20
		"tome1","tome2","tome3","tome4":
			player.spell_size += 0.10
		"scroll1","scroll2","scroll3","scroll4":
			player.spell_cooldown += 0.05
		"ring1","ring2":
			player.additional_attacks += 1
		"food":
			player.hp += 20
			player.hp = clamp(player.hp,0,player.max_hp)

func get_random_item():
	var dblist = []
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades_list || i in upgrade_options_list: #Find already collected upgrades or if it is already in the options to choose
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "item": #If it is a type Item.Don't pick food
			pass
		elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0: #Check prerequisites
			var to_add = true
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:
				if not n in collected_upgrades_list: #If you dont have the prerequisite check to not add
					to_add = false
			if to_add:
				dblist.append(i)
		else:
			dblist.append(i)
	if dblist.size() > 0:
		var randomitem = dblist.pick_random()
		upgrade_options_list.append(randomitem)
		return randomitem
	else:
		return null


func _on_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
