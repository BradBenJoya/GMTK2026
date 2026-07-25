#start ampbeetle
extends PanelContainer

func _ready() -> void:
	%MasterSlider.value = Global._master * 100
	%MasterValue.text = str(%MusicSlider.value)
	%MusicSlider.value = Global._music * 100
	%MusicValue.text = str(%MusicSlider.value)
	%SFXSlider.value = Global._sfx * 100
	%SFXValue.text = str(%SFXSlider.value)

func _process(delta: float) -> void:
	pass


func _on_master_slider_drag_ended(value_changed: bool) -> void:
	Global._master = %MasterSlider.value / 100
	%MasterValue.text = str(Global._master * 100)
	AudioServer.set_bus_volume_db(Global.master_bus, linear_to_db(Global._master))


func _on_music_slider_drag_ended(value_changed: bool) -> void:
	Global._music = %MusicSlider.value / 100
	%MusicValue.text = str(Global._music * 100)
	AudioServer.set_bus_volume_db(Global.music_bus, linear_to_db(Global._music))


func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	Global._sfx = %SFXSlider.value / 100
	%SFXValue.text = str(Global._sfx * 100)
	AudioServer.set_bus_volume_db(Global.sfx_bus, linear_to_db(Global._sfx))


func _on_mouse_x_slider_drag_ended(value_changed: bool) -> void:
	Global._mouse_sensitivity.x = %MouseXSlider.value
	%MouseXValue.text = str(%MouseXSlider.value)
	print(Global._mouse_sensitivity)
	
func _on_mouse_y_slider_drag_ended(value_changed: bool) -> void:
	Global._mouse_sensitivity.y = %MouseYSlider.value
	%MouseYValue.text = str(%MouseYSlider.value)
	print(Global._mouse_sensitivity)

func _on_option_button_item_selected(index: int) -> void:
	Global._window_mode = index
	print(Global._window_mode)

func _on_exit_button_pressed() -> void:
	hide()

#end ampbeetle
