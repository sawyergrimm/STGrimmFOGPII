shader_type canvas_item;

uniform sampler2D screenTexture : hint_screen_texture, repeat_disable, filter_linear_mipmap;

uniform float blurLod : hint_range(0.0, 6.0) = 6.0;      // higher = blurrier
uniform float tapSpread : hint_range(0.0, 8.0) = 8.0;    // pixel offset of extra taps
uniform vec4 tint : source_color = vec4(0.0, 0.0, 0.0, 1.0); // rgb = tint colour, a = tint strength

void fragment() {
	vec2 px = SCREEN_PIXEL_SIZE * tapSpread * (blurLod + 1.0);

	vec3 c = textureLod(screenTexture, SCREEN_UV, blurLod).rgb * 4.0;
	c += textureLod(screenTexture, SCREEN_UV + vec2( px.x,  px.y), blurLod).rgb;
	c += textureLod(screenTexture, SCREEN_UV + vec2(-px.x,  px.y), blurLod).rgb;
	c += textureLod(screenTexture, SCREEN_UV + vec2( px.x, -px.y), blurLod).rgb;
	c += textureLod(screenTexture, SCREEN_UV + vec2(-px.x, -px.y), blurLod).rgb;
	c /= 8.0;

	c = mix(c, tint.rgb, tint.a);

	//Output
	COLOR = vec4(c, COLOR.a);
}
