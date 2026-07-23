# start ByDesign
extends Node2D

var score : int = 0

func _ready():
	pass

func _process(delta):
	$TempScore.text = str(score)

# end ByDesign
