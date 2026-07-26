# start ByDesign
extends Node # replace if desired

# i cant figure out how to do this properly
@onready var main : Node2D = get_tree().get_root().get_node("Main") # adjust if needed
@onready var manager : Node2D = get_tree().get_root().get_node("Main/Monitor/SubViewport/Manager") # adjust if needed
@onready var audio_manager : Node = get_tree().get_root().get_node("Main/AudioManager") # adjust if needed
@onready var boss : Node = get_tree().get_root().get_node("Main/Boss") # adjust if needed
var email_open : bool = false
var virus : bool = false

var emails_complete : int = 0
var total_emails : int = 0
var total_viruses : int = 0
var total_boss_yells : int = 0

var game_end : bool = false

func reset(): # reset the values to make sure restarting the game actually sets the values properly
	await get_tree().process_frame
	main = get_tree().get_root().get_node("Main") # adjust if needed
	manager = get_tree().get_root().get_node("Main/Monitor/SubViewport/Manager") # adjust if needed
	audio_manager = get_tree().get_root().get_node("Main/AudioManager") # adjust if needed
	boss = get_tree().get_root().get_node("Main/Boss") # adjust if needed
	
	main.started = false
	
	email_open = false
	virus = false
	
	emails_complete = 0
	total_emails = 0
	total_viruses = 0
	total_boss_yells = 0
	
	game_end = false
	
	cursor_sprite = FakeCursorCanvas.get_node("CursorSprite")
	monitor_container = get_tree().get_root().get_node("Main/Monitor")
# end ByDesign

#start ampbeetle

var master_bus = AudioServer.get_bus_index("Master")
var music_bus = AudioServer.get_bus_index("Music")
var sfx_bus = AudioServer.get_bus_index("SFX")

var _master = 0.8
var _sfx = 0.8
var _music = 0.8

var _mouse_sensitivity: Vector2 = Vector2(1.0, 1.0)

var _scroll_speed = 1.0

var _window_mode

#end ampbeetle
#start JT
signal email_correctly_answered
var correct_emails : int = 0
var cursor_position : Vector2 = Vector2.ZERO
var invert : bool = false
signal fake_mouse_clicked
signal fake_mouse_pressed   # new: fires once on mouse-down
signal fake_mouse_released  # new: fires once on mouse-up
signal boss_summoned
signal boss_left
var mouse_held : bool = false  # new: true for every frame the button is down
@onready var cursor_sprite: Sprite2D = FakeCursorCanvas.get_node("CursorSprite")
@onready var monitor_container : SubViewportContainer = get_tree().get_root().get_node("Main/Monitor")

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	cursor_position = get_viewport().get_mouse_position()
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN # stop from leaving screen
	boss_summoned.connect(_on_boss_summoned)
	boss_left.connect(_on_boss_left)
	
func _on_boss_summoned():
	process_mode = Node.PROCESS_MODE_DISABLED
	
func _on_boss_left():
	process_mode = Node.PROCESS_MODE_ALWAYS
	reset_mouse_position()

	
func _process(delta: float) -> void:
	cursor_sprite.global_position = cursor_position
	
	if Input.is_action_just_pressed("Click"):
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
		audio_manager.play_mouse_click()

func _input(event):
	if event is InputEventMouseMotion:
		if invert:
			cursor_position -= event.relative
		else:
			reset_mouse_position() # There are weird edge cases on startup if I use event relative 
		var screen_size := get_viewport().get_visible_rect().size
		cursor_position.x = clamp(cursor_position.x, 0, screen_size.x)
		cursor_position.y = clamp(cursor_position.y, 0, screen_size.y)
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				mouse_held = true
				fake_mouse_clicked.emit()
				fake_mouse_pressed.emit()
			else:
				mouse_held = false
				fake_mouse_released.emit()
func reset_mouse_position() -> void:
	cursor_position = get_viewport().get_mouse_position()
	
func set_mouse_invert(value: bool):
	invert = value
	
func _notification(what):
	if what == NOTIFICATION_APPLICATION_FOCUS_IN or what == NOTIFICATION_WM_MOUSE_ENTER:
		if (get_viewport() != null and get_viewport().get_mouse_position() != null and not invert):
			cursor_position = get_viewport().get_mouse_position()

func cursor_pos_in_subviewport(container: SubViewportContainer) -> Vector2:
	var root_viewport := get_tree().root
	var canvas_transform := root_viewport.get_canvas_transform()
	var canvas_pos: Vector2 = canvas_transform.affine_inverse() * cursor_position

	var container_rect := container.get_global_rect()
	var relative_pos := canvas_pos - container_rect.position

	var sub_vp := container.get_child(0) as SubViewport
	var scale_factor := Vector2(sub_vp.size) / container_rect.size
	return relative_pos * scale_factor
#end JT
