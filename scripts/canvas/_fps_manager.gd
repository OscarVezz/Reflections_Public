extends ColorRect

@onready var _label: Label = $FPS_label;

func _process(_delta):
	_label.text = str(Engine.get_frames_per_second());
