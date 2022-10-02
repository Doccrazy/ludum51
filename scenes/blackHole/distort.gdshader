shader_type canvas_item;

uniform sampler2D curve;
uniform float strength : hint_range(-1.0, 1.0) = 0.5;
uniform float strengthMult : hint_range(0, 1.0) = 1;
uniform float aberration: hint_range(0.0, 1.0, 0.001) = 0.425;
uniform sampler2D centerCurve;

void fragment() {
	vec2 vecToCenter = vec2(0.5, 0.5) - UV;
	float distToCenter = length(vecToCenter);
	float curveVal = texture(curve, vec2(distToCenter)).r * strengthMult;
	float centerCurveVal = texture(centerCurve, vec2(distToCenter)).r * strengthMult;
	vec2 diff = normalize(vecToCenter) * strength * curveVal;
	vec2 abber_vec = diff*aberration;
	
	vec4 red = texture(SCREEN_TEXTURE, SCREEN_UV - diff + abber_vec);
	vec4 blue = texture(SCREEN_TEXTURE, SCREEN_UV - diff - abber_vec);
	vec4 ori = texture(SCREEN_TEXTURE, SCREEN_UV - diff);
	
	COLOR = vec4(clamp(red.r + centerCurveVal, 0, 1), clamp(ori.g + centerCurveVal, 0, 1), clamp(blue.b + centerCurveVal, 0, 1), 1.0);
}
