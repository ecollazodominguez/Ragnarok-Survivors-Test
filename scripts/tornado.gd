extends Area2D

var level
var penetration
var speed
var damage
var knockback_amount
var attack_size

var last_movement = Vector2.ZERO
var angle = Vector2.ZERO
var angle_less = Vector2.ZERO
var angle_more = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")

signal remove_from_array(object)

func _ready():
	match level:
		1:
			level = 1
			penetration = 999
			speed = 500
			damage = 10
			knockback_amount = 150
			attack_size = 1.0
	
	var move_to_less = Vector2.ZERO
	var move_to_more = Vector2.ZERO
	match last_movement:
		Vector2.UP, Vector2.DOWN:
			move_to_less = global_position + Vector2(randf_range(-1,-0.25), last_movement.y)*500
			move_to_more = global_position + Vector2(randf_range(0.25,1), last_movement.y)*500
		Vector2.LEFT, Vector2.RIGHT:
			move_to_less = global_position + Vector2(last_movement.x,randf_range(-1,-0.25))*500
			move_to_more = global_position + Vector2(last_movement.x,randf_range(0.25,1))*500
		Vector2(1,1), Vector2(-1,-1), Vector2(1,-1), Vector2(-1,1):
			move_to_less = global_position + Vector2(last_movement.x, last_movement.y * randf_range(0,075))*500
			move_to_more = global_position + Vector2(last_movement.x * randf_range(0,075), last_movement.y)*500
		Vector2.ZERO:
			move_to_less = global_position + Vector2(last_movement.x + randf_range(0,075), last_movement.y + randf_range(0,075))*500
			move_to_more = global_position + Vector2(last_movement.x + randf_range(-075,0), last_movement.y + randf_range(-075,0))*500
			
	angle_less = global_position.direction_to((move_to_less))
	angle_more = global_position.direction_to((move_to_more))
	
	#Tween that makes increase to normal size as it appears and  tornado goes faster overtime
	var initial_tween = create_tween().set_parallel(true)
	initial_tween.tween_property(self,"scale",Vector2(1,1) * attack_size,3).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	initial_tween.tween_property(self,"speed", speed*1.25,6).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	initial_tween.play()
	
	#Tween that makes tornado move like a "S"
	var tween = create_tween()
	var set_angle = randi_range(0,1)
	if set_angle == 1:
		angle = angle_less
		tween.tween_property(self,"angle", angle_more,2)
		tween.tween_property(self,"angle", angle_less,2)
		tween.set_loops()
	else:
		angle = angle_more
		tween.tween_property(self,"angle", angle_less,2)
		tween.tween_property(self,"angle", angle_more,2)
		tween.set_loops()
	tween.play()
	
func _physics_process(delta):
	position += angle*speed*delta
	
func enemy_hit(hit = 1):
	penetration -=hit
	if penetration <= 0:
		emit_signal("remove_from_array",self)
		queue_free()


func _on_timer_timeout():
	emit_signal("remove_from_array",self)
	queue_free()
