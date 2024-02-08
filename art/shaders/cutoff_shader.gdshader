shader_type canvas_item;

uniform sampler2D mask_texture;

uniform float cutoff : hint_range(0.0, 1.1);
uniform sampler2D cutoff_mask;

void fragment() {
    vec4 colour = texture(TEXTURE, UV);
    colour.a *= texture(mask_texture, UV).a;
	
	float value = texture(cutoff_mask, UV).r;
//	value *= colour.a;
	if (value < cutoff){
		colour.a = 0.0;
	}
	
    COLOR = colour;
}