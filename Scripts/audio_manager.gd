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

func play_mouse_click():
	mouse_click.pick_random().play()

func play_boss_yell():
	boss_yell.pick_random().play()

func play_virus_opened():
	virus_opened.pick_random().play()

func play_email_sfx(type):
	get(type).pick_random().play()
	print("PLAY")

func stop_uploading():
	for sound in uploading:
		sound.stop()
