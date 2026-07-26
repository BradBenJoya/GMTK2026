extends Node2D

@export var happy : Sprite2D
@export var sad : Sprite2D
@export var results_text : Label

func _ready():
	get_tree().paused = true
	happy.visible = false
	sad.visible = false
	
	var text_to_give = []
	text_to_give.append("- Emails Answered: " + str(Global.emails_complete))
	text_to_give.append("\n- Emails Recieved: " + str(Global.total_emails))
	text_to_give.append("\n- Viruses Recieved: " + str(Global.total_viruses))
	text_to_give.append("\n- Boss Reminders: " + str(Global.total_boss_yells))
	text_to_give.append("\n\n")
	
	if Global.total_emails != 0: # avoid null
		if Global.emails_complete / Global.total_emails > 0.7: # win if got >70% of all emails complete
			happy.visible = true
			text_to_give.append("Good Ending")
		else:
			sad.visible = true
			text_to_give.append("Bad Ending")
	else:
		sad.visible = true
		text_to_give.append("Bad Ending")
	
	results_text.text = ""
	for string in text_to_give:
		results_text.text += string
	
	var dark_screen_tween_out = create_tween().tween_property(Global.main.dark_screen, "modulate:a", 0.0, 1.0)
	await dark_screen_tween_out.finished

func _on_button_pressed():
	var dark_screen_tween_in = create_tween().tween_property(Global.main.dark_screen, "modulate:a", 1.0, 1.0)
	var music_tween_out = create_tween().tween_property(Global.audio_manager.level_loop, "volume_linear", 0.0, 1.0)
	await dark_screen_tween_in.finished
	for instance in Global.manager.get_children(): # assuming only emails and popups are instanced under manager
		instance.queue_free()
	get_tree().reload_current_scene()
