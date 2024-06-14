extends CharacterBody2D

class_name Enemy

@export var speed = 100.0
@export var hp = 10
@export var knockback_recovery = 3.5
@export var experience = 1
@export var enemy_damage = 1

var knockback = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var loot_container = get_tree().get_first_node_in_group("loot")
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var death_timer = $DeathTimer
@onready var hurtbox = $Hurtbox
@onready var hit_sound = $hit_sound
@onready var collision_shape_2d = $CollisionShape2D
@onready var hitbox = $Hitbox

var exp_gem_scene = preload("res://scenes/experience_gem.tscn")

signal remove_from_array(object)

func _ready():
	hitbox.damage = enemy_damage


func  _physics_process(_delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	spriteDirection()
	velocity = direction * speed
	velocity += knockback
	move_and_slide()
	
	
func spriteDirection():
	if global_position.x > player.global_position.x:
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("sides")
	elif global_position.x < player.global_position.x:
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("sides")

func death():
		emit_signal("remove_from_array",self)
		set_physics_process(false)
		collision_shape_2d.set_deferred("disabled", true)
		hurtbox.queue_free()
		animated_sprite_2d.play("death")
		
		if randi_range(0,1) == 1:
			var new_gem = exp_gem_scene.instantiate()
			new_gem.global_position = global_position
			new_gem.experience = experience
			loot_container.call_deferred("add_child", new_gem)
		death_timer.start()



func _on_hurtbox_hurt(damage, angle, knockback_amount):
	hp -= damage
	knockback = angle * knockback_amount
	if hp <= 0:
		hit_sound.play()
		death()
	else:
		hit_sound.play()
	



func _on_death_timer_timeout():
	queue_free()
