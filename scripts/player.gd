extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animated_sprite_2d_2 = $AnimatedSprite2D2

const SPEED = 200.0
var hp = 50

#Attacks
var iceSpear = preload("res://scenes/ice_spear.tscn")

#AttackNodes
@onready var ice_spear_timer = $Attack/IceSpearTimer
@onready var ice_spear_attack_timer = $Attack/IceSpearTimer/IceSpearAttackTimer

#IceSpear
var icespear_ammo = 0
var icespear_baseammo = 1
var icespear_attackspeed = 1.0
var icespear_level = 1

#Enemy Quantity Around
var enemy_close = []

@onready var walk_timer = $WalkTimer


func _ready():
	attack()

func _physics_process(delta):
	movement()
	
func attack():
	if icespear_level > 0:
		ice_spear_timer.wait_time = icespear_attackspeed
		if ice_spear_timer.is_stopped():
			ice_spear_timer.start()
	
	
func movement():
	var x_mov= Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov= Input.get_action_strength("down") - Input.get_action_strength("up")
	spriteDirection()
	var mov = Vector2(x_mov,y_mov)
	velocity = mov.normalized()*SPEED
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
	hp -= damage


#Loading ammo
func _on_ice_spear_timer_timeout():
	icespear_ammo += icespear_baseammo
	ice_spear_attack_timer.start()

#Shooting
func _on_ice_spear_attack_timer_timeout():
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
