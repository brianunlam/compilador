#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <float.h>
int yylineno = 0; //esto en lo da flex en realidad, es el numero de línea del error
                    //acá se lo pongo para que el yyerror sea compatible con el nuestro

char yytext[100]; //lo mismo que lo de arriba

int yyerror(char *msg){
    fprintf(stderr, "At line %d %s in text: %s\n", yylineno, msg, yytext);
    //exit(1);
}

char tipos[20][40];
int contTipos = 0;

int insertarTipo(char tipo[]) {
    strcpy(tipos[contTipos],tipo);
    strcpy(tipos[contTipos+1],"null");
    contTipos++;
    return 0;
}

int resetTipos(){
    contTipos = 0;
    strcpy(tipos[contTipos],"null");
}

int compararTipos(char *a, char *b){
//    printf("Comparando %s y %s\n",a,b);
    if (strstr(a,b) != NULL){
        return 0;
    }
    if (strstr(b,a) != NULL){
        return 0;
    }
    return 1;
}



int validarTipos(char tipo[]) {
    char msg[100];
    int i ;
    for(i=0; i< contTipos; i++){
        if(compararTipos(tipo,tipos[i])!=0){
            sprintf(msg, "ERROR: Tipos incompatibles\n");
            yyerror(msg);
        }
    }
    resetTipos();
    return 0;

}



int main(){

    insertarTipo("cstring");
    insertarTipo("string");
    insertarTipo("string");
    validarTipos("cstring");


}
