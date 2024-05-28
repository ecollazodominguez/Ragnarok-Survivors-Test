extends Node2D

@export var spawns: Array[Spawn_info] = []

@onready var player = get_tree().get_first_node_in_group("player")

var time = 0

func _on_timer_timeout():
	time +=1
	var enemy_spawners = spawns
	for enemy_spawn in enemy_spawners:
		if time >= enemy_spawn.time_start and time <= enemy_spawn.time_end:
			if enemy_spawn.spawn_delay_counter < enemy_spawn.enemy_spawn_delay:
				enemy_spawn.spawn_delay_counter +=1
			else:
				enemy_spawn.spawn_delay_counter = 0
				var new_enemy_resource = enemy_spawn.enemy
				var counter = 0
				while counter < enemy_spawn.enemy_num:
					var new_enemy = new_enemy_resource.instantiate()
					new_enemy.global_position = get_random_position()
					add_child(new_enemy)
					counter +=1
					
func get_random_position():
	var viewport_rect = get_viewport_rect().size * randf_range(1.6,1.7)
	var top_left = Vector2(player.global_position.x - viewport_rect.x/2,player.global_position.y - viewport_rect.y/2)
	var top_right = Vector2(player.global_position.x + viewport_rect.x/2,player.global_position.y - viewport_rect.y/2) 
	var bottom_left = Vector2(player.global_position.x - viewport_rect.x/2,player.global_position.y + viewport_rect.y/2) 
	var bottom_right = Vector2(player.global_position.x + viewport_rect.x/2,player.global_position.y + viewport_rect.y/2)  
	var pos_side = ["up","down","right","left"].pick_random()
	var corner_pos1 = Vector2.ZERO
	var corner_pos2 = Vector2.ZERO
	
	match pos_side:
		"up":
			corner_pos1 = top_left
			corner_pos2 = top_right
		"down":
			corner_pos1 = bottom_left
			corner_pos2 = bottom_right
		"right":
			corner_pos1 = top_right
			corner_pos2 = bottom_right
		"left":
			corner_pos1 = top_left
			corner_pos2 = bottom_left
	
	var spawn_x = randf_range(corner_pos1.x, corner_pos2.x)
	var spawn_y = randf_range(corner_pos1.y, corner_pos2.y)
	return Vector2(spawn_x,spawn_y)
