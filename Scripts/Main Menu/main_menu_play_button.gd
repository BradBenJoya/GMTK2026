# start Psuedo Pakman
extends Button
class_name PlayButton

signal play_pressed ## Detects if the "Play" button has been pressed


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	play_pressed.emit()
# end Psuedo Pakman
