#version 400

uniform mat4 view, proj;
uniform vec3 luz_pos;
uniform vec3 LA; 
uniform vec3 LD;
uniform vec3 KD;
uniform vec3 KA;
uniform vec3 KS;
uniform vec3 LS;

uniform sampler2D basic_texture;
uniform sampler2D second_texture;

vec3 colour2; 
in vec2 st;
in vec3 V_N;

//vec3 LD = vec3(1.0,1.0,1.0);
//vec3 KD = vec3(1.0, 0.0, 0.0);
//vec3 KA = vec3(0.0,1.0,0.0);
//vec3 LA = vec3(1.0,1.0,1.0);

//vec4 luz_pos = vec4(1.0, -1.0, 0.0, 1.0);
//vec3 luz_dir = vec3(1.0,0.0,1.0);
//vec3 LS = vec3(1.0,1.0,1.0);
//vec3 KS = vec3(0.0,0.0,1.0);
float shinnes = 200.0;
vec3 r ;//= vec3(0.75,0.0,1.0);
vec3 luz_dir = vec3 (0.0,0.0,-1.0);
out vec4 frag_colour;



void main() 
 {


	//vec4 texel_a = texture (basic_texture, st);
	vec4 texel_b = texture (second_texture, st);
	
	//r = 2 * dot(V_N,luz_pos)*V_N -1;
	//vec3 V_N = normalize(V_N);
	vec3 luz_pos2 = normalize(luz_pos);
	vec3 V_N2 = normalize(V_N);
		r = normalize(reflect(luz_dir, V_N2));

	//vec3 colourf =  KD * LD *  dot( luz_pos, V_N) + KS * LS * pow(dot(r,luz_pos),shinnes) +  KA * LA;
	
	vec3 ambiente = KA * LA;
	vec3 difusa = KD * LD * dot( luz_pos, V_N);
	//vec3 diff = clamp(difusa, 0.0,1.0);

	vec3 specular =  KS * LS * pow(max(dot(r,luz_pos),0.0),shinnes);
	vec3 spec = clamp(specular, 0.0, 1.0);
	vec3 colour2 = vec3(texel_b);
	vec3 colourf = colour2 * (ambiente + difusa + spec); 

	frag_colour = vec4 (colourf, 1.0);


/*
	vec4 texel_a = texture (basic_texture, texture_coordinates);
	vec4 texel_b = texture (second_texture, texture_coordinates);
	frag_colour = mix (texel_a, texel_b, texture_coordinates.s);
*/
 }
