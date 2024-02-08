extends SubViewport

func _ready():
	await RenderingServer.frame_post_draw;
	
	var image = get_viewport().get_texture().get_data();
	image.convert(Image.FORMAT_RGBA8);		# For PNG only 
	image.flip_y();
	image.save_png("screenshot.png");
