extends Node


func _process(_delta):
	if (Utilities.is_action_just_pressed("left_mouse")):
		var image = get_viewport().get_texture().get_data();
		image.convert(Image.FORMAT_RGBA8);		# For PNG only 
		image.flip_y();
		image.save_png("screenshot.png");
