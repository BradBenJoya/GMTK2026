# start ByDesign
extends Node2D
class_name Email

@export_group("Scripts")

@export_group("Data")
@export_enum("Normal", "Accept", "Decline", "Spam") var type : String

var deleted : bool = false

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
	if abs(get_global_mouse_position().y - global_position.y) <= 25 and abs(get_global_mouse_position().x - global_position.x) < 600: # really long way to ask if the mouse is hovering over the email :P
		scale += (Vector2.ONE * 1.05 - scale) / 5 # little popup animation when hovering
	else:
		scale += (Vector2.ONE - scale) / 5

func delete_email(success : bool): # delete email after doing little animation
	deleted = true # let the manager know that it shouldnt account for this email anymore
	z_index = -1 # get it out of the way to avoid overlap
	
	var slide_out = create_tween().tween_property(self, "position", Vector2(-2000.0, position.y), 0.5)
	
	if success:
		# add in code animation
		# add score
		pass
	else:
		# add in code animation
		# add penalty
		pass
	
	await slide_out.finished
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
# end ByDesign
