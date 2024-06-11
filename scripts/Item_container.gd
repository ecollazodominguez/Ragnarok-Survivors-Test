extends ColorRect

var upgrade = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if upgrade != null:
		$BackgroundTexture/ItemTexture.texture = load(UpgradeDb.UPGRADES[upgrade]["icon"])
