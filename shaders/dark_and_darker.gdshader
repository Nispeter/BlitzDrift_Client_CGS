shader_type spatial;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform sampler2D palette_texture : source_color;
uniform int pixel_size = 4;
uniform float palette_size = 6.0;

vec3 to_linear(vec3 color) {
    return pow(color, vec3(1.8));  // Adjust gamma curve (lower than 2.2)
}

// Convert linear to sRGB space (optional, but keeping it softer)
vec3 to_srgb(vec3 color) {
    return pow(color, vec3(1.0 / 1.8));  // Adjust gamma back
}

void fragment() {
    // Pixelation effect
    float x = FRAGCOORD.x + floor(float(pixel_size) / 2.0) - float(int(FRAGCOORD.x) % pixel_size);
    float y = FRAGCOORD.y + floor(float(pixel_size) / 2.0) - float(int(FRAGCOORD.y) % pixel_size);

    vec3 color = texture(screen_texture, vec2(x, y) / VIEWPORT_SIZE).rgb;
    vec3 linear_color = to_linear(color);

    float brightness = dot(linear_color, vec3(0.299, 0.587, 0.114));

    int palette_index = int(clamp(brightness * palette_size, 0.0, palette_size - 1.0));
    float uv_x =  1.0 - (float(palette_index) + 0.5) / palette_size;

    vec3 palette_color = texture(palette_texture, vec2(uv_x, 0.5)).rgb;
    ALBEDO = palette_color;
}
