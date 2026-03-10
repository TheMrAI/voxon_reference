shader_type spatial;
// Turn off the internal shader execution
// Also skip vertex transformations so we can do them manually, after
// accessing the vertex position.
render_mode unshaded, skip_vertex_transform;

const vec3 light_color = vec3(0.2, 1.0, 0.2);
const vec3 light_direction = normalize(vec3(1.0, -1.0, -1.0));
const vec3 light_position = vec3(-10.0, 10.0, 10.0);
const float limit = cos(10.0 * (PI / 180.0));
const float shininess = 100.0;

varying vec3 surface_to_light;
varying vec3 surface_to_view;

void vertex() {
	vec3 surface_world_posiiton = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	surface_to_light = light_position - surface_world_posiiton;
	surface_to_view = CAMERA_POSITION_WORLD - surface_world_posiiton;
	
	vec3 position_as_normal = normalize(VERTEX.xyz);
	
	VERTEX = (PROJECTION_MATRIX * VIEW_MATRIX * vec4(surface_world_posiiton, 1.0)).xyz;
	POSITION = PROJECTION_MATRIX * VIEW_MATRIX * vec4(surface_world_posiiton, 1.0);
    NORMAL = MODEL_NORMAL_MATRIX * position_as_normal;
}

void fragment() {
	vec3 normal = normalize(NORMAL);
	
	vec3 surface_to_light_direction = normalize(surface_to_light);
	vec3 surface_to_view_direction = normalize(surface_to_view);
	
	vec3 half_vector = normalize(surface_to_light_direction + surface_to_view_direction);
	
	float light = 0.0;
	float specular = 0.0;
	
	float dot_from_direction = dot(surface_to_light_direction, -light_direction);
	if (dot_from_direction > limit) {
		light = dot(normal, surface_to_light_direction);
		
		specular = dot(normal, half_vector);
		if (specular > 0.0) {
			specular = pow(specular, shininess);
		} else {
			specular = 0.0;
		}
	}

	ALBEDO = light_color * light + specular;
}
