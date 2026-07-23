# start Psuedo Pakman
extends Button
class_name BaseUpgrade

@export_group("Names")

enum UpgradeType {
	FASTER_UPLOAD,
	BETTER_ANTIVIRUS,
	SPAM_ORGNIZER
}

var upgrade_type: UpgradeType

func _ready() -> void:
	connect("pressed", pressed)
	# Get the values inside the enum as an array and then pick a random type to assign
	upgrade_type = UpgradeType.values().pick_random()

func pressed() -> void:
	print(text)
# end Psuedo Pakman
