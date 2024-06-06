extends Area2D

var level
var penetration
var speed
var damage
var knockback_amount
var paths
var attack_size
var attack_speed

var target = Vector2.ZERO
var target_array = []

var angle = Vector2.ZERO
var default_pos = Vector2.ZERO
var default_post_distance_diff_player = Vector2.ZERO

var spr_jav_default = preload("res://assets/sprites/Javelin/Javelin_0002.png")
var spr_jav_atk = preload("res://assets/sprites/Javelin2/Javelin2_0002.png")

@onready var player = get_tree().get_first_node_in_group("player")
@onready var collision_shape_2d = $CollisionShape2D
@onready var sprite_2d = $Sprite2D
@onready var attack_timer = $AttackTimer
@onready var change_direction_timer = $ChangeDirectionTimer
@onready var reset_pos_timer = $ResetPosTimer
@onready var sound_effect = $SoundEffect

signal remove_from_array(object)

func _ready():
	update_javelin()
	set_default_post()
	
func update_javelin():
	level = player.javelin_level
	match level:
		1:
			penetration = 9999
			speed = 500.0
			damage = 10
			knockback_amount = 100
			paths = 1
			attack_size = 1.0 * (1 + player.spell_size)
			attack_speed = 5.0 * (1 - player.spell_cooldown)
		2:
			penetration = 9999
			speed = 500.0
			damage = 10
			knockback_amount = 100
			paths = 2
			attack_size = 1.0 * (1 + player.spell_size)
			attack_speed = 5.0 * (1 - player.spell_cooldown)
		3:
			penetration = 9999
			speed = 500.0
			damage = 10
			knockback_amount = 100
			paths = 3
			attack_size = 1.0 * (1 + player.spell_size)
			attack_speed = 5.0 * (1 - player.spell_cooldown)
		4:
			penetration = 9999
			speed = 500.0
			damage = 15
			knockback_amount = 120
			paths = 3
			attack_size = 1.0 * (1 + player.spell_size)
			attack_speed = 5.0 * (1 - player.spell_cooldown)
		
		
	scale = Vector2(1.0,1.0)*attack_size
	attack_timer.wait_time= attack_speed

func _physics_process(delta):
	if target_array.size() > 0:
		position += angle*speed*delta
	else:
		var player_angle = global_position.direction_to(default_post_distance_diff_player + player.global_position)
		var distance_diff_player = global_position - player.global_position
		var return_speed = 20
		if abs(distance_diff_player.x) > 150 || abs(distance_diff_player.y) > 150:
			return_speed = 400
		position += player_angle*return_speed*delta
		rotation = global_position.direction_to(player.global_position).angle() + deg_to_rad(315)
		
		
		


func add_paths():
	sound_effect.play()
	emit_signal("remove_from_array",self)
	target_array.clear()
	var counter = 0
	while counter < paths:
		var new_path = player.get_random_target()
		target_array.append(new_path)
		counter +=1
	enable_attack(true)
	target = target_array[0]
	process_path()
	
func process_path():
	angle = global_position.direction_to(target)
	change_direction_timer.start()
	var tween = create_tween()
	var new_rotation_degrees = angle.angle() + deg_to_rad(135)
	tween.tween_property(self,"rotation",new_rotation_degrees,0.25).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	
func enable_attack(atk = true):
	if atk:
		collision_shape_2d.set_deferred("disabled", false)
		sprite_2d.texture = spr_jav_atk
	else:
		collision_shape_2d.set_deferred("disabled", true)
		sprite_2d.texture = spr_jav_default

func _on_attack_timer_timeout():
	add_paths()


func _on_change_direction_timer_timeout():
	if target_array.size() > 0:
		target_array.remove_at(0)
		if target_array.size() > 0:
			target = target_array[0]
			process_path()
			sound_effect.play()
			emit_signal("remove_from_array",self)
		else:
			enable_attack(false)
	else:
		change_direction_timer.stop()
		attack_timer.start()
		enable_attack(false)


func set_default_post():
	var choose_direction = randi() % 8
	default_pos = player.global_position
	match choose_direction:
		0:
			default_pos.x += 50
			default_pos.y += randi_range(0,50)
		1: 
			default_pos.x -= 50
			default_pos.y -= randi_range(0,50)
		2:
			default_pos.y += 50
			default_pos.x += randi_range(0,50)
		3: 
			default_pos.y -= 50
			default_pos.x -= randi_range(0,50)
		4: 
			default_pos.x += 50
			default_pos.y -= randi_range(0,50)
		5: 
			default_pos.x -= 50
			default_pos.y += randi_range(0,50)
		6:
			default_pos.y += 50
			default_pos.x -= randi_range(0,50)
		7: 
			default_pos.y -= 50
			default_pos.x += randi_range(0,50)
	default_post_distance_diff_player = default_pos - player.global_position



