#version 400

// inputs: texture coordinates, and view and light directions in tangent space
in vec2 st;
in vec3 view_dir_tan;
in vec3 light_dir_tan;


// the normal map texture
uniform sampler2D basic_texture; //textura real
uniform sampler2D normal_texture; //textura normal (normal mapping)
uniform sampler2D height_texture; //textura de altura(height mapping)

// output colour
out vec4 frag_colour;
in vec4 test_tan;

void main() {
//luz ambiente
	vec3 Ia = vec3 (0.2, 0.2, 0.2);

//**********PARALLAX MAPPING*********************************************************
	//le o height map e gera a "altura" do relevo (height map é uma textura preto e branco, usa apenas 2 canais R e G)
	float height = texture(height_texture, st).r *  texture(height_texture, st).g;
	
	//fatores de scale e bias (o scale é metade do bias(valores definidos pro experimentação)) 
	float b = 0.06; //bias
	float s = b * -0.5; //scale
	float h = height * (s + b);
	
	//normaliza o vetor do observador no espaço de tangente
	vec3 eye = normalize(view_dir_tan);
	//inverte o eixo Y para corrigir o angulo de visualização
	eye.y = -eye.y;
	// gera novas coordenadas de do mapeamento de textura (de acordo com o vetor do observador)
	vec2 newCoords = st + (eye.xy * h);  
	
//*********************************************************************************	

//**********NORMAL MAP*******************************************************************
	//aplica o normal mapping usado as novas coordenadas de mapeamento geradas com o parallax mapping
	// sample the normal map and covert from 0:1 range to -1:1 range
	vec3 normal_tan = texture (normal_texture, newCoords).rgb;
	normal_tan = normalize ((normal_tan) * 2.0 - 1.0);

	

	// diffuse light equation done in tangent space
	vec3 direction_to_light_tan = normalize (-light_dir_tan);
	float dot_prod = dot (direction_to_light_tan, normal_tan);
	dot_prod = max (dot_prod, 0.0);
	vec3 Id = vec3 (1.0, 1.0, 1.0) * vec3 (0.7, 0.7, 0.7) * dot_prod;

	// specular light equation done in tangent space
	vec3 reflection_tan = reflect (normalize (light_dir_tan), normal_tan);
	float dot_prod_specular = dot (reflection_tan, normalize (view_dir_tan));
	dot_prod_specular = max (dot_prod_specular, 0.0);
	float specular_factor = pow (dot_prod_specular, 500.0);
	vec3 Is = vec3 (1.0, 1.0, 1.0) * vec3 (0.5, 0.5, 0.5) * specular_factor;

	//aplica a textura real com as coordenadas geradas usando parrallax mapping e normal mapping
	vec4 colortex = texture(basic_texture,newCoords);

	// phong light output
	vec3 luz = Is + Id + Ia;
	vec4 c =vec4(luz,1.0) * colortex;
	frag_colour.rgba = c;
}
