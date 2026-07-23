# start Psuedo Pakman
extends MeshInstance2D
class_name PlayButton

signal play_pressed ## Detects if the "Play" button has been pressed

@export var temp_play_button_mouse_detection: StaticBody2D
var has_mouse_entered: bool = false

func _ready() -> void:
	# Connect the StaticBody2D signals for mouse entered/exited
	temp_play_button_mouse_detection.mouse_entered.connect(_on_mouse_entered)
	temp_play_button_mouse_detection.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	has_mouse_entered = true

func _on_mouse_exited() -> void:
	has_mouse_entered = false

func _input(event: InputEvent) -> void:
	# Emit the signal if the mouse was clicked on the "Play" button
	if has_mouse_entered and event.is_action_pressed("Click"):
		play_pressed.emit()
# end Psuedo Pakman
