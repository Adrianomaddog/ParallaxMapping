#version 400

// inputs: texture coordinates, and view and light directions in tangent space
in vec2 st;
in vec3 view_dir_tan;
in vec3 light_dir_tan;


// the normal map texture
uniform sampler2D basic_texture;
uniform sampler2D normal_texture;
uniform sampler2D height_texture;

// output colour
out vec4 frag_colour;
//vec2 parallaxBias = vec2();
in vec4 test_tan;

void main() {
	vec3 Ia = vec3 (0.5, 0.5, 0.5);
	float height = texture(height_texture, st).r;  /*texture(height_texture, st).g ;*/
	//float b = 0.01* -0.5;
	//float hsb = height * s + b;
	
	//height = normalize(height);
	float h = -height * 0.04 + 0.02;
	//v = normalize(v);
	


	//float height = texture(height_texture, st).r;
	vec3 eye = normalize(view_dir_tan);
	vec2 newCoords = st + (eye.xy * h);  

	// sample the normal map and covert from 0:1 range to -1:1 range
	vec3 normal_tan = texture (normal_texture, newCoords).rgb;
	normal_tan = normalize ((normal_tan) * 2.0 - 1.0);

	

	// diffuse light equation done in tangent space
	vec3 direction_to_light_tan = normalize (-light_dir_tan);
	float dot_prod = dot (direction_to_light_tan, normal_tan);
	dot_prod = max (dot_prod, 0.0);
	vec3 Id = vec3 (0.7, 0.7, 0.7) * vec3 (0.5, 0.5, 0.5) * dot_prod;

	// specular light equation done in tangent space
	vec3 reflection_tan = reflect (normalize (light_dir_tan), normal_tan);
	float dot_prod_specular = dot (reflection_tan, normalize (view_dir_tan));
	dot_prod_specular = max (dot_prod_specular, 0.0);
	float specular_factor = pow (dot_prod_specular, 500.0);
	vec3 Is = vec3 (1.0, 1.0, 1.0) * vec3 (0.5, 0.5, 0.5) * specular_factor;


	vec4 colortex = texture(basic_texture,newCoords);
	//vec4 color2 = texture(colortex,newCoords);

	// phong light output
	vec3 luz = Is + Id + Ia;
	vec4 c =vec4(luz,1.0) * colortex;
	frag_colour.rgba = c;
	//frag_colour.a = 1.0;
}
