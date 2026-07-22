# start ByDesign
extends Node2D

var email_scene : PackedScene = preload("res://Scenes/email.tscn")

var emails : Array = []

func _ready():
	for i in 20:
		var new_email = email_scene.instantiate()
		
		new_email.type = "Normal"
		
		add_child(new_email)
		emails.append(new_email)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var i : int = 0
	for email in emails:
		if email.deleted:
			emails.erase(email)
		else:
			email.position += (Vector2(0, 350 - (i * 60)) - email.position) / 5 * (60 * delta) # smooth interpolation of emails
		
		i += 1
# end ByDesign
