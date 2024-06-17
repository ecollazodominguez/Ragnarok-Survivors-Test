extends AnimatedSprite2D

func _ready():
	set_ofs()
	
	
func set_ofs():
	
	if get_animation() == "run sides":
		var offsets = []
		if flip_h:
			offsets = [Vector2(0, 0), Vector2(5, 0),Vector2(0, 0),Vector2(1, 0),Vector2(0, 0),Vector2(6, 0),Vector2(1, 0),Vector2(-1, 0)]
		else:
			offsets = [Vector2(0, 0), Vector2(-5, 0),Vector2(0, 0),Vector2(-1, 0),Vector2(0, 0),Vector2(-6, 0),Vector2(-1, 0),Vector2(1, 0)]
		set_offset(offsets[get_frame()])
	else:
		set_offset(Vector2(0,0))

	

func _on_frame_changed():
	set_ofs()
