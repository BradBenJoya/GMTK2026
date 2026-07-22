extends Node2D
class_name Email

@export_group("Scripts")

@export_group("Data")
@export_enum("Normal") var type : String

func _ready():
	pass

func _process(delta):
	pass

func delete_email(): # delete email after doing little animation
	# add in code animation
	queue_free()



# special interaction stuff
func _on_read_pressed():
	delete_email()

func _on_yes_pressed():
	delete_email()

func _on_no_pressed():
	delete_email()

func _on_delete_pressed():
	delete_email()
