shader_type canvas_item;

uniform float ring_width : hint_range(0.0, 1.0) = 0.1;
uniform float radius : hint_range(0.0, 1.0) = 0.5;
uniform vec4 color : source_color = vec4(1.0);

void fragment() {
    float dist = distance(UV, vec2(0.5));
    // Create ring based on distance from center
    float ring = smoothstep(radius - ring_width, radius - ring_width + 0.01, dist) * 
                 (1.0 - smoothstep(radius, radius + 0.01, dist));
    
    COLOR = vec4(color.rgb, ring * color.a);
}