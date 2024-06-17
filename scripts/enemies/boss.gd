extends Enemy

@onready var mvp_sound = $mvp_sound
@onready var game_manager = get_tree().get_first_node_in_group("GameManager")



func _on_tree_exiting():
	game_manager.setBossDead()


func _on_animated_sprite_2d_animation_changed():
	if animated_sprite_2d.animation == "death":
		player.mvp_animation.play()
		player.hurtbox.queue_free()
		mvp_sound.play()
