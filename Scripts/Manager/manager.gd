# start ByDesign
extends Node2D

@export_group("Email Speed")
@export var minimum_speed : float = 0.1
@export var maximum_speed : float = 2.0

@export_group("Popup Speed")
@export var popup_minimum_speed : float = 0.1
@export var popup_maximum_speed : float = 1.0

# start Psuedo Pakman
@export var email_scene : PackedScene
# end Psuedo Pakman
@export var popup_scene : PackedScene

var emails : Array = []

func weird_mouse():
	Global.set_mouse_invert(true)
	await get_tree().create_timer(10.0).timeout
	Global.set_mouse_invert(false)

func create_emails():
	for i in 100:
		if get_tree().paused:
			while get_tree().paused:
				if Global.game_end:
					break
				await get_tree().physics_frame
		if Global.game_end:
			break
		
		var new_email = email_scene.instantiate()
		new_email.position = Vector2(60, -1000)#Vector2(60, 350 - (i * 60))
		new_email.type = "Normal"
		
		add_child(new_email)
		emails.append(new_email)
		
		await get_tree().create_timer(randf_range(minimum_speed, maximum_speed)).timeout

func create_popups(amount):
	for i in amount:
		if get_tree().paused:
			while get_tree().paused:
				if Global.game_end:
					break
				await get_tree().physics_frame
		if Global.game_end:
			break
		
		var new_popup = popup_scene.instantiate()
		
		add_child(new_popup)
		
		await get_tree().create_timer(randf_range(popup_minimum_speed, popup_maximum_speed)).timeout

func summon_boss():
	Global.email_open = true
	var boss_tween = create_tween().tween_property(Global.boss, "position:x", 0, 1.0)
	Global.boss.get_node("StopWorkStuff").visible = true
	await boss_tween.finished
	for i in randi_range(4, 8):
		Global.audio_manager.play_boss_yell()
		await get_tree().create_timer(1.0).timeout
	Global.boss.get_node("StopWorkStuff").visible = false
	var boss_tween_2 = create_tween().tween_property(Global.boss, "position:x", -2980, 1.0)
	Global.email_open = false

func _process(delta):
	if Global.main: # failsafe
		Global.main.total_emails = emails.size()
	
	var i : int = 0
	for email in emails:
		if email:
			if email.deleted:
				emails.erase(email)
			elif not email.open:
				email.position += (Vector2(60, 930 - (i * 90)) - email.position) / 5 * (60 * delta) # smooth interpolation of emails (current += (target - current) / smoothness)
		else:
			emails.erase(email)
		elif not email.open:
			email.position += (Vector2(60, 930 - (i * 90)) - email.position) / 5 * (60 * delta) # smooth interpolation of emails (current += (target - current) / smoothness)
		else:
			emails.erase(email) 
		
		i += 1

func add_more_emails(amount : int):
	for i in amount:
		var new_email = email_scene.instantiate()
		new_email.position = Vector2(60, -1000)#Vector2(60, 350 - (i * 60))
		new_email.type = "Normal"
		
		add_child(new_email)
		emails.append(new_email)
		
		await get_tree().create_timer(0.2).timeout
# end ByDesign
