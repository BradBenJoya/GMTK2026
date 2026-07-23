# start ByDesign
extends Node2D

@export_group("Email Speed")
@export var minimum_speed : float = 0.1
@export var maximum_speed : float = 2.0

var email_scene : PackedScene = preload("res://Scenes/email.tscn")

var emails : Array = []

func _ready():
	create_emails()

func create_emails():
	for i in 50:
		var new_email = email_scene.instantiate()
		new_email.position = Vector2(60, -1000)#Vector2(60, 350 - (i * 60))
		new_email.type = "Normal"
		
		add_child(new_email)
		emails.append(new_email)
		
		await get_tree().create_timer(randf_range(minimum_speed, maximum_speed)).timeout

func _process(delta):
	var i : int = 0
	for email in emails:
		if email.deleted:
			emails.erase(email)
		elif not email.open:
			email.position += (Vector2(60, 350 - (i * 60)) - email.position) / 5 * (60 * delta) # smooth interpolation of emails (current += (target - current) / smoothness)
		
		i += 1
# end ByDesign
