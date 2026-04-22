shader_type spatial;

render_mode unshaded;

// The `source_color` hint on the sampler
// tells Godot that the texture contains sRGB color
// data. It will automatically convert it to linear
// space for approprite sampling and shader calculations.
// https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/shading_language.html#using-source-color
uniform sampler2D plane_texture : source_color;
uniform vec2 uv_scale;

void vertex() {
	UV = UV * uv_scale;
}

vec3 srgb_to_linear(vec3 srgb_color) {
	vec3 above = pow((srgb_color + vec3(0.055)) / vec3(1.055), vec3(2.4));
	vec3 below = srgb_color / vec3(12.92);
	return mix(above, below, lessThanEqual(srgb_color, vec3(0.04045)));
}

vec3 linear_to_srgb(vec3 linear_color) {
	vec3 above = (vec3(1.055) * pow(linear_color, vec3(1.0 / 2.4))) - vec3(0.055);
	vec3 below = vec3(12.92) * linear_color;
	return mix(above, below, lessThanEqual(linear_color, vec3(0.0031308)));
}

void fragment() {
	vec3 sample = texture(plane_texture, UV).rgb;
	// The sampled color is in linear space and Godot, renders in
	// linear color space.
	ALBEDO = sample;
	// In case you would like to experiment with incorrect values.
	//ALBEDO = linear_to_srgb(sample);
	//ALBEDO = srgb_to_linear(sample);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
