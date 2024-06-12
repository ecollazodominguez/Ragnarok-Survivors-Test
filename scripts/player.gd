extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animated_sprite_2d_2 = $AnimatedSprite2D2
@onready var experience_detection_node = $ExperienceDetectionNode
@onready var health_bar = $HealthBar
@onready var game_manager = %GameManager
@onready var mvp_animation = $MvpAnimation


var movement_speed = 200.0
var hp = 80
var max_hp = 80
var last_movement = Vector2.UP
var level = 1
var armor = 0
var speed = 0
var spell_cooldown = 0
var spell_size = 0
var additional_attacks = 0
var dead = false

#Attacks
var iceSpear = preload("res://scenes/ice_spear.tscn")
var tornado = preload("res://scenes/tornado.tscn")
var javelin = preload("res://scenes/javelin.tscn")

#AttackNodes
@onready var ice_spear_timer = $Attack/IceSpearTimer
@onready var ice_spear_attack_timer = $Attack/IceSpearTimer/IceSpearAttackTimer
@onready var tornado_timer = $Attack/TornadoTimer
@onready var tornado_attack_timer = $Attack/TornadoTimer/TornadoAttackTimer
@onready var javelin_container = $Attack/JavelinContainer

#IceSpear
var icespear_ammo = 0
var icespear_baseammo = 1
var icespear_attackspeed = 2
var icespear_level = 0

#Tornado
var tornado_ammo = 0
var tornado_baseammo = 0
var tornado_attackspeed = 3
var tornado_level = 0

#Javelin
var javelin_ammo = 0
var javelin_level = 0

#Enemy Quantity Around
var enemy_close = []

@onready var walk_timer = $WalkTimer


func _ready():
	game_manager.upgrade_character("ice_spear1") #placeholder
	attack()
	health_bar.max_value = max_hp
	health_bar.value = hp

func _physics_process(delta):
	movement()
	
func attack():
	#TODO: make icespears have a proper cooldown instead of rapidfire (wait spearTimer to Attack Timer to end and then reload?)
	if icespear_level > 0:
		ice_spear_timer.wait_time = icespear_attackspeed * (1 - spell_cooldown)
		if ice_spear_timer.is_stopped():
			ice_spear_timer.start()
	if tornado_level > 0:
		tornado_timer.wait_time = tornado_attackspeed * (1 - spell_cooldown)
		if tornado_timer.is_stopped():
			tornado_timer.start()
	if javelin_level > 0:
		spawn_javelin()
	
	
func movement():
	if !dead:
		var x_mov= Input.get_action_strength("right") - Input.get_action_strength("left")
		var y_mov= Input.get_action_strength("down") - Input.get_action_strength("up")
		spriteDirection()
		var mov = Vector2(x_mov,y_mov)
		last_movement = mov
		velocity = mov.normalized() * movement_speed
		move_and_slide()
	
func spriteDirection():
	var x_mov= Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov= Input.get_action_strength("down") - Input.get_action_strength("up")

	var mov = Vector2(x_mov,y_mov)
	
	if x_mov != 0 && y_mov != 0:
		animated_sprite_2d.flip_h = false
		animated_sprite_2d_2.flip_h = false
		#top left
		if x_mov < 0 && y_mov < 0:
			animated_sprite_2d.play("run top left_right")
			animated_sprite_2d_2.play("run top left_right")
		#bottom left
		elif x_mov < 0 && y_mov > 0:
			animated_sprite_2d.play("run bottom left_right")
			animated_sprite_2d_2.play("run bottom left_right")
		#top right
		elif x_mov > 0 && y_mov < 0:
			animated_sprite_2d.flip_h = true
			animated_sprite_2d_2.flip_h = true
			animated_sprite_2d.play("run top left_right")
			animated_sprite_2d_2.play("run top left_right")
		#bottom right
		elif x_mov > 0 && y_mov > 0:
			animated_sprite_2d.flip_h = true
			animated_sprite_2d_2.flip_h = true
			animated_sprite_2d.play("run bottom left_right")
			animated_sprite_2d_2.play("run bottom left_right")
	#left
	elif x_mov < 0 :
		animated_sprite_2d.flip_h = false
		animated_sprite_2d_2.flip_h = false
		animated_sprite_2d.play("run sides")
		animated_sprite_2d_2.play("run sides")
	#right
	elif x_mov > 0:
		animated_sprite_2d.flip_h = true
		animated_sprite_2d_2.flip_h = true
		animated_sprite_2d.play("run sides")
		animated_sprite_2d_2.play("run sides")
	#top
	elif y_mov < 0 :
		animated_sprite_2d.play("run top")
		animated_sprite_2d_2.play("run top")
	#bottom
	elif y_mov > 0 :
		animated_sprite_2d.play("run bottom")
		animated_sprite_2d_2.play("run bottom")
		
	if mov == Vector2.ZERO:
		animated_sprite_2d.flip_h = false
		animated_sprite_2d_2.flip_h = false
		animated_sprite_2d.play("idle")
		animated_sprite_2d_2.play("idle")


func _on_hurtbox_hurt(damage, _angle, _knockback_amount):
	hp -= clamp(damage - armor, 1.0, 999.0)
	if hp <= 0:
		dead = true
		animated_sprite_2d.animation = "death"
		animated_sprite_2d_2.animation = "death"
		hp = 0
		game_manager.end_stage()
	health_bar.value = hp


#Loading ammo
func _on_ice_spear_timer_timeout():
	#print("lol")
	icespear_ammo = icespear_baseammo + additional_attacks
	ice_spear_attack_timer.start()

#Shooting
func _on_ice_spear_attack_timer_timeout():
	#print(icespear_ammo)
	if icespear_ammo > 0:
		var icespear_attack = iceSpear.instantiate()
		icespear_attack.position = position
		icespear_attack.target = get_closest_target()
		icespear_attack.level = icespear_level
		add_child(icespear_attack)
		icespear_ammo -= 1
		if icespear_ammo > 0:
			ice_spear_attack_timer.start()
		else:
			ice_spear_attack_timer.stop()
			
func _on_tornado_timer_timeout():
	tornado_ammo = tornado_baseammo + additional_attacks
	tornado_attack_timer.start()


func _on_tornado_attack_timer_timeout():
	if tornado_ammo > 0:
		var tornado_attack = tornado.instantiate()
		tornado_attack.position = position
		tornado_attack.last_movement = last_movement
		tornado_attack.level = tornado_level
		add_child(tornado_attack)
		tornado_ammo -= 1
		if tornado_ammo > 0:
			tornado_attack_timer.start()
		else:
			tornado_attack_timer.stop()
	
func spawn_javelin():
	var get_javelin_total = javelin_container.get_child_count()
	var calc_spawns = (javelin_ammo + additional_attacks) - get_javelin_total
	while calc_spawns > 0:
		var javelin_spawn = javelin.instantiate()
		javelin_spawn.global_position = global_position
		javelin_container.add_child(javelin_spawn)
		calc_spawns -= 1
	#Upgrade Javelin
	var get_javelins = javelin_container.get_children()
	for javelin in get_javelins:
		if javelin.has_method("update_javelin"):
			javelin.update_javelin()
	
func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP
		
func get_closest_target():
	if enemy_close.size() > 0:
		# assume the first spawn node is closest
		var nearest_target= enemy_close[0]

		# look through spawn nodes to see if any are closer
		for enemy in enemy_close:
			if enemy.global_position.distance_to(global_position) < nearest_target.global_position.distance_to(global_position):
					nearest_target = enemy
		return nearest_target.global_position
	else:
		return Vector2.UP

func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)


func _on_grab_area_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self


func _on_collect_area_area_entered(area):
	if area.is_in_group("loot"):
		var gem_exp = area.collect()
		experience_detection_node.calculate_experience(gem_exp)
		
