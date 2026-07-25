# start ByDesign
extends Node2D

# start Psuedo Pakman
@export_group("Scenes")
@export var main_menu: PackedScene
@export var monitor: PackedScene

@export var upgrade_list: Array[UpgradeItem]

@export_group("Stats")
@export var upload_speed: float = 100
@export var virus_chance: float = 100
@export var spam_chance: float = 100
@export var email_speed: float = 100

enum GameState {
	MAIN_MENU,
	GAME,
	PAUSE_MENU # add this later
}

enum UpgradeType {
	UPLOAD_SPEED,
	VIRUS_CHANCE,
	SPAM_CHANCE,
	EMAIL_SPEED
}

var game_state: GameState = GameState.MAIN_MENU:
	set(value):
		if game_state == value:
			return # no change, don't redo work
		game_state = value
		_on_state_changed(value)
		
var current_scene_instance: Node = null
# end Psuedo Pakman

var clock : float = 0.0 # + 9 to it and go to 7 to simulate 9 to 5
var total_emails : int = 0

@export var counter : Label
@export var time : Label
var upgrade_time = false
var tween_time

@export var day_duration : float = 300.0  # was 300, but shortening for testing

func _ready():
	$UpgradeTimer.start(day_duration / 8)
	
	for button in %UpgradeChoice.get_children():
		button.upgrade_list = upgrade_list
	
	# start Psuedo Pakman
	# trigger initial setup once
	_on_state_changed(game_state)
	# end Psuedo Pakman
	
	tween_time = create_tween().tween_property(self, "clock", 8.0, day_duration)
	await tween_time.finished

func _process(delta):
	counter.text = "Inbox " + str(total_emails)
	
	# clock stuff! :D
	if floor(clock + 9) > 12: 
		time.text = str(int(fmod(floor(clock + 9), 12))) + ":%02.f" % floor(fmod(clock + 9, 1)*60) + " PM"
	elif fmod(floor(clock + 9), 12) == 0:
		time.text = "12" + ":%02.f" % floor(fmod(clock + 9, 1)*60) + " PM"
	else:
		time.text = str(int(fmod(floor(clock + 9), 12))) + ":%02.f" % floor(fmod(clock + 9, 1)*60) + " AM"
	
	if fmod(snappedf(clock, 0.01), 1) == 0 and upgrade_time:
		choose_upgrade()
		game_state = GameState.PAUSE_MENU
		%UpgradeBox.show()


# start Psuedo Pakman
func _on_state_changed(new_state: GameState) -> void:
	# clear out whatever was there before
	if new_state != GameState.PAUSE_MENU and current_scene_instance:
		current_scene_instance.queue_free()
		current_scene_instance = null
		
	match new_state:
		GameState.MAIN_MENU:
			$MainMenu.show()
			#current_scene_instance = main_menu.instantiate()
			#add_child(current_scene_instance)
			var play_button = $MainMenu.get_node("TempPlayButton")
			play_button.play_pressed.connect(_on_play_pressed)
			var options_button = $MainMenu.get_node("TempOptionButton")
			options_button.play_pressed.connect(_on_options_pressed)
			var quit_button = $MainMenu.get_node("TempQuitButton")
			quit_button.play_pressed.connect(_on_quit_pressed)
			get_tree().paused = true
		GameState.GAME:
			$MainMenu.hide()
			get_tree().paused = false
		GameState.PAUSE_MENU:
			get_tree().paused = true

func _on_play_pressed() -> void:
	game_state = GameState.GAME
	Global.manager.create_emails()
	Global.audio_manager.transition_from_menu()
# end Psuedo Pakman
# end ByDesign

#start ampbeetle
func _on_options_pressed() -> void:
	$Options.show()

func _on_quit_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func choose_upgrade():
	for child in %UpgradeChoice.get_children():
		child.random_card()

func _on_upgrade_selected(source: BaseButton) -> void:
	# Unpresses other buttons whenever a button is pressed.
	for button in %UpgradeChoice.get_children():
		if button != source:
			button.button_pressed = false

func _on_accept_button_pressed() -> void:
	for button in %UpgradeChoice.get_children():
		if button.button_pressed == true:
			# Cycles through effects of upgrade and adds it's value to relevant stat.
			for effect in button.effects:
				match effect:
					UpgradeType.UPLOAD_SPEED:
						upload_speed += button.effects[effect]
					UpgradeType.VIRUS_CHANCE:
						virus_chance += button.effects[effect]
					UpgradeType.SPAM_CHANCE:
						spam_chance += button.effects[effect]
					UpgradeType.EMAIL_SPEED:
						email_speed += button.effects[effect]
			
			# Don't want it to reappear
			game_state = GameState.GAME
			upgrade_time = false
			%UpgradeBox.hide()
		
		# Re-add upgrade (for now, at least)
		upgrade_list.push_back(button.upgrade)
		
		# Making sure all buttons are unpressed for next go.
		button.button_pressed = false

#add something to disable accept button unless an upgrade is selected

func _on_upgrade_timer_timeout() -> void:
	upgrade_time = true

func _on_options_button_pressed() -> void:
	$Options.show()
	game_state = GameState.PAUSE_MENU

func _on_exit_button_pressed() -> void:
	$Options.hide()
	game_state = GameState.GAME

func _on_main_button_pressed() -> void:
	#add a "are you sure?" later
	game_state = GameState.MAIN_MENU
	$Options.hide()

func _on_apply_button_pressed() -> void:
	if Global._window_mode == 0:  # window mode
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	elif Global._window_mode == 1:  # fullscreen mode
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	$Options.hide()
	game_state = GameState.GAME

#end ampbeetle
