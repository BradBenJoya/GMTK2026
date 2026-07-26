# start ByDesign
extends Node2D

@export_group("Email Speed")
@export var minimum_speed : float = 0.1
@export var maximum_speed : float = 2.0
# start ampbeetle
@export var email_interval: float = 5.0
@export var upload_speed : float = 1.0

@export_group("Email Chances")
@export var upload_chance : float = 0.20
@export var spam_chance : float = 0.15
@export var virus_chance : float = 0.10

var email_timer: Timer = Timer.new()
# end ampbeetle
@export var scroll_speed := 40.0

@export_group("Popup Speed")
@export var popup_minimum_speed : float = 0.1
@export var popup_maximum_speed : float = 1.0

@export_group("Scenes")
# start Psuedo Pakman
@export var email_scene : PackedScene
# end Psuedo Pakman
@export var popup_scene : PackedScene

var emails : Array = []

var current_scroll := 0.0
var min_scroll := 0.0
var max_scroll := 0.0

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
		var random_chance = randf()
		
		#new_email.type = "Upload"
		if random_chance <= spam_chance:
			new_email.type = "Spam"
		#elif random_chance <= spam_chance + virus_chance:
			#new_email.type = "Virus"
		elif random_chance <= spam_chance + upload_chance:  # readd + virus_chance later if wanted
			new_email.type = "Upload"
		else:
			new_email.type = "Normal"
		
		add_child(new_email)
		emails.append(new_email)
		
		await get_tree().create_timer(randf_range(minimum_speed, maximum_speed)).timeout
		print(new_email.type)

func _ready() -> void:
	add_child(email_timer)
	email_timer.wait_time = email_interval
	email_timer.start()
	email_timer.timeout.connect(_on_email_timer_timeout)

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
	Global.boss_summoned.emit()
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
	Global.boss_left.emit()

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				current_scroll += scroll_speed * Global._scroll_speed
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				current_scroll -= scroll_speed * Global._scroll_speed
	
	current_scroll = clamp(current_scroll, min_scroll, max_scroll)


func _process(delta):
	max_scroll = (emails.size() - 12) * 90
	if max_scroll < 0:
		max_scroll = 0
	
	var has_virus = false
	for child in get_children():
		if child is Virus:
			has_virus = true
	
	if has_virus:
		if Global.virus == false:
			Global.audio_manager.transition_to_virus()
			Global.virus = true
	else:
		if Global.virus == true:
			Global.audio_manager.transition_to_level()
			Global.virus = false
	
	if Global.main: # failsafe
		Global.main.total_emails = emails.size()
	
	var i : int = 0
	for email in emails:
		if email:
			if email.deleted:
				emails.erase(email)
			elif not email.open:
				email.position += (Vector2(60, 930 - (i * 90) + current_scroll) - email.position) / 5 * (60 * delta) # smooth interpolation of emails (current += (target - current) / smoothness)
		else:
			emails.erase(email)
		if not email.open:
			email.position += (Vector2(60, 930 - (i * 90) + current_scroll) - email.position) / 5 * (60 * delta) # smooth interpolation of emails (current += (target - current) / smoothness)
		else:
			emails.erase(email) 
		
		i += 1


func add_more_emails(amount : int):
	for i in amount:
		var new_email = email_scene.instantiate()
		new_email.position = Vector2(60, -1000)#Vector2(60, 350 - (i * 60))
		
		var random_chance = randf()
		if random_chance <= spam_chance:
			new_email.type = "Spam"
		#elif random_chance <= spam_chance + virus_chance:
			#new_email.type = "Virus"
		elif random_chance <= spam_chance + upload_chance: # + virus_chance
			new_email.type = "Upload"
		else:
			new_email.type = "Normal"
		
		add_child(new_email)
		emails.append(new_email)
		
		await get_tree().create_timer(0.2).timeout

# end ByDesign

# start ampbeetle
func _on_email_timer_timeout() -> void:
	add_more_emails(1)
# end ampbeetle
