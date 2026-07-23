# start ByDesign
extends Node2D
class_name Email

@export_group("Nodes")
@export var flavor_text : Label
@export var upload_button : Button
@export var upload_bar : ProgressBar

@export_group("Scripts") # sorry, shoulda probably split this up (?)
@export var flavor_text_controller : Node

@export_group("Data")
@export_enum("Normal", "Accept", "Decline", "Spam", "Upload", "Attachment") var type : String

@export_group("Button Groups") # the node2ds are used to hide and show different groups
@export var read : Node2D
@export var decision : Node2D
@export var spam : Node2D
@export var upload : Node2D

var open := false # tells the manager that it shouldnt be accounted for

var deleted : bool = false

var progress := 0.0 # only for upload emails

func _ready():
	read.visible = false
	decision.visible = false
	spam.visible = false
	upload.visible = false
	
	var random : float = randf_range(1, 100)
	if random < 70:
		type = "Normal"
		modulate = Color.WHITE
		flavor_text.text = flavor_text_controller.read_text.pick_random()
		
		read.visible = true
		
	else:
		var special_random : int = randi_range(1, 4)
		
		if special_random == 1:
			type = "Accept"
			modulate = Color.LIGHT_GREEN
			flavor_text.text = flavor_text_controller.decision_good_text.pick_random()
			
			decision.visible = true
		
		elif special_random == 2:
			type = "Decline"
			modulate = Color.LIGHT_CORAL
			flavor_text.text = flavor_text_controller.decision_bad_text.pick_random()
			
			decision.visible = true
		
		elif special_random == 3:
			type = "Spam"
			modulate = Color.LIGHT_SALMON
			flavor_text.text = flavor_text_controller.spam_text.pick_random()
			
			spam.visible = true
		
		elif special_random == 4:
			type = "Upload"
			modulate = Color.LIGHT_SKY_BLUE
			flavor_text.text = flavor_text_controller.upload_text.pick_random()
			
			upload.visible = true
		

func _process(delta):
	if not open:
		if abs(get_global_mouse_position().y - global_position.y) <= 25 and abs(get_global_mouse_position().x - global_position.x) < 600: # really long way to ask if the mouse is hovering over the email :P
			scale += (Vector2.ONE * 1.05 - scale) / 5 # little popup animation when hovering
		else:
			scale += (Vector2.ONE - scale) / 5

func delete_email(success : bool): # delete email after doing little animation
	open = false
	
	var scale_box_tween = create_tween().tween_property(self.get_node("EmailBubble"), "size", Vector2(1200, 50), 0.2) # make box fit screen
	var scale_text_tween = create_tween().tween_property(flavor_text, "size", Vector2(550, 24), 0.2) # make text fit screen
	var change_text_tween = create_tween().tween_property(flavor_text, "custom_maximum_size", Vector2(550, 24), 0.2) # stop ellipses from appearing
	var move_buttons_tween = create_tween().tween_property(self.get_node("Buttons"), "position", Vector2(0, 0), 0.2) # move buttons to bottom
	
	await move_buttons_tween.finished
	
	if success:
		Global.main.score += 5 # remove score for mess ups
	else:
		Global.main.score -= 3 # remove score for mess ups
		
		var shake = create_tween().tween_method(func(i): position.x = sin(i) * 20.0, 0.0, -2 * PI, 0.3)
		await shake.finished
	
	deleted = true # let the manager know that it shouldnt account for this email anymore
	z_index = -1 # get it out of the way to avoid overlap
	var slide_out = create_tween().tween_property(self, "position", Vector2(-2000.0, position.y), 0.5)
	await slide_out.finished
	
	queue_free()

func open_email(type):
	open = true
	var scale_box_tween = create_tween().tween_property(self.get_node("EmailBubble"), "size", Vector2(1200, 600), 0.2) # make box fit screen
	var scale_text_tween = create_tween().tween_property(flavor_text, "size", Vector2(550, 400), 0.2) # make text fit screen
	var change_text_tween = create_tween().tween_property(flavor_text, "custom_maximum_size", Vector2(550, 400), 0.2) # stop ellipses from appearing
	var move_tween = create_tween().tween_property(self, "position", Vector2(0, -250), 0.2) # move box to right position
	var move_buttons_tween = create_tween().tween_property(self.get_node("Buttons"), "position", Vector2(0, 550), 0.2) # move buttons to bottom
	z_index = 5


# special interaction stuff
func _on_read_pressed():
	if open:
		delete_email(type == "Normal")
	else:
		open_email(type)

func _on_yes_pressed():
	if open:
		delete_email(type == "Accept")
	else:
		open_email(type)

func _on_no_pressed():
	if open:
		delete_email(type == "Decline")
	else:
		open_email(type)

func _on_delete_pressed():
	if open:
		delete_email(type == "Spam")
	else:
		open_email(type)

func _on_upload_pressed(): # i think i did this one wrong (?)
	if open:
		while upload_button.button_pressed:
			await get_tree().physics_frame
			if [true, false].pick_random():
				progress += 1
			upload_bar.value = progress
		
		if progress >= 100:
			delete_email(type == "Upload")
		else:
			if not upload_button.button_pressed:
				progress = 0
				upload_bar.value = progress
	
	else:
		open_email(type)
# end ByDesign
