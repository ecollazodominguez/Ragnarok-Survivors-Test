extends PanelContainer

var mouse_over = false
var item = null
@onready var game_manager = get_tree().get_first_node_in_group("GameManager")

signal selected_upgrade(upgrade)

func _ready():
	connect("selected_upgrade", Callable(game_manager,"upgrade_character"))

func _on_button_pressed():
	emit_signal("selected_upgrade", item)
