shader_type spatial;

render_mode unshaded, skip_vertex_transform;

const vec3 world_light_direction = normalize(vec3(1.0, -1.0, -1.0));

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

// flat means not to interpolate the value for the fragment shader
varying flat vec3 light_direction;

void vertex() {
	vec4 model_vertex_position = vec4(VERTEX, 1.0);
	NORMAL = MODELVIEW_NORMAL_MATRIX * NORMAL;
	VERTEX = (PROJECTION_MATRIX * MODELVIEW_MATRIX * model_vertex_position).xyz;
	// skip_vertex_transform disables Model and View transformations for a vertex, but
	// by setting POSITION ourselves even projection is disabled.
	// This is not necessary, but as a learning experience it is helpful to see the whole transformation
	// pipeline applied to each vertex, without it being obfuscated by some internal behavior.
	POSITION = PROJECTION_MATRIX * MODELVIEW_MATRIX * model_vertex_position;
	// The light direction only needs to transformed by the View matrix and since it it only a direction
	// only rotation is applied to it.
	light_direction = normalize((VIEW_MATRIX * vec4(world_light_direction, 0.0)).xyz);
}

void fragment() {
	vec3 normal = normalize(NORMAL);
	
	float similarity = (dot(-light_direction, normal) + 1.0) / 2.0;
	vec3 color = mix(vec3(0.0, 1.0, 0.0), vec3(0.0, 0.0, 1.0), similarity);
	// We are using linear values to define the green and blue colors and Godot
	// renders using linear color space, so no transformation is needed.
	ALBEDO = color;
	// In case you would like to experiment with incorrect values.
	//ALBEDO = linear_to_srgb(color);
	//ALBEDO = srgb_to_linear(color);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
