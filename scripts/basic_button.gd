extends Button

@export var texture: Texture2D
@export var sound: AudioStream

@onready var texture_rect = $TextureRect
@onready var sound_click = $SoundClick



# Called when the node enters the scene tree for the first time.
func _ready():
	texture_rect.texture = texture
	sound_click.stream = sound



func _on_pressed():
	sound_click.play()
