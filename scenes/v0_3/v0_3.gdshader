shader_type spatial;

render_mode unshaded, skip_vertex_transform;

const vec3 world_light_direction = normalize(vec3(1.0, -1.0, -1.0));

vec3 force_srgb(vec3 linear_color) {
	return mix(pow((linear_color + vec3(0.055)) * (1.0 / (1.0 + 0.055)),vec3(2.4)),linear_color * (1.0 / 12.92),lessThan(linear_color,vec3(0.04045)));
}

varying flat vec3 light_direction;

void vertex() {
	vec4 model_vertex_position = vec4(VERTEX, 1.0);
	NORMAL = normalize(MODELVIEW_NORMAL_MATRIX * NORMAL);
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
	
	vec3 sample = vec3(0.5, 1.0, 0.5);
	
	float similarity = (dot(-light_direction, normal) + 1.0) / 2.0;
	vec3 color = mix(vec3(0.0, 1.0, 0.0), vec3(0.0, 0.0, 1.0), similarity);
	ALBEDO = force_srgb(color);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
