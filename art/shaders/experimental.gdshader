shader_type canvas_item;


uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);
	vec4 screenColor = texture(screen_texture, SCREEN_UV);
	
	if (screenColor.b > 0.99 && screenColor.r < 0.9){
		COLOR = pixelColor;
	} else {
		COLOR.a = 0.0;
	}
}