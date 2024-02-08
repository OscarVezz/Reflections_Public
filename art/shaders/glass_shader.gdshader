shader_type spatial;
//render_mode unshaded;


uniform float distortion_size = 0.4;
uniform sampler2D distortion;

uniform float cutoff : hint_range(0.0, 1.1);
uniform sampler2D cutoff_mask;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;


void fragment() {
	//ALBEDO = texture(screen_texture, SCREEN_UV).rgb;
	vec2 d = texture(distortion, UV).xy - vec2(0.5);
	ALBEDO = texture(screen_texture, SCREEN_UV + d * distortion_size).rgb;
	//ALPHA = 0.5;
	
	float value = texture(cutoff_mask, UV).r;
	if (value < cutoff){
		ALPHA = 0.0;
	}
}