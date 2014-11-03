// By Adriano L. Kerber
#include <gl\GL.h>
#include <iostream>

using namespace std;

// Cópia do windef.h
#ifndef max
#define max(a,b)            (((a) > (b)) ? (a) : (b))
#endif

#ifndef min
#define min(a,b)            (((a) < (b)) ? (a) : (b))
#endif
//

// Informações da luz:
static GLfloat Ia = 1.0f; // Luz ambiente;
static GLfloat Id = 1.0f; // Luz difusa;
static GLfloat light_pos[3] = {0.25f,1.0f,0.0f};

static GLfloat view_pos[3]  = {0.0f,0.0f,-4.5f};
static GLfloat amb_color[3] = {0.8f,0.8f,0.8f};
static GLfloat dif_color[3] = {1.0f,1.0f,1.0f};
static GLfloat obj_color[3] = {0.0f,0.0f,1.0f};
static int vertexRender = 0;
//static RandomColor Cor = RandomColor();
// Informações do material (.mtl)
static float Ka = .5f;
static float Kd = .5f;
static float Ks = .5f;

static int nShiny = 1;

//
//Extra:
float intensidadePL = 0.5; // Intensidade do ponto de luz;
//

void normalize(GLfloat *a) {
    GLfloat d=sqrt(a[0]*a[0]+a[1]*a[1]+a[2]*a[2]);
    a[0]/=d; a[1]/=d; a[2]/=d;
}

float calcMagnitude(GLfloat *vetor) {
	float magnitude = sqrt(pow(vetor[0],2) + pow(vetor[1],2) + pow(vetor[2],2));
	return magnitude;
}

float dotProduct(GLfloat *vetor1, GLfloat *vetor2) {
	float mag_vetor1 = calcMagnitude(vetor1);
    float mag_vetor2 = calcMagnitude(vetor2);

	float angulo = (vetor1[0]*vetor2[0] + vetor1[1]*vetor2[1] + vetor1[2]*vetor2[2])/(mag_vetor1*mag_vetor2);

	return angulo;
}

float calcFatt(float distancia){ // Cálculo do fator de atenuação da fonte de luz;
	return (1/(distancia*distancia));
}

float calcReflexaoDifusa(float intensidadeLuzAmbiente, float coeficienteReflexao, float corCanal, float fAtt, float intensidadePonto, float coeficienteReflexaoDifusa, float corDifusaCanal, float produtoEscalarNeL){
	return (intensidadeLuzAmbiente * coeficienteReflexao * corCanal + fAtt * intensidadePonto * coeficienteReflexaoDifusa * corDifusaCanal * produtoEscalarNeL);
}

void calcColor(GLfloat *vetn, GLfloat x, GLfloat y, GLfloat z){
	float r,g,b;
	//Passos para o cálculo de iluminação:
	//1) cor do objeto
	//2) ka = [0, 1]
	//3) Se vertices está iluminado (menos de 90 graus)
	//4) kd = [0, 1]
	//5) atenuação atmosférica (cálculo de dist.)
	//6) Se vertice está iluminado (menos de 90 graus). 
	//7) shininess, quanto maior, menor a região e mais intensa
	//8) soma tudo!

	// aqui vai a resolução da equação conforme visto em aula.
	
	float s[3] = {light_pos[0]-x, light_pos[1]-y, light_pos[2]-z}; // Vetor que vai do ponto até a posição da luz;
	float d = calcMagnitude(s);
	float ad = dotProduct(s, vetn);
	
	// Cálculo de atenuação da fonte de luz:
	float Fatt = calcFatt(d);//float Fatt = 1/(d*d);

	// Cálculo de intensidade intrínseca:
	//float I;
	//float I = Ia * Ka * obj_color[0] + Fatt * intensidadePL * Kd * dif_color[0] * ad;
	r = calcReflexaoDifusa(Ia, Ka, obj_color[0], Fatt, intensidadePL, Kd, dif_color[0], ad); // Backup para adição posterior da formula abaixo (atenuação atmosférica) >>> //I = calcReflexaoDifusa(Ia, Ka, obj_color[0], Fatt, intensidadePL, Kd, dif_color[0], ad); // Este cálculo deve ser chamado para cada cor;
	g = calcReflexaoDifusa(Ia, Ka, obj_color[1], Fatt, intensidadePL, Kd, dif_color[1], ad);
	b = calcReflexaoDifusa(Ia, Ka, obj_color[2], Fatt, intensidadePL, Kd, dif_color[2], ad);

	// Mantendo entre 0 e 1;
	r = max(0, min(1,r));
	g = max(0, min(1,g));
	b = max(0, min(1,b));
	
	//
	float Sb = 0.1, Sf = 1.0, Z0, Zb = 0.0, Zf = 1.0; // float Sb = 0.1, Sf = 1.0, Z0, Zb = 0.0, Zf = 1.0;
	float corFog = 0.25;

	// Normalização da coordenada Z:
	Z0 =  1 /(z-view_pos[2])*(z-view_pos[2]);
	if((Z0 < 0)||(Z0 > 1)){
		cout << "Z0: " << Z0 << " z: " << z << " Sb: " << Sb << endl;
	}

	// Cálculo S0:
	float S0 = Sb + ((Z0 - Zb) - (Sf - Sb)) / (Zf - Zb);

	// Cálculo de atenuação atmosférica:
	r = S0 * r + (1 - S0) * corFog; // I'Lambda = So * ILambda + (1-So) * IdcLambda;
	g = S0 * g + (1 - S0) * corFog;
	b = S0 * b + (1 - S0) * corFog;

	///

	r = max(0, min(1,r));
	g =  max(0, min(1,g));
	b = max(0, min(1,b));

	glColor3f(r,g,b);
}

void drawtri(GLfloat *a, GLfloat *b, GLfloat *c, int div, float r, GLfloat *trans_vet) {
	if (div<=0) {
		calcColor(a, a[0]*r+trans_vet[0], a[1]*r+trans_vet[1], a[2]*r+trans_vet[2]);
        	glNormal3fv(a); 
		glVertex3f( a[0]*r+trans_vet[0], a[1]*r+trans_vet[1], a[2]*r+trans_vet[2]);
		if (vertexRender) 
			calcColor(b, b[0]*r+trans_vet[0], b[1]*r+trans_vet[1], b[2]*r+trans_vet[2]);
	      glNormal3fv(b); glVertex3f( b[0]*r+trans_vet[0], b[1]*r+trans_vet[1], b[2]*r+trans_vet[2]);

		if (vertexRender) 
			calcColor(c, c[0]*r+trans_vet[0], c[1]*r+trans_vet[1], c[2]*r+trans_vet[2]);
	
		glNormal3fv(c); 
		glVertex3f( c[0]*r+trans_vet[0], c[1]*r+trans_vet[1], c[2]*r+trans_vet[2]);
      } else {
        GLfloat ab[3], ac[3], bc[3];
        for (int i=0;i<3;i++) {
            ab[i]=(a[i]+b[i])/2;
            ac[i]=(a[i]+c[i])/2;
            bc[i]=(b[i]+c[i])/2;
        }
        normalize(ab); normalize(ac); normalize(bc);
        drawtri(a, ab, ac, div-1, r,trans_vet);
        drawtri(b, bc, ab, div-1, r,trans_vet);
        drawtri(c, ac, bc, div-1, r,trans_vet);
        drawtri(ab, bc, ac, div-1, r,trans_vet); 
    }  
}