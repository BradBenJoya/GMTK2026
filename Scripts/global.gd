# start ByDesign
extends Node # replace if desired

# i cant figure out how to do this properly
@onready var main : Node2D = get_tree().get_root().get_node("Main") # adjust if needed
@onready var manager : Node2D = get_tree().get_root().get_node("Main/Monitor/SubViewport/Manager") # adjust if needed
var email_open : bool = false
# end ByDesign
