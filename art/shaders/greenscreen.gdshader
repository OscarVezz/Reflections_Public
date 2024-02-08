shader_type canvas_item;


uniform sampler2D texture2: repeat_enable;
uniform vec2 scroll1 = vec2(0.1, 0.1);
uniform vec2 scroll2 = vec2(0.1, 0.1);
uniform sampler2D colorTexture;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec4 screenColor = texture(screen_texture, SCREEN_UV);
	
	float textureColor1 = texture(TEXTURE, UV + scroll1 * TIME).r;
	float textureColor2 = texture(texture2, UV + scroll2 * TIME).r;
	float blend = textureColor1 * textureColor2;
	vec4 finalColor = texture(colorTexture, vec2(blend));
	
	
	if (screenColor.g < 0.95){
		finalColor.a = 0.0;
	} else {
		if (screenColor.b > 0.5){
			finalColor.a = 0.0;
		}
	}
	COLOR = finalColor;
}
