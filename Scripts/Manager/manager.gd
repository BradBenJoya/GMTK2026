# start ByDesign
extends Node2D

@export_group("Email Speed")
@export var minimum_speed : float = 0.1
@export var maximum_speed : float = 2.0

# start Psuedo Pakman
@export var email_scene : PackedScene
# end Psuedo Pakman

var emails : Array = []
var is_spawning : bool = false


func _ready() -> void:
	Global.manager = self


func start_spawning() -> void:
	if is_spawning:
		return
	is_spawning = true
	create_emails()


func create_emails() -> void:
	if not email_scene:
		return
		
	for i in 50:
		if not is_inside_tree() or not is_spawning:
			return
		var new_email = email_scene.instantiate()
		new_email.position = Vector2(60, -1000)
		
		add_child(new_email)
		emails.append(new_email)
		
		var delay : float = randf_range(minimum_speed, maximum_speed)
		await get_tree().create_timer(delay).timeout


func _process(delta: float) -> void:
	# Filter out invalid or deleted emails safely before iteration
	var valid_emails: Array = []
	for email in emails:
		if is_instance_valid(email) and not email.deleted:
			valid_emails.append(email)
	emails = valid_emails

	if Global.main: # failsafe
		Global.main.total_emails = emails.size()
	
	var i : int = 0
	for email in emails:
		if not email.open:
			var target_pos : Vector2 = Vector2(60, 930 - (i * 90))
			email.position = email.position.lerp(target_pos, 12.0 * delta)
		
		i += 1


func add_more_emails(amount : int) -> void:
	if not email_scene:
		return
	for i in amount:
		var new_email = email_scene.instantiate()
		new_email.position = Vector2(60, -1000)
		
		add_child(new_email)
		emails.append(new_email)
# end ByDesign
