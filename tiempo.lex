%{
    #include <stdio.h>
    #include<string.h>
	#include <ctype.h>
	#include <stdbool.h>
	
    int n_movimiento = 0;
    char ciudadActual[256];
    char TemperaturaA[256];
	char tiempoAct[256];
	char provinciaAct[256];
    char precipitacionProbAct[256];
	char vientoAct[256];
	
    void formatea(char *array){
      size_t tam = strlen(array);
        for(int i = 0; i<tam; i++){
          while(array[i] == 39 || ispunct(array[i])){
            memmove(&array[i], &array[i + 1], tam - i);
          }
        }
    }
	
	void quita_substring(char *substring, char *array){
		size_t tam = strlen(array);
		size_t tam_substring = strlen(substring);
		bool continua = true;
		
		for(int i = 0; i<tam && continua; i++){
			if(array[i] == ':')
				continua = false;
			for(int j = 0; j<tam_substring; j++){
				if(array[i] == substring[j]){
				memmove(&array[i], &array[i + 1], tam - i);
			  }
			}
          
        }
	}
%}

letra [a-zA-Z]
digito [0-9]
numero {digito}*
simboloT [ºC]
medidaViento [km/h]
Ciudad ("'niv4':")+"'"+({letra}+" "*)+"'"
Provincia ("'province':")+"'"+({letra}+" "*)+"'"
TemperaturaActual ("'currentTemperature':")+"'"+{numero}+{simboloT}+"'"
TiempoActual ("'weatherForecast':")+"'"+({letra}+" "*)+"'"
ProbPrecipitacionActual ("'precipitationProbability':")+"'"+{numero}+"'"
VientoActual ("'windSpeed':")+"'"+{numero}+" "*{medidaViento}+"'"

%%
{Ciudad} {
			n_movimiento++;
			//fprintf(yyout,"Ciudad %s\n",yytext);
			strcpy(ciudadActual, yytext);
			quita_substring("niv4",ciudadActual);
            formatea(ciudadActual);
			ciudadActual[0] = toupper(ciudadActual[0]);
			}
{Provincia} {
			strcpy(provinciaAct, yytext);
			quita_substring("province",provinciaAct);
            formatea(provinciaAct);
			provinciaAct[0] = toupper(provinciaAct[0]);
			}
{TemperaturaActual} {
                      strcpy(TemperaturaA, yytext);
					  quita_substring("currentTemperature",TemperaturaA);
                      formatea(TemperaturaA); 
                    }
{ProbPrecipitacionActual} {
						  strcpy(precipitacionProbAct, yytext);
						  quita_substring("precipitationProbability",precipitacionProbAct);
						  formatea(precipitacionProbAct); 
						}					
{TiempoActual} {
				  strcpy(tiempoAct, yytext);
				  quita_substring("weatherForecast",tiempoAct);
				  formatea(tiempoAct);
				}
{VientoActual} {
				  strcpy(vientoAct, yytext);
				  quita_substring("windSpeed",vientoAct);
				  formatea(vientoAct);
				}

%%

int yywrap(){
    //printf ("Hay %d movimiento validos\n", n_movimiento);
	printf("Informacion obtenida de la web: \n");
    printf ("\tCiudad: %s\n",ciudadActual);
	printf ("\tProvincia: %s\n",provinciaAct);
    printf ("\tTemperatura: %s\n",TemperaturaA);
	printf ("\tProbabilidad de lluvia actual: %s %% \n",precipitacionProbAct);
	
	printf ("\tTiempo: ");
	if(strcmp(tiempoAct, "Clear") == 0)
		printf ("Despejado\n");
	if(strcmp(tiempoAct, "Mostly clear") == 0)
		printf ("Poco nuboso\n");
	if(strcmp(tiempoAct, "Partly cloudy") == 0)
		printf ("Intervalos nubosos\n");
	
	if(strcmp(tiempoAct, "Overcast") == 0){
		int prob = atoi(precipitacionProbAct);
		if(prob<80)
			printf ("Cubierto\n");
		if(prob>= 80 && prob<90)
			printf ("Cubierto, llovizna\n");
		if(prob>= 90)
			printf ("Cubierto, lluvia\n");
	}
	
	printf ("\tViento: %s\n",vientoAct);
    return 1;
}

int main(){
  //memset(map, 0, sizeof(map));
  //yyin=fopen("testin.c","r");
  yyout=fopen("testout.txt","w");
  //yylex();
  //return 0;
  yylex();
  return 1;
}