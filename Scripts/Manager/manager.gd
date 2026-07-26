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

# start Psuedo Pakman
@export var email_scene : PackedScene
# end Psuedo Pakman

var emails : Array = []

func create_emails():
	for i in 100:
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

func _process(delta):
	if Global.main: # failsafe
		Global.main.total_emails = emails.size()
	
	var i : int = 0
	for email in emails:
		if email.deleted:
			emails.erase(email)
		elif not email.open:
			email.position += (Vector2(60, 930 - (i * 90)) - email.position) / 5 * (60 * delta) # smooth interpolation of emails (current += (target - current) / smoothness)
		
		i += 1


func add_more_emails(amount : int):
	for i in amount:
		var new_email = email_scene.instantiate()
		new_email.position = Vector2(60, -1000)#Vector2(60, 350 - (i * 60))
		
		var random_chance = randf()
		if random_chance <= spam_chance:
			new_email.type = "Spam"
		elif random_chance <= spam_chance + virus_chance:
			new_email.type = "Virus"
		elif random_chance <= spam_chance + virus_chance + upload_chance:
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
