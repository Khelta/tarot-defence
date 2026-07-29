shader_type spatial;
render_mode unshaded, cull_disabled, blend_mix;

uniform vec4 red_color   : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 white_color : source_color = vec4(1.0, 0.8, 0.8, 1.0);

/* Ring radii – adjust as you like */
uniform float inner_radius        = 0.475;   // start of the inner red band
uniform float white_radius_inner  = 0.485;   // inner edge of the white ring
uniform float white_radius_outer  = 0.49;   // outer edge of the white ring
uniform float outer_radius        = 0.5;   // end of the outer red band

/* Width of the fade (transparent → opaque or opaque → transparent) */
uniform float softness = 0.02;

void fragment() {
    /* UV centred on (0,0) – distance from the centre of the sprite */
    vec2 uv   = UV - vec2(0.5);
    float d   = length(uv);
    vec4  col = vec4(0.0);
    float a   = 0.0;

    /* -------------------------------------------------------------
     * 1) Everything outside the outermost fade region is fully
     *    transparent (you could also `discard` here if you prefer).
     * ------------------------------------------------------------- */
    if (d > outer_radius + softness) {
        discard;               // saves a few cycles
    }

    /* -------------------------------------------------------------
     * 2) INNER RED – fades in from the centre up to `inner_radius`.
     * ------------------------------------------------------------- */
    if (d < inner_radius) {
        /* Inside the hole – completely transparent */
        a = 0.0;
    } else if (d < inner_radius + softness) {
        /* Fade‑in zone */
        a = smoothstep(inner_radius, inner_radius + softness, d);
    } else if (d < white_radius_inner) {
        /* Fully opaque inner‑red band */
        a = 1.0;
    }
    if (a > 0.0 && d < white_radius_inner) {
        col = red_color;
    }

    /* -------------------------------------------------------------
     * 3) WHITE RING – solid, no fade.
     * ------------------------------------------------------------- */
    if (d >= white_radius_inner && d < white_radius_outer) {
        col = white_color;
        a   = 1.0;
    }

    /* -------------------------------------------------------------
     * 4) OUTER RED – fades out at the outer edge.
     * ------------------------------------------------------------- */
    if (d >= white_radius_outer && d < outer_radius) {
        if (d > outer_radius - softness) {
            /* Fade‑out zone */
            a = smoothstep(outer_radius, outer_radius - softness, d);
        } else {
            /* Fully opaque outer‑red band */
            a = 1.0;
        }
        col = red_color;
    }

    /* -------------------------------------------------------------
     * 5) Anything not covered above stays fully transparent.
     * ------------------------------------------------------------- */
    ALBEDO = col.rgb;
    ALPHA  = a;
}