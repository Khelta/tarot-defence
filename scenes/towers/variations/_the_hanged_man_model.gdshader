shader_type spatial;

uniform sampler2D albedo_texture : source_color;
uniform float desaturate : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec4 tex = texture(albedo_texture, UV);

    float grey = dot(tex.rgb, vec3(0.299, 0.587, 0.114));
    ALBEDO = mix(tex.rgb, vec3(grey), desaturate);
}