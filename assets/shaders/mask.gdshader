shader_type canvas_item;

uniform vec2 rect_pos = vec2(0.28, 0.32);   // top-left corner (UV space 0-1)
uniform vec2 rect_size = vec2(0.44, 0.36);  // width/height in UV space
uniform vec4 mask_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    vec2 uv = UV;
    bool inside = uv.x > rect_pos.x &&
                  uv.x < rect_pos.x + rect_size.x &&
                  uv.y > rect_pos.y &&
                  uv.y < rect_pos.y + rect_size.y;

    COLOR = inside ? vec4(0.0) : mask_color;
}