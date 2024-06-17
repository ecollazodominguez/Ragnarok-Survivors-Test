extends Control

var master_bus = AudioServer.get_bus_index("Master")
var bgm_bus = AudioServer.get_bus_index("BGM")
var sfx_bus = AudioServer.get_bus_index("SFX")

@onready var menu_buttons = $"%Background/MenuButtons"
@onready var slider_master = $PanelContainer/TextureRect/MarginContainer/VBoxContainer/HBoxContainer/slider_master
@onready var slider_bgm = $PanelContainer/TextureRect/MarginContainer/VBoxContainer/HBoxContainer2/slider_bgm
@onready var slider_sfx = $PanelContainer/TextureRect/MarginContainer/VBoxContainer/HBoxContainer3/slider_sfx



func _ready():
	setAudioVolumeBuses()
	setSliderAudioValues()


func _on_slider_master_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus,linear_to_db(value))


func _on_slider_bgm_value_changed(value):
	AudioServer.set_bus_volume_db(bgm_bus,linear_to_db(value))


func _on_slider_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_bus,linear_to_db(value))


func _on_basic_button_pressed():
	self.visible = false
	menu_buttons.visible = true
	
func setAudioVolumeBuses():
	#Setting current sound values on buses
	AudioServer.set_bus_volume_db(master_bus,AudioServer.get_bus_volume_db(master_bus))
	AudioServer.set_bus_volume_db(bgm_bus,AudioServer.get_bus_volume_db(bgm_bus))
	AudioServer.set_bus_volume_db(sfx_bus,AudioServer.get_bus_volume_db(sfx_bus))
	
func setSliderAudioValues():
	slider_master.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus))
	slider_bgm.value = db_to_linear(AudioServer.get_bus_volume_db(bgm_bus))
	slider_sfx.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus))
	
