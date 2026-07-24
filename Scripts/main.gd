# start ByDesign
extends Node2D

# start Psuedo Pakman
@export_group("Scenes")
@export var main_menu: PackedScene
@export var monitor: PackedScene

enum GameState {
	MAIN_MENU,
	GAME
}

var game_state: GameState = GameState.MAIN_MENU:
	set(value):
		if game_state == value:
			return # no change, don't redo work
		game_state = value
		_on_state_changed(value)
		
var current_scene_instance: Node = null
var clock : float = 0.0 # + 9 to it and go to 7 to simulate 9 to 5
# end Psuedo Pakman

var total_emails : int = 0

@export var counter : Label
@export var time : Label

@export var day_duration : float = 300.0

var clock_tween : Tween = null


func _ready() -> void:
	Global.main = self
	# trigger initial setup once
	_on_state_changed(game_state)


func _process(_delta: float) -> void:
	if counter:
		counter.text = "Inbox " + str(total_emails)
	
	if time:
		# clock stuff! :D
		var current_hour : int = int(floor(clock + 9.0))
		if current_hour > 12:
			time.text = str(current_hour - 12) + " PM"
		elif current_hour == 12:
			time.text = "12 PM"
		else:
			time.text = str(current_hour) + " AM"


func start_workday() -> void:
	clock = 0.0
	if clock_tween and clock_tween.is_running():
		clock_tween.kill()
	clock_tween = create_tween()
	clock_tween.tween_property(self, "clock", 8.0, day_duration)
	clock_tween.finished.connect(_on_day_ended)
	
	if Global.manager:
		Global.manager.start_spawning()


func _on_day_ended() -> void:
	print("end game")


# start Psuedo Pakman
func _on_state_changed(new_state: GameState) -> void:
	# clear out whatever was there before
	if current_scene_instance:
		current_scene_instance.queue_free()
		current_scene_instance = null
		
	match new_state:
		GameState.MAIN_MENU:
			if main_menu:
				current_scene_instance = main_menu.instantiate()
				if current_scene_instance is CanvasItem:
					(current_scene_instance as CanvasItem).z_index = 100
				add_child(current_scene_instance)
				if current_scene_instance.has_node("TempPlayButton"):
					var play_button = current_scene_instance.get_node("TempPlayButton")
					if play_button.has_signal("play_pressed"):
						play_button.play_pressed.connect(_on_play_pressed)
					elif play_button.has_signal("pressed"):
						play_button.pressed.connect(_on_play_pressed)
		GameState.GAME:
			start_workday()


func _on_play_pressed() -> void:
	game_state = GameState.GAME
# end Psuedo Pakman
# end ByDesign
