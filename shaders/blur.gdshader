shader_type canvas_item;

uniform mediump vec3 iResolution;
uniform mediump sampler2D iChannel0;
uniform mediump vec2 idirection;

vec4 blur13(sampler2D image, vec2 uv, vec2 resolution, vec2 direction) {
  mediump vec4 color = vec4(0.0);
  mediump vec2 off1 = vec2(1.3846153846) * direction;
  mediump vec2 off2 = vec2(3.2307692308) * direction;
  color += texture(image, uv) * 0.2270270270;
  color += texture(image, uv + (off1 / resolution)) * 0.3162162162;
  color += texture(image, uv - (off1 / resolution)) * 0.3162162162;
  color += texture(image, uv + (off2 / resolution)) * 0.0702702703;
  color += texture(image, uv - (off2 / resolution)) * 0.0702702703;
  return color;
}

void fragment() {
	COLOR = blur13(iChannel0, UV, iResolution.xy, idirection);
	
}


