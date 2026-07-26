extends Node

@export_group("Songs")
@export var level_loop : AudioStreamPlayer
@export var virus_loop : AudioStreamPlayer
@export var level_ambience : AudioStreamPlayer
@export var menu_loop : AudioStreamPlayer

@export_group("SFX")
@export var mouse_click : Array[AudioStreamPlayer]
@export var boss_yell : Array[AudioStreamPlayer]
@export var virus_opened : Array[AudioStreamPlayer]
@export_subgroup("Email SFX")
@export var correct : Array[AudioStreamPlayer]
@export var incorrect : Array[AudioStreamPlayer]
@export var deleted : Array[AudioStreamPlayer]
@export var uploading : Array[AudioStreamPlayer]
@export var recieved : Array[AudioStreamPlayer]
@export var sent : Array[AudioStreamPlayer]

func _ready():
	menu_loop.play()

func play_mouse_click():
	mouse_click.pick_random().play()

func play_boss_yell():
	boss_yell.pick_random().play()

func play_virus_opened():
	virus_opened.pick_random().play()

func play_email_sfx(type):
	get(type).pick_random().play()

func stop_uploading():
	for sound in uploading:
		sound.stop()

func transition_to_level():
	var loop_tween = create_tween().tween_property(level_loop, "volume_linear", 0.3, 0.5).from(0.0)
	var ambience_tween = create_tween().tween_property(level_ambience, "volume_linear", 1.0, 0.5).from(0.0)
	var virus_tween = create_tween().tween_property(virus_loop, "volume_linear", 0.0, 0.5).from(1.0)

func transition_from_menu():
	level_loop.play()
	level_ambience.play()
	virus_loop.play()
	virus_loop.volume_linear = 0.0
	var loop_tween = create_tween().tween_property(level_loop, "volume_linear", 0.3, 0.5).from(0.0)
	var ambience_tween = create_tween().tween_property(level_ambience, "volume_linear", 1.0, 0.5).from(0.0)
	var menu_tween = create_tween().tween_property(menu_loop, "volume_linear", 0.0, 0.5).from(1.0)

func transition_to_virus():
	var loop_tween = create_tween().tween_property(level_loop, "volume_linear", 0.0, 0.5).from(0.3)
	var ambience_tween = create_tween().tween_property(level_ambience, "volume_linear", 0.0, 0.5).from(1.0)
	var virus_tween = create_tween().tween_property(virus_loop, "volume_linear", 1.0, 0.5).from(0.0)
