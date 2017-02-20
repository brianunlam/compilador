#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <float.h>

/* declaraciones para generacion de assembler */

char linea[50];
int topePilaAsm = 0;
char strPila[1000][50];
char strOpe[50];
char strConc[50];
FILE *ArchivoAsm;

void desapilarOperando();
void apilarOperando(char *strOp);
void imprimirHeader(FILE *p);
void imprimirVariables(FILE *p);
void generarASIG();
void generarAsm();

/***************************************************
funcion que saca de la pila asm un operando
***************************************************/
void desapilarOperando(){
	int b=0;
	if(strcmp(strConc,"concatenacion")!=0){
    	topePilaAsm--;
    	if(topePilaAsm<0){
    	topePilaAsm=0;
    	strcpy(strOpe,"nada");
    	b=1;
//    	bandera=1;
    	}
    }
    if(b!=1){
      strcpy(strOpe,strPila[topePilaAsm]);
	  strcpy(strPila[topePilaAsm],"");
    }


}

/***************************************************
funcion que guarda en la pila un operando
***************************************************/
void apilarOperando(char *strOp){
    printf("Apilando %s \n", strOp);
    strcpy(strPila[topePilaAsm],strOp);
    topePilaAsm++;
}



FILE *ArchivoPolaca;

void imprimirHeader(FILE *p){
    fprintf(p,".MODEL LARGE\n.386\n.STACK 200h\n\n.DATA\n\tMAXTEXTSIZE equ 50\n ");
    fprintf(p,"\t__result dd ? \n" );
    fprintf(p,"\t__flags dw ? \n" );
    fprintf(p,"\t__descar dd ? \n" );
    fprintf(p,"\t__auxConc db MAXTEXTSIZE dup (?), '$'\n" );
    fprintf(p,"\t__resultConc db MAXTEXTSIZE dup (?), '$'\n" );
    fprintf(p,"\tmsgPRESIONE db 0DH, 0AH,'Presione una tecla para continuar...','$'\n");
    fprintf(p,"\t_newLine db 0Dh, 0Ah,'$'\n" );
    fprintf (ArchivoAsm,"vtext db 100 dup('$')\n ");
}

 void imprimirVariables(FILE *p){  //aca tengo que leer la tabla de simbolos, para los float es fácil
                                  //para las cadenas no
    fprintf(p, "\n;Declaracion de variables de usuario\n");
    fprintf(p, "\t@%s\tdd\t?\n", "a");
    fprintf(p, "\t_%s\tdd\t%s\n", "10","10.0");
    fprintf(p, "\t@%s\tdd\t?\n", "b");
    fprintf(p, "\t_%s\tdd\t%s\n", "20","20.0");
}

void generarASIG(){
    // a := b
    char aux[50];
    char aux1[50];
    char strCadena[50];
    int i;
    int a = 0;
    //desapilo, y busco en ts, guardo valor en aux y aux1

    // a:= 1
    // a:= b /b float
    // a:= b /b cadena
    // a:= "cadena"

}




void generarAsm(){

if ((ArchivoPolaca = fopen("intermedia.txt", "rt")) == NULL){
    printf("ERROR!!!\nNo se Puede Abrir El Archivo intermedia.txt \n");
    getch();
	exit(0);
}

if ((ArchivoAsm = fopen("Final.asm", "wt")) == NULL){
	printf("ERROR!!!\nNo se Puede Abrir El Archivo Final.asm \n");
	getch();
	exit(0);}



    printf("\n\n..... Generando codigo Assembler ....\n\n");

    imprimirHeader(ArchivoAsm);
    imprimirVariables(ArchivoAsm);



while(fgets(linea,sizeof(linea),ArchivoPolaca)!=NULL){
    if( strcmp(linea,"+\n") == 0 )
        ;//generarADD();
      else
        if( strcmp(linea,"*\n") == 0 )
        ;  //generarMUL();
        else
          if( strcmp(linea,"-\n") == 0 )

        ;//    generarREST();
          else

            if( strcmp(linea,"/\n") == 0 )
        ;//      generarDIV();
            else
              if( strcmp(linea,"++\n") == 0 )
        ;//        generarCONC();
              else
                if( strcmp(linea,":=\n") == 0 )
        ;          generarASIG();
                else
                  if( strcmp(linea,"WRITE\n") == 0 )
        ;//            generarWRITE();
                  else
                    if(strcmp(linea,"READ\n") == 0)
        ;//              generarREAD();
                    else
                    	if( strcmp(linea,"==\n") == 0
    		                  || strcmp(linea,"<\n") == 0
    		                  || strcmp(linea,"<=\n") == 0
    		                  || strcmp(linea,">\n") == 0
    		                  || strcmp(linea,">=\n") == 0
    		                  || strcmp(linea,"!=\n") == 0 ) //comparacion
    		;                //    generarCMP(linea); //funcion que genera el codigo asm para los comparadores

    		                  else
    		                    if( strcmp(linea,"BF\n") == 0 || strcmp(linea,"BV\n") == 0 || strcmp(linea,"BI\n") == 0)
    		 ;                 //    generarSalto(linea);

    		                    else
    		                      if(strchr(linea, ':') && linea[0]!='_')
    		  ;                  //    ponerEtiqueta(linea);
    		                      else
    		                        apilarOperando(linea);


}


}

int main(){
    generarAsm();
}
