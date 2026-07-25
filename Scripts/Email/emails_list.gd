@tool
extends Node

@export_tool_button("Refresh Variables") var refresh_variables = func update_vars(): notify_property_list_changed()
@export var email_starters : Array[String] = []

var expanded_types : Dictionary = {}
var expanded_text : Dictionary = {}

func _get_property_list():
	var properties: Array[Dictionary] = []
	
	for topic in email_starters:
		if topic != "":
			properties.append({
				"name": topic,
				"type": TYPE_NIL,
				"usage": PROPERTY_USAGE_SUBGROUP
			})
			
			properties.append({
				"name": topic + " : Type",
				"type": TYPE_STRING,
				"usage": PROPERTY_USAGE_DEFAULT,
				"hint": PROPERTY_HINT_ENUM,
				"hint_string": "Normal,Accept,Decline,Spam,Upload"
			})
			
			properties.append({
				"name": topic + " : Extended",
				"type": TYPE_STRING,
				"usage": PROPERTY_USAGE_DEFAULT,
				"hint": PROPERTY_HINT_NONE,
				"hint_string": ""
			})
	
	return properties

func _get(property):
	if property.trim_suffix(" : Type").trim_suffix(" : Extended") in email_starters:
		if property.contains(" : Type"):
			return expanded_types[property.trim_suffix(" : Type").trim_suffix(" : Extended")]
		if property.contains(" : Extended"):
			return expanded_text[property.trim_suffix(" : Type").trim_suffix(" : Extended")]
	return null

func _set(property, value):
	if property.trim_suffix(" : Type").trim_suffix(" : Extended") in email_starters:
		if property.contains(" : Type"):
			expanded_types[property.trim_suffix(" : Type").trim_suffix(" : Extended")] = value
		if property.contains(" : Extended"):
			expanded_text[property.trim_suffix(" : Type").trim_suffix(" : Extended")] = value
		return true
	return false

func create_email(type):
	var available_options := []
	for email in email_starters:
		if expanded_types[email] == type:
			available_options.append(email)
	
	var chosen_email = available_options.pick_random()
	
	return [chosen_email, expanded_text[chosen_email]]
