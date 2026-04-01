shader_type spatial;

render_mode unshaded;

uniform sampler2D plane_texture;
uniform vec2 uv_scale;

void vertex() {
	UV = UV * uv_scale;
}

void fragment() {
	vec3 sample = texture(plane_texture, UV).rgb;
	// force SRGB color
	ALBEDO = mix(pow((sample + vec3(0.055)) * (1.0 / (1.0 + 0.055)),vec3(2.4)),sample * (1.0 / 12.92),lessThan(sample,vec3(0.04045)));
	//ALBEDO = texture(plane_texture, UV).rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
