#version 400

layout(location = 0) in vec3 vertex_position;
layout(location = 1) in vec3 vertex_colour;
layout(location = 2) in vec3 vertex_normals;


uniform mat4 view, proj;


out vec3 colour;
out vec3 V_N;


void main() {

	
	V_N = vertex_normals;
	colour = vertex_colour;
	gl_Position = proj * view * vec4 (vertex_position, 1.0) ;
}
