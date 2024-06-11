extends Area2D

@export var experience = 1

var spr_blue = preload("res://assets/sprites/Gemstones/Blue_gemstone.png")
var spr_red = preload("res://assets/sprites/Gemstones/Red_gemstone.png")
var spr_yellow = preload("res://assets/sprites/Gemstones/Yellow_gemstone.png")

var target = null
var speed = -3.0

@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var sound_effect = $SoundEffect


func _ready():
	if experience < 10:
		return
	elif experience < 30:
		sprite_2d.texture = spr_red
	else:
		sprite_2d.texture = spr_yellow

func _physics_process(delta):
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 17*delta

func collect():
	sound_effect.play()
	collision_shape_2d.set_deferred("disabled", true)
	sprite_2d.visible = false
	return experience



func _on_sound_effect_finished():
	queue_free()
