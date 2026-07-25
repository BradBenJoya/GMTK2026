# start ByDesign
extends Node # replace if desired

# i cant figure out how to do this properly
@onready var main : Node2D = get_tree().get_root().get_node("Main") # adjust if needed
@onready var manager : Node2D = get_tree().get_root().get_node("Main/Monitor/SubViewport/Manager") # adjust if needed
@onready var audio_manager : Node = get_tree().get_root().get_node("Main/AudioManager") # adjust if needed
var email_open : bool = false
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
