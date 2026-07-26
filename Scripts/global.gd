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
# end ByDesign

#start ampbeetle

var master_bus = AudioServer.get_bus_index("Master")
var music_bus = AudioServer.get_bus_index("Music")
var sfx_bus = AudioServer.get_bus_index("SFX")

var _master = 0.8
var _sfx = 0.8
var _music = 0.8

var _mouse_sensitivity: Vector2 = Vector2(1.0, 1.0)

var _window_mode

#end ampbeetle
