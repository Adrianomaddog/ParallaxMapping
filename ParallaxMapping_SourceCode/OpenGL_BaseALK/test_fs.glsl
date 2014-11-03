#version 400




uniform mat4 view, proj;
uniform vec3 luz_pos;
uniform vec3 LA, LD, KD, KA, KS, LS;

in vec3 colour;

in vec3 V_N;

//vec3 LD = vec3(1.0,1.0,1.0);
//vec3 KD = vec3(1.0, 0.0, 0.0);
//vec3 KA = vec3(0.0,1.0,0.0);
//vec3 LA = vec3(1.0,1.0,1.0);

//vec4 luz_pos = vec4(1.0, -1.0, 0.0, 1.0);
//vec3 luz_dir = vec3(1.0,0.0,1.0);
//vec3 LS = vec3(1.0,1.0,1.0);
//vec3 KS = vec3(0.0,0.0,1.0);
float shinnes = 50.0;
vec3 r = vec3(0.75,0.0,1.0);

out vec4 frag_colour;



void main() 
 {
	
	//r = 2 * dot(V_N,luz_pos)*V_N -1;
		
	vec3 colourf =  KD * LD *  dot( luz_pos, V_N) /*+ KS * LS * pow(dot(r,luz_pos),shinnes)*/ +  KA * LA;
	//vec3 difusa = KD * LD * dot( luz_pos, V_N);
	//vec3 ambiente = KA * LA;
	//vec3 colourf = ambiente + difusa; 
	frag_colour = vec4 (colourf, 1.0);

 }
