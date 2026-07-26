extends ColorRect

func _ready():
	var dark_screen_tween_out = create_tween().tween_property(self, "modulate:a", 0.0, 1.0).from(1.0)
