shader_type spatial;


uniform sampler2D depth_texture : hint_depth_texture, repeat_disable, filter_nearest;

void fragment() {
	float depth = texture(depth_texture, SCREEN_UV).x;
	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
	vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z;
	
	float scale = 0.0001;
	ALBEDO = vec3(0.0, 1.0, 0.0);
	if (linear_depth * scale < 0.1){
		ALPHA = 0.0;
	}
	//ALPHA = 0.0;
}