shader_type spatial;
render_mode unshaded;
render_mode cull_disabled;

uniform vec3 bottom_color : source_color = vec3(0.0, 1.0, 0.0);


void fragment() {
	float h = UV.y;
	float gradient = smoothstep(-0.5, 0.5, h);

    ALBEDO = bottom_color;
	ALPHA = 1.0 - gradient;
}
