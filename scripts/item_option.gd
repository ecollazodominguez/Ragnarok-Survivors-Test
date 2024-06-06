extends PanelContainer

@onready var lbl_name = $Button/lbl_name
@onready var lbl_description = $Button/lbl_description
@onready var lbl_level = $Button/lbl_level
@onready var item_icon = $Button/Option/ItemIcon



var mouse_over = false
var item = null
@onready var game_manager = get_tree().get_first_node_in_group("GameManager")

signal selected_upgrade(upgrade)

func _ready():
	connect("selected_upgrade", Callable(game_manager,"upgrade_character"))
	if item == null:
		item = "food"
	lbl_name.text = UpgradeDb.UPGRADES[item]["display_name"]
	lbl_description.text = UpgradeDb.UPGRADES[item]["description"]
	lbl_level.text = UpgradeDb.UPGRADES[item]["level"]
	item_icon.texture = load(UpgradeDb.UPGRADES[item]["icon"])

func _on_button_pressed():
	emit_signal("selected_upgrade", item)
