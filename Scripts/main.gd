# start ByDesign
extends Node2D

var clock : float = 0.0 # + 9 to it and go to 7 to simulate 9 to 5
var total_emails : int = 0

@export var counter : Label
@export var time : Label

@export var day_duration : float = 300.0

func _ready():
	var tween_time = create_tween().tween_property(self, "clock", 8.0, 300.0)
	await tween_time.finished
	print("end game")

func _process(delta):
	counter.text = "Inbox " + str(total_emails)
	
	# clock stuff! :D
	if round(clock + 9) > 12:
		time.text = str(int(fmod(round(clock + 9), 12))) + " PM"
	elif fmod(round(clock + 9), 12) == 0:
		time.text = "12 PM"
	else:
		time.text = str(int(fmod(round(clock + 9), 12))) + " AM"

# end ByDesign
