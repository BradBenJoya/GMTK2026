# start ByDesign
extends Control
class_name Email

@export_group("Nodes")
@export var flavor_text : Label

# start Psudeo Pakman
@export var expanded_email_text: Label
# end Psuedo Pakman

@export var upload_button : Button
@export var upload_bar : ProgressBar
@export var base_read_button : Button
@export var email_list : Node

@export_group("Data")
@export_enum("Normal", "Accept", "Decline", "Spam", "Upload", "Attachment") var type : String

@export_group("Button Groups") # the node2ds are used to hide and show different groups
@export var decision_stuff : Control
@export var email_stuff : Control
@export var upload_stuff : Control
@export var all : Control

var open := false # tells the manager that it shouldnt be accounted for

var deleted : bool = false

var progress := 0.0

var base_scale := Vector2.ONE # for easy scale animation tweaks
# start JT
var clickable_buttons: Array[Button] = [] 
var hovered_button: Button = null
#end JT

func _ready():
	Global.total_emails += 1
	# start JT
	Global.fake_mouse_clicked.connect(_on_fake_mouse_clicked)
	for node in find_children("*", "Button", true, false):
		clickable_buttons.append(node)
		node.mouse_filter = Control.MOUSE_FILTER_IGNORE # We want all of the buttons to react only to the fake cursor 
	#end JT
	Global.audio_manager.play_email_sfx("recieved")
	
	base_scale = scale
	all.visible = false
	expanded_email_text.visible = false
	
	var random : float = randf_range(1, 100)
	if random < 70:
		type = "Normal"
		
	else:
		var special_random : int = randi_range(1, 4)
		
		if special_random == 1:
			type = "Accept"
		
		elif special_random == 2:
			type = "Decline"
		
		elif special_random == 3:
			type = "Spam"
		
		elif special_random == 4:
			type = "Upload"
		
	var text = email_list.create_email(type) # creates the email, and sets text to an array. first value is the person and topic, second is the expanded text
	flavor_text.text = text[0]
	expanded_email_text.text = text[1]
	


func _process(delta):
	fake_cursor_hover_behavior()
	if Global.email_open and not open || get_tree().paused: # fixes the bug where you couldn't finish the email
		base_read_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		base_read_button.mouse_filter = Control.MOUSE_FILTER_STOP

#start JT
func _on_fake_mouse_clicked() -> void:
	if hovered_button != null and not hovered_button.disabled:
		hovered_button.emit_signal("pressed")
			
func _set_hover(button: Button, is_hovered: bool) -> void:
	#print("setting hover")
	if button == null:
		return
	if is_hovered:
		button.add_theme_stylebox_override("normal", button.get_theme_stylebox("hover"))
		if not open:
			scale += (base_scale * 1.05 - scale) / 5 # little popup animation when hovering
	else:
		button.remove_theme_stylebox_override("normal")
		if not open:
			scale += (base_scale - scale) / 5
			
func fake_cursor_hover_behavior() -> void:
	var fake_pos = Global.cursor_pos_in_subviewport(Global.monitor_container)
	var new_hovered: Button = null
	# iterate in reverse so topmost (last drawn/highest z) wins on overlap
	var button_arr = clickable_buttons.duplicate()
	button_arr.reverse()
	for button in button_arr:
		if button != null:
			if not button.is_visible_in_tree() or not button.is_inside_tree() or (Global.email_open and button == base_read_button):
				continue
			elif button.get_global_rect().abs().has_point(fake_pos):
				new_hovered = button
				break

	if new_hovered != hovered_button:
		_set_hover(hovered_button, false)
		_set_hover(new_hovered, true)
		hovered_button = new_hovered
#end JT

func delete_email(input : String): # delete email after doing little animation
	Global.emails_complete += 1
	if type != "Spam":
		if input == "Normal":
			Global.audio_manager.play_email_sfx("sent")
		if input == "Accept":
			Global.audio_manager.play_email_sfx("correct") # ignore names
		if input == "Decline":
			Global.audio_manager.play_email_sfx("incorrect") # ignore names
	elif input == "Spam":
		Global.audio_manager.play_email_sfx("deleted")
	else:
		Global.audio_manager.incorrect_sfx.pitch_scale = randf_range(0.99, 1.01)
		Global.audio_manager.incorrect_sfx.play()
	
	expanded_email_text.visible = false
	all.visible = false
	Global.email_open = false # used to tell other emails to work again
	open = false
	#start JT
	#Global.reset_mouse_position()
	#Global.cursor_sprite.flip_v = false
	#end JT
	
	var scale_box_tween = create_tween().tween_property(self.get_node("EmailBubble"), "size", Vector2(800, 50), 0.1) # make box fit screen
	var scale_text_tween = create_tween().tween_property(flavor_text, "size", Vector2(350, 24), 0.2) # make text fit screen
	var change_text_tween = create_tween().tween_property(flavor_text, "custom_maximum_size", Vector2(350, 30), 0.2) # stop ellipses from appearing
	var move_buttons_tween = create_tween().tween_property(self.get_node("Buttons"), "position", Vector2(0, 0), 0.2) # move buttons to original place
	
	await move_buttons_tween.finished
	Global.audio_manager.play_virus_opened()
	
	
	if type == "Normal":
		if input == "Upload":
			Global.manager.summon_boss()
		if input == "Accept" || input == "Decline":
			Global.manager.add_more_emails(1)
	
	if type == "Accept":
		if input == "Normal" || input == "Spam":
			Global.manager.summon_boss()
		if input == "Decline":
			Global.manager.add_more_emails(3)
		if input == "Upload":
			Global.manager.add_more_emails(1)
	
	if type == "Decline":
		if input == "Upload":
			Global.manager.add_more_emails(1)
		if input == "Accept":
			Global.manager.add_more_emails(3)
		if input == "Normal" || input == "Spam":
			Global.manager.summon_boss()
	
	if type == "Spam":
		if input == "Upload":
			Global.manager.create_popups(10)
		if input == "Accept" || input == "Decline":
			Global.manager.add_more_emails(5)
			#Global.manager.weird_mouse() # doesnt work and may permalock you. USE F8 IF YOU GET STUCK
		if input == "Normal":
			Global.manager.add_more_emails(1)
			Global.manager.create_popups(3)
	
	if type == "Upload":
		if input == "Spam":
			Global.manager.summon_boss()
		if input == "Accept" || input == "Decline":
			Global.manager.summon_boss()
		if input == "Normal":
			Global.manager.add_more_emails(3)
	
	expanded_email_text.visible = false
	all.visible = false
	Global.email_open = false # used to tell other emails to work again
	open = false
	deleted = true # let the manager know that it shouldnt account for this email anymore
	z_index = -1 # get it out of the way to avoid overlap
	var slide_out = create_tween().tween_property(self, "position", Vector2(-2000.0, position.y), 0.5)
	await slide_out.finished
	
	queue_free()

func open_email(type):
	Global.email_open = true # used to tell other emails not to open
	open = true
	base_read_button.visible = false # hide the regular read button used to open the email
	all.visible = true # show the correct buttons for the email type, hidden earlier in the script
	expanded_email_text.visible = true
	
	var scale_box_tween = create_tween().tween_property(self.get_node("EmailBubble"), "size", Vector2(800, 600), 0.2) # make box fit screen
	var scale_text_tween = create_tween().tween_property(flavor_text, "size", Vector2(350, 400), 0.2) # make text fit screen
	var change_text_tween = create_tween().tween_property(flavor_text, "custom_maximum_size", Vector2(350, 400), 0.2) # stop ellipses from appearing
	var move_tween = create_tween().tween_property(self, "position", Vector2(0, 0), 0.2) # move box to right position
	var move_buttons_tween = create_tween().tween_property(self.get_node("Buttons"), "position", Vector2(-30, 480), 0.2) # move buttons to bottom
	z_index = 5
	# start Psuedo Pakman
	expanded_email_text.visible = true
	# end Psuedo Pakman
	# startJT
	if(type == "Spam"):
		Global.set_mouse_invert(true)
		Global.cursor_sprite.flip_v = true
	#end JT
	
# special interaction stuff
func _on_read_pressed():
	if open:
		delete_email("Normal")
	elif not Global.email_open:
		open_email(type)

func _on_yes_pressed():
	if open:
		delete_email("Accept")
	elif not Global.email_open:
		open_email(type)

func _on_no_pressed():
	if open:
		delete_email("Decline")
	elif not Global.email_open:
		open_email(type)

func _on_delete_pressed():
	if open:
		delete_email("Spam")
	elif not Global.email_open:
		open_email(type)

func _on_upload_pressed(): # i think i did this one wrong (?)
	if open:
		Global.audio_manager.play_email_sfx("uploading")
		while upload_button.button_pressed:
			await get_tree().physics_frame
			progress += 1
			upload_bar.value = progress
		
		if progress >= 100:
			delete_email("Upload")
		else:
			if not upload_button.button_pressed:
				progress = 0
				upload_bar.value = progress
				Global.audio_manager.stop_uploading()
	
	elif not Global.email_open:
		open_email(type)
# end ByDesign
