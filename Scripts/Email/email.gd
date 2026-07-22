extends Node2D
class_name Email

@export_group("Scripts")

@export_group("Data")
@export_enum("Normal", "Accept", "Decline", "Spam") var type : String

func _ready():
	var random : float = randf_range(1, 100)
	if random < 70:
		type = "Normal"
		modulate = Color.WHITE
	elif random < 80:
		type = "Accept"
		modulate = Color.LIGHT_GREEN
	elif random < 90:
		type = "Decline"
		modulate = Color.LIGHT_CORAL
	elif random <= 100:
		type = "Spam"
		modulate = Color.LIGHT_SALMON

func _process(delta):
	pass

func delete_email(success : bool): # delete email after doing little animation
	if success:
		# add in code animation
		# add score
		
		queue_free()
	else:
		# add in code animation
		# add penalty
		
		queue_free()



# special interaction stuff
func _on_read_pressed():
	delete_email(type == "Normal")

func _on_yes_pressed():
	delete_email(type == "Accept")

func _on_no_pressed():
	delete_email(type == "Decline")

func _on_delete_pressed():
	delete_email(type == "Spam")
