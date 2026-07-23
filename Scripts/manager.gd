# start ByDesign
extends Node2D

@export var email_scene : PackedScene

var emails : Array = []

func _ready():
	for i in 50:
		var new_email = email_scene.instantiate()
		new_email.position = Vector2(0, 350 - (i * 60))
		new_email.type = "Normal"
		
		add_child(new_email)
		emails.append(new_email)

func _process(delta):
	var i : int = 0
	for email in emails:
		if email.deleted:
			emails.erase(email)
		elif not email.open:
			email.position += (Vector2(0, 350 - (i * 60)) - email.position) / 5 * (60 * delta) # smooth interpolation of emails (current += (target - current) / smoothness)
		
		i += 1
# end ByDesign
