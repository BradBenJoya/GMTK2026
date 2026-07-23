extends Button

func pressed() -> void:
	print(self.text)

func _ready() -> void:
	connect("pressed", pressed)
