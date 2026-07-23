extends Node
class_name FlavorTextController

@export_group("Flavor Text - Read")
@export var read_text : Array[String]
@export var expanded_read_text : Array[String]

@export_group("Flavor Text - Decision")
@export var decision_good_text : Array[String]
@export var decision_bad_text : Array[String]
@export var expanded_decision_good_text : Array[String]
@export var expanded_decision_bad_text : Array[String]

@export_group("Flavor Text - Spam")
@export var spam_text : Array[String]
@export var expanded_spam_text : Array[String]

@export_group("Flavor Text - Upload")
@export var upload_text : Array[String]
@export var expanded_upload_text : Array[String]
