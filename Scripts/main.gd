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
# end Psuedo Pakman

var score : int = 0

func _ready():
	# start Psuedo Pakman
	# trigger initial setup once
	_on_state_changed(game_state)
	# end Psuedo Pakman

func _process(delta):
	# start Psuedo Pakman
	if (game_state == GameState.GAME):
		# end Psuedo Pakman
		$TempScore.text = str(score)
	
# start Psuedo Pakman
func _on_state_changed(new_state: GameState) -> void:
	# clear out whatever was there before
	if current_scene_instance:
		current_scene_instance.queue_free()
		current_scene_instance = null

	match new_state:
		GameState.MAIN_MENU:
			current_scene_instance = main_menu.instantiate()
			add_child(current_scene_instance)
		GameState.GAME:
			current_scene_instance = monitor.instantiate()
			add_child(current_scene_instance)
			
# end Psuedo Pakman
# end ByDesign
