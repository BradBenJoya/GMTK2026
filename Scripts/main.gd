# start ByDesign
extends Node2D

var total_emails : int = 0

func _ready():
	pass

func _process(delta):
	$TempScore.text = "Emails \n" + str(total_emails)

# end ByDesign
