# start ByDesign
@tool
extends Node

# making the in editor stuff work
@export_tool_button("Refresh Variables") var refresh_variables = func update_vars(): notify_property_list_changed()

@export_group("People")
@export var read_people : Array[String] = []
@export var accept_people : Array[String] = []
@export var decline_people : Array[String] = []
@export var spam_people : Array[String] = []
@export var upload_people : Array[String] = []

@export_group("Topics")
@export var read_topics : Array[String] = []
@export var accept_topics : Array[String] = []
@export var decline_topics : Array[String] = []
@export var spam_topics : Array[String] = []
@export var upload_topics : Array[String] = []

@export_group("Extended")
var topics_expanded : Dictionary = {}
# dynamic variables created in _get_property_list()

# changing this function may result in Godot crashing, and my script breaking, as this runs even while in the editor. you have been warned
func _get_property_list():
	var properties: Array[Dictionary] = []
	
	properties.append({
		"name": "Read Extended",
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_SUBGROUP
	})
	
	for variable in read_topics:
		if variable != "":
			properties.append({
				"name": "read: " + variable,
				"type": TYPE_PACKED_STRING_ARRAY,
				"usage": PROPERTY_USAGE_DEFAULT,
				"hint": PROPERTY_HINT_NONE,
				"hint_string": ""
			})
	
	properties.append({
		"name": "Accept Extended",
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_SUBGROUP
	})
	
	for variable in accept_topics:
		if variable != "":
			properties.append({
				"name": "accept: " + variable,
				"type": TYPE_PACKED_STRING_ARRAY,
				"usage": PROPERTY_USAGE_DEFAULT,
				"hint": PROPERTY_HINT_NONE,
				"hint_string": ""
			})
	
	properties.append({
		"name": "Decline Extended",
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_SUBGROUP
	})
	
	for variable in decline_topics:
		if variable != "":
			properties.append({
				"name": "decline: " + variable,
				"type": TYPE_PACKED_STRING_ARRAY,
				"usage": PROPERTY_USAGE_DEFAULT,
				"hint": PROPERTY_HINT_NONE,
				"hint_string": ""
			})
	
	properties.append({
		"name": "Spam Extended",
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_SUBGROUP
	})
	
	for variable in spam_topics:
		if variable != "":
			properties.append({
				"name": "spam: " + variable,
				"type": TYPE_PACKED_STRING_ARRAY,
				"usage": PROPERTY_USAGE_DEFAULT,
				"hint": PROPERTY_HINT_NONE,
				"hint_string": ""
			})
	
	properties.append({
		"name": "Upload Extended",
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_SUBGROUP
	})
	
	for variable in upload_topics:
		if variable != "":
			properties.append({
				"name": "upload: " + variable,
				"type": TYPE_PACKED_STRING_ARRAY,
				"usage": PROPERTY_USAGE_DEFAULT,
				"hint": PROPERTY_HINT_NONE,
				"hint_string": ""
			})
	
	return properties

# changing this function may result in Godot crashing, and my script breaking, as this runs even while in the editor. you have been warned
func _get(property):
	property = property.replace("read: ", "").replace("accept: ", "").replace("decline: ", "").replace("spam: ", "").replace("upload: ", "")
	if property in read_topics:
		if topics_expanded.has(property):
			return topics_expanded[property]
		else:
			topics_expanded[property] = ""
			return property
	return null

# changing this function may result in Godot crashing, and my script breaking, as this runs even while in the editor. you have been warned
func _set(property, value):
	property = property.replace("read: ", "").replace("accept: ", "").replace("decline: ", "").replace("spam: ", "").replace("upload: ", "")
	if property in read_topics:
		topics_expanded[property] = value
		return true
	return false


# creating the email
func create_email(type):
	var sender = choose_sender(type)
	var topic = choose_topic(type)
	var text = choose_expanded_text(topic)
	
	return [sender + " - " + topic, text]

func choose_sender(type):
	if type == "Normal":
		return read_people.pick_random()
	if type == "Accept":
		return accept_people.pick_random()
	if type == "Decline":
		return decline_people.pick_random()
	if type == "Spam":
		return spam_people.pick_random()
	if type == "Upload":
		return upload_people.pick_random()

func choose_topic(type):
	if type == "Normal":
		return read_topics.pick_random()
	if type == "Accept":
		return accept_topics.pick_random()
	if type == "Decline":
		return decline_topics.pick_random()
	if type == "Spam":
		return spam_topics.pick_random()
	if type == "Upload":
		return upload_topics.pick_random()

func choose_expanded_text(topic):
	return get(topic)[randi_range(0, get(topic).size() - 1)] # .pick_random doesnt work for packed string arrays
# end ByDesign
