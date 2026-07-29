shader_type spatial;
render_mode blend_mix, depth_draw_opaque;

uniform vec4 glow_color : source_color = vec4(0.2, 1.0, 0.2, 1.0);
uniform float intensity = 5.0;

void fragment() {
    float fresnel = pow(1.0 - dot(NORMAL, VIEW), 4.0);

    ALBEDO = vec3(0.0);
    ALPHA = fresnel * 0.6;

    EMISSION = glow_color.rgb * fresnel * intensity;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
