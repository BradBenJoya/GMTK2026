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
	pressed.connect(_on_pressed)
	# Pick a random upgrade type safely
	upgrade_type = [UpgradeType.FASTER_UPLOAD, UpgradeType.BETTER_ANTIVIRUS, UpgradeType.SPAM_ORGNIZER].pick_random() as UpgradeType

	match upgrade_type:
		UpgradeType.FASTER_UPLOAD:
			if upgrade_name:
				upgrade_name.text = faster_upload_name
			if upgrade_description:
				upgrade_description.text = faster_upload_description
			
		UpgradeType.BETTER_ANTIVIRUS:
			if upgrade_name:
				upgrade_name.text = better_antivirus_name
			if upgrade_description:
				upgrade_description.text = better_antivirus_description
			
		UpgradeType.SPAM_ORGNIZER:
			if upgrade_name:
				upgrade_name.text = spam_orgnizer_name
			if upgrade_description:
				upgrade_description.text = spam_orgnizer_description


func _on_pressed() -> void:
	# Apply upgrade effect
	match upgrade_type:
		UpgradeType.FASTER_UPLOAD:
			if Global.manager:
				Global.manager.minimum_speed = max(0.05, Global.manager.minimum_speed * 0.8)
		UpgradeType.BETTER_ANTIVIRUS:
			pass
		UpgradeType.SPAM_ORGNIZER:
			pass
	queue_free()
# end Psuedo Pakman
