# start Psuedo Pakman
extends Button
class_name BaseUpgrade

@export_group("Names")
@export_subgroup("Faster Upload")
@export var faster_upload_name: String
@export var faster_upload_description: String

@export_subgroup("Better Antivirus")
@export var better_antivirus_name: String
@export var better_antivirus_description: String

@export_subgroup("Spam Orgnizer")
@export var spam_orgnizer_name: String
@export var spam_orgnizer_description: String

@export_group("Labels")
@export var upgrade_name: Label
@export var upgrade_description: Label

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

	match upgrade_type:
		UpgradeType.FASTER_UPLOAD:
			upgrade_name.text = faster_upload_name
			upgrade_description.text = faster_upload_description
			
		UpgradeType.BETTER_ANTIVIRUS:
			upgrade_name.text = better_antivirus_name
			upgrade_description.text = better_antivirus_description
			
		UpgradeType.SPAM_ORGNIZER:
			upgrade_name.text = spam_orgnizer_name
			upgrade_description.text = spam_orgnizer_description

func pressed() -> void:
	print(text)
# end Psuedo Pakman
