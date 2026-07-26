#bydesign start
extends Control
class_name Virus

func _ready():
	var text_transition = create_tween().tween_property($Text, "visible_ratio", 1.0, 3.0).from(0.0)
	global_position = Vector2(randf() * (1423 - 600), randf() * (1433 - 500)) # takle the screen size of viewport - size of popup and pick random location there
	Global.audio_manager.play_virus_opened()

func _on_button_pressed():
	Global.audio_manager.play_email_sfx("sent")
	queue_free()

func _on_timer_timeout():
	Global.audio_manager.play_email_sfx("sent")
	queue_free() # just in case, remove
#bydesign end
