extends ColorRect

var mouse_over = false
var item = null
@onready var game_manager = get_tree().get_first_node_in_group("GameManager")

signal selected_upgrade(upgrade)

func _ready():
	connect("selected_upgrade", Callable(game_manager,"upgrade_character"))

func _input(event):
	if event.is_action("click"):
		if mouse_over:
			emit_signal("selected_upgrade", item)

func _on_mouse_entered():
	mouse_over = true

func _on_mouse_exited():
	mouse_over = false
