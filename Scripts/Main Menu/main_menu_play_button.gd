# start Psuedo Pakman
extends Button
class_name PlayButton

signal play_pressed ## Detects if the "Play" button has been pressed

func button_down():
	play_pressed.emit()

func _ready() -> void:
	connect("button_down", button_down)
