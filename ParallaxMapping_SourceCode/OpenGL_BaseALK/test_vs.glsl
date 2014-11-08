#version 400

layout(location = 0) in vec3 vertex_position;
layout(location = 1) in vec3 vertex_normal;
layout(location = 2) in vec2 texture_coord;


uniform mat4 view, proj;


//out vec3 normal;
out vec3 V_N;
out vec2 st;
out vec3 V_P;


void main() {

	V_P = vertex_position;
	V_N = vertex_normal;
	st = texture_coord;
	gl_Position = proj * view * vec4 (vertex_position, 1.0) ;
}
