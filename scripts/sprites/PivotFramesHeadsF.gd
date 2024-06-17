extends AnimatedSprite2D

func _ready():
	set_ofs()
	
	
func set_ofs():
	
	var offsets = [Vector2(0, randi_range(-1,1))]

	set_offset(offsets[get_frame()])
	

func _on_animated_sprite_2d_frame_changed():
	set_ofs()
