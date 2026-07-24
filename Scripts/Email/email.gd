# start ByDesign
extends Control
class_name Email

@export_group("Nodes")
@export var flavor_text : Label

# start Psudeo Pakman
@export var collapsed_email_text: Label
# end Psuedo Pakman

@export var upload_button : Button
@export var upload_bar : ProgressBar
@export var base_read_button : Button

@export_group("Scripts") # sorry, shoulda probably split this up (?)
@export var flavor_text_controller : FlavorTextController

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


func _ready() -> void:
	base_scale = scale
	all.visible = false

	var random : float = randf_range(1, 100)
	if random < 70:
		type = "Normal"
		if flavor_text_controller and flavor_text_controller.read_text.size() > 0:
			flavor_text.text = flavor_text_controller.read_text.pick_random().replace("\\n", "\n")
		if email_stuff:
			email_stuff.visible = true
		if collapsed_email_text and flavor_text_controller and flavor_text_controller.expanded_read_text.size() > 0:
			collapsed_email_text.text = flavor_text_controller.expanded_read_text.pick_random()
	else:
		var special_random : int = randi_range(1, 4)

		if special_random == 1:
			type = "Accept"
			if flavor_text_controller and flavor_text_controller.decision_good_text.size() > 0:
				flavor_text.text = flavor_text_controller.decision_good_text.pick_random().replace("\\n", "\n")
			if decision_stuff:
				decision_stuff.visible = true
			if collapsed_email_text and flavor_text_controller and flavor_text_controller.expanded_decision_good_text.size() > 0:
				collapsed_email_text.text = flavor_text_controller.expanded_decision_good_text.pick_random()
		elif special_random == 2:
			type = "Decline"
			if flavor_text_controller and flavor_text_controller.decision_bad_text.size() > 0:
				flavor_text.text = flavor_text_controller.decision_bad_text.pick_random().replace("\\n", "\n")
			if decision_stuff:
				decision_stuff.visible = true
			if collapsed_email_text and flavor_text_controller and flavor_text_controller.expanded_decision_bad_text.size() > 0:
				collapsed_email_text.text = flavor_text_controller.expanded_decision_bad_text.pick_random()
		elif special_random == 3:
			type = "Spam"
			if flavor_text_controller and flavor_text_controller.spam_text.size() > 0:
				flavor_text.text = flavor_text_controller.spam_text.pick_random().replace("\\n", "\n")
			if email_stuff:
				email_stuff.visible = true
			if collapsed_email_text and flavor_text_controller and flavor_text_controller.expanded_spam_text.size() > 0:
				collapsed_email_text.text = flavor_text_controller.expanded_spam_text.pick_random()
		elif special_random == 4:
			type = "Upload"
			if flavor_text_controller and flavor_text_controller.upload_text.size() > 0:
				flavor_text.text = flavor_text_controller.upload_text.pick_random().replace("\\n", "\n")
			if upload_stuff:
				upload_stuff.visible = true
			if collapsed_email_text and flavor_text_controller and flavor_text_controller.expanded_upload_text.size() > 0:
				collapsed_email_text.text = flavor_text_controller.expanded_upload_text.pick_random()


func _process(delta: float) -> void:
	if base_read_button:
		if Global.email_open and not open:
			base_read_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		else:
			base_read_button.mouse_filter = Control.MOUSE_FILTER_STOP
	
	if not open and not deleted:
		var is_hovered : bool = abs(get_global_mouse_position().y - global_position.y) <= 25 and abs(get_global_mouse_position().x - global_position.x) < 600
		var target_scale : Vector2 = base_scale * 1.05 if is_hovered else base_scale
		scale = scale.lerp(target_scale, 15.0 * delta)

	# Handle Upload progress filling while button is held down
	if open and type == "Upload" and not deleted:
		if upload_button and upload_button.is_pressed():
			progress += delta * 65.0
			if upload_bar:
				upload_bar.value = progress
			if progress >= 100.0:
				delete_email("Upload")
		elif progress > 0.0 and progress < 100.0:
			progress = max(0.0, progress - delta * 50.0)
			if upload_bar:
				upload_bar.value = progress


func delete_email(input : String) -> void: # delete email after doing little animation
	deleted = true # let the manager know immediately not to interpolate position
	open = false
	all.visible = false
	Global.email_open = false # used to tell other emails to work again
	
	var email_bubble = get_node_or_null("EmailBubble")
	if email_bubble:
		create_tween().tween_property(email_bubble, "size", Vector2(800, 50), 0.2)
	if flavor_text:
		create_tween().tween_property(flavor_text, "size", Vector2(350, 24), 0.2)
		create_tween().tween_property(flavor_text, "custom_maximum_size", Vector2(350, 30), 0.2)
	var buttons_node = get_node_or_null("Buttons")
	if buttons_node:
		var move_buttons_tween = create_tween().tween_property(buttons_node, "position", Vector2(0, 0), 0.2)
		await move_buttons_tween.finished
	
	if not input == type: # shake if messed up
		modulate = Color.LIGHT_CORAL
		var shake = create_tween().tween_method(func(i): position.x = sin(i) * 20.0, 0.0, -4 * PI, 0.3)
		await shake.finished
	else:
		modulate = Color.LIGHT_GREEN
	
	z_index = -1 # get it out of the way to avoid overlap
	var slide_out = create_tween().tween_property(self, "position", Vector2(-2000.0, position.y), 0.5)
	await slide_out.finished
	
	queue_free()


func open_email() -> void:
	Global.email_open = true # used to tell other emails not to open
	open = true
	if base_read_button:
		base_read_button.visible = false # hide the regular read button used to open the email
	all.visible = true # show the correct buttons for the email type, hidden earlier in the script
	
	var email_bubble = get_node_or_null("EmailBubble")
	if email_bubble:
		create_tween().tween_property(email_bubble, "size", Vector2(800, 600), 0.2)
	if flavor_text:
		create_tween().tween_property(flavor_text, "size", Vector2(350, 400), 0.2)
		create_tween().tween_property(flavor_text, "custom_maximum_size", Vector2(350, 400), 0.2)
	create_tween().tween_property(self, "position", Vector2(0, 0), 0.2)
	var buttons_node = get_node_or_null("Buttons")
	if buttons_node:
		create_tween().tween_property(buttons_node, "position", Vector2(-30, 480), 0.2)
	z_index = 5
	# start Psuedo Pakman
	if collapsed_email_text:
		collapsed_email_text.visible = true
	# end Psuedo Pakman


# special interaction stuff
func _on_read_pressed() -> void:
	if open:
		delete_email("Normal")
	elif not Global.email_open:
		open_email()


func _on_yes_pressed() -> void:
	if open:
		delete_email("Accept")
	elif not Global.email_open:
		open_email()


func _on_no_pressed() -> void:
	if open:
		delete_email("Decline")
	elif not Global.email_open:
		open_email()


func _on_delete_pressed() -> void:
	if open:
		delete_email("Spam")
	elif not Global.email_open:
		open_email()


func _on_upload_pressed() -> void:
	if not open and not Global.email_open:
		open_email()
# end ByDesign
