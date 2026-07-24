# start Psuedo Pakman
extends Button
class_name BaseUpgrade

@export_group("Display")
@export var display_name: String:
	set(name):
		print("set naem")
		display_name = name
		$UpgradeName.text = display_name
@export var display_desc: String:
	set(desc):
		print("set desc")
		display_desc = desc
		$UpgradeDescription.text = display_desc
@export var display_image: Texture
	#set(image):
		#$UpgradeName.text = display_image
		#display_name = name
#@export var display_upgrade: float

@export var upgrade_list: Array[UpgradeItem]

enum UpgradeType {
	UPLOAD_SPEED,
	VIRUS_CHANCE,
	SPAM_CHANCE
}

func _ready() -> void:
	connect("pressed", pressed)
	# Pick a random upgrade from predefined list.
	var random_upgrade = upgrade_list.pick_random()
	print("picking random upgrade:" + str(random_upgrade))
	
	display_name = random_upgrade.name
	display_desc = random_upgrade.desc
	
	if random_upgrade != null:
		display_image = random_upgrade.image
	for effect in random_upgrade.effects:
		print("doing a effect")
		match effect:
			UpgradeType.UPLOAD_SPEED:
				display_desc += "\nUpload speed "
			UpgradeType.VIRUS_CHANCE:
				display_desc += "\nVirus chance "
			UpgradeType.SPAM_CHANCE:
				display_desc += "\nSpam chance "
		if random_upgrade.effects[effect] > 0:
			display_desc += " + "
		display_desc += str(int(random_upgrade.effects[effect]))


func pressed() -> void:
	pass
# end Psuedo Pakman
