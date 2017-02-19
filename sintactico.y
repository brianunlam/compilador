%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <float.h>

extern int yylineno;
extern char *yytext;


/* funciones para polaca etc */

int contEtiqueta = 0;   //para generar etiq unicas
char Etiqueta[10];      //para generar etiq unicas
char EtiqDesa[10];
char pilaEtiquetas[150][10]; //guarda las etiquetas
int  topeEtiquetas = 0;
int  posPolaca = 0;
FILE *ArchivoPolaca;
char buffer[20];
char pilaPolaca[500][50];
int pilaWhile[150];
int topePilaWhile = 0;
void apilarWhile(int pos);

int desapilarWhile();

void apilarPolaca(char *strToken);
void insertarPolaca(char *s, int p);
void generarEtiqueta();
void apilarEtiqueta(char *strEtiq);
void desapilarEtiqueta();
void grabarPolaca();

/* fin de funciones para polaca etc */



/*funciones y estructuras para handle de tipos */

char tipos[20][40];
int contTipos = 0;

int insertarTipo(char tipo[]);
int resetTipos();
int compararTipos(char *a, char *b);
int validarTipos(char tipo[]) ;

/*fin de funciones y estructuras para handle de tipos */


/* funciones tabla de simbolos */

typedef struct symbol {
    char nombre[50];
    char tipo[10];
    char valor[100];
    char alias[50];
    int longitud;
    int limite;
} symbol;


symbol nullSymbol;
symbol symbolTable[1000];
int pos_st = 0;

// symbolo auxiliar
symbol auxSymbol;
symbol auxSymbol2;


// el valor ! representa al simbolo nulo.

// funciones imprimir html

void writeStyle(FILE *p){
    fprintf(p,"<style>\ntable {\nfont-family: arial, sans-serif;\nborder-collapse: collapse;\nwidth: 100%%;\n}\ntd, th {\nborder: 1px solid #dddddd;\ntext-align: left;\npadding: 8px;\n}\ntr:nth-child(even) {\nbackground-color: #dddddd;\n}\n</style>\n");
}


void writeTupla(FILE *p ,int filas,symbol symbolTable[]){
    int j;
    for(j=0; j < filas; j++ ){
        fprintf(p, "<tr>\n");
        fprintf(p,"\t<th>%s</th>\n",symbolTable[j].nombre);
        fprintf(p,"\t<th>%s</th>\n",symbolTable[j].tipo);
        fprintf(p,"\t<th>%s</th>\n",symbolTable[j].valor);
        fprintf(p,"\t<th>%s</th>\n",symbolTable[j].alias);
        fprintf(p,"\t<th>%d</th>\n",symbolTable[j].longitud);
        fprintf(p,"\t<th>%d</th>\n",symbolTable[j].limite);
        fprintf(p, "</tr>\n");
    }

}

void writeTable(FILE *p,  int filas, symbol symbolTable[], void (*tupla)(FILE *p ,int filas, symbol symbolTable[])){
    fprintf(p,"<table>\n");
    fprintf(p, "<tr>\n");
    char titulos[6][20] = {"Nombre","Tipo","Valor","Alias","Longitud","Limite"};
    int j;
    for(j=0; j < 6; j++ ){
        fprintf(p,"<th>%s</th>\n",titulos[j]);
    }
    fprintf(p, "</tr>");

    int i;

        tupla(p,filas,symbolTable);


    fprintf(p,"</table>\n");
}
/*
<table>
  <tr>
    <th>Company</th>
    <th>Contact</th>
    <th>Country</th>
  </tr>
  <tr>
    <td>Alfreds Futterkiste</td>
    <td>Maria Anders</td>
    <td>Germany</td>
  </tr>
*/

void writeHeader(FILE *p, char *title, void (*style)(FILE *p)){
fprintf (p,"<!DOCTYPE html>\n<html>\n<head>\n<title>%s</title>\n",title);
style(p);
fprintf (p,"</head>\n<body>");
}

void writeFooter(FILE *p){
fprintf (p,"</body>\n</html>");
}





//Estructura de la SymbolTable

void symbolTableToHtml(symbol symbolTable[],char * ruta)
{
//Declaracion de variables

//Definicion del archivo de salida y su cabecera
FILE  *p = fopen(ruta, "w");
writeHeader(p, "Tabla de simbolos",writeStyle);
writeTable(p,pos_st  , symbolTable,writeTupla);
writeFooter(p);

//Fin
fclose(p);
}


// fin funciones imprimir html





// helpers
char *downcase(char *p);
char *prefix_(char *p);
int searchSymbol(char key[]);
int saveSymbol(char nombre[], char tipo[], char valor[] );
symbol getSymbol(char nombre[]);
void symbolTableToExcel(symbol table[],char * ruta);
/* fin de funciones tabla de simbolos */

/* funciones para validacion (cabeceras)*/

int validarInt(char entero[]);
int validarFloat(char flotante[]);
int validarBin(char binario[]);
int validarString(char cadena[]);

int longListaId = 0;   //estas variables se usan para ver el balanceo del defvar
int longListaTipos = 0;//estas variables se usan para ver el balanceo del defvar
                     // se van a ir sumando y cuando se ejecuta la regla lv : lt
                     // compara que haya la misma cantidad de los dos lados
int verificarBalanceo();


/* fin de funciones para validacion */

/* funciones para que el bloque DecVar cargue la tabla de símbolos */

char varTypeArray[2][100][50];
int idPos = 0;
int typePos = 0;

void collectId (char *id);
void collectType (char *type);
void consolidateIdType();

/* fin de funciones para que el bloque DecVar cargue la tabla de símbolos */




%}

%union{
 char s[20];
}


%token IF ELSE WHILE DEFVAR ENDDEF PERCENT INLIST
%token REAL BINA ENTERO STRING_CONST
%token <s> ID
%token FLOAT INT STRING
%token P_A P_C L_A L_C FL DP CO
%token OP_CONCAT OP_SUM OP_RES OP_DIV OP_MUL MOD DIV
%token CMP_MAY CMP_MEN CMP_MAYI CMP_MENI CMP_DIST CMP_IGUAL
%token ASIG
%type <s> expresion


%%
raiz: programa { printf("Compila OK \n"); symbolTableToHtml(symbolTable,"ts.html");grabarPolaca();}
    ;
programa
    :bloque_dec sentencias {printf("programa : bloque_dec sentencias \n");}
    | sentencias    {printf("programa : sentencias \n");}
    | bloque_dec {printf("programa: bloque_dec \n");}
    ;
bloque_dec
    : DEFVAR declaraciones ENDDEF {consolidateIdType();printf(" bloque_dec : DEFVAR declaraciones ENDDEF \n ");}
    ;
declaraciones
    : declaraciones declaracion    {printf("declaraciones: declaraciones declaracion \n");}
    | declaracion                    {printf("declaraciones: declaracion  \n");}
    ;
declaracion
    : lista_variables DP lista_tipos_datos {verificarBalanceo() ; printf("declaracion: lista_variables DP lista_tipos_datos \n");}
    ;
lista_tipos_datos
    : lista_tipos_datos CO tipo_dato {longListaTipos++; printf(" lista_tipos_datos   : lista_tipos_datos CO tipo_dato \n");}
    | tipo_dato {longListaTipos++;  printf(" lista_tipos_datos   : tipo_dato \n");}
    ;
lista_variables
    : lista_variables CO ID { longListaId++; collectId(yylval.s);  printf("lista_variables     : lista_variables CO ID: %s\n", yylval.s);}
    | ID { longListaId++; collectId(yylval.s); printf("lista_variables     : ID: %s\n", yylval.s);}
    ;
tipo_dato
    : STRING { collectType("string") ; printf("tipo_dato  : STRING \n");}
    | FLOAT  { collectType("float") ;printf("tipo_dato  : FLOAT \n");}
    | INT    { collectType("float") ;printf("tipo_dato  : INT \n");}
    ;
sentencias
    : sentencias sentencia  {printf("sentencias  : sentencias sentencia\n");}
    | sentencia             {printf("sentencias  : sentencia \n");}
    ;
sentencia
    : asignacion FL         {printf("sentencias  : asignacion FL\n");}
    | iteracion             {printf("sentencias  : iteracion \n");}
    | decision              {printf("sentencias  : decision\n");}
    ;
decision
   : IF P_A condicion P_C L_A sentencias L_C {printf("decision   : IF P_A condicion P_C L_A sentencias L_C\n");
                                                desapilarEtiqueta();
                                                sprintf(buffer,"%d", posPolaca);
                                                insertarPolaca(buffer, atoi(EtiqDesa));
                                             }
   | IF P_A condicion P_C L_A sentencias L_C {
       printf("fin del then\n");
       desapilarEtiqueta();
       sprintf(buffer,"%d", posPolaca +2);
       insertarPolaca(buffer, atoi(EtiqDesa));
       sprintf(buffer, "%d",posPolaca );
       apilarEtiqueta(buffer);
       apilarPolaca("pos");
       apilarPolaca("BI");
// aca esta la magia

// aca termina la magia

   }

   ELSE
                                            {printf("else\n");

                                        }
    L_A sentencias L_C
                                            {printf("fin del else\n");
                                            desapilarEtiqueta();
                                            sprintf(buffer,"%d", posPolaca);
                                            insertarPolaca(buffer, atoi(EtiqDesa));
                                            ;}
   ;
iteracion
    : WHILE {
            printf("while\n");
            apilarWhile(posPolaca);
    }
    P_A condicion P_C L_A sentencias L_C {
                                                    printf("iteracion  : WHILE P_A condicion P_C L_A sentencias\n");
                                                     desapilarEtiqueta();
                                                     sprintf(buffer,"%d", posPolaca + 2);
                                                     insertarPolaca(buffer, atoi(EtiqDesa));
                                                     sprintf(buffer,"%d", desapilarWhile());

                                                     apilarPolaca(buffer);
                                                     apilarPolaca("BI");
                                                }
    ;
asignacion
    : ID ASIG expresion              {  auxSymbol = getSymbol($1);
                                        validarTipos(auxSymbol.tipo);
                                        auxSymbol = nullSymbol;
                                        apilarPolaca($1);
                                        apilarPolaca("=");
                                    }
    | ID ASIG concatenacion          {  auxSymbol = getSymbol($1);
                                        if(strcmp(auxSymbol.tipo,"string")!=0 ){ auxSymbol = nullSymbol; yyerror("Tipos incompatibles");}
                                        validarTipos("string");
                                        printf("acá hay que validar asignacion : ID ASIG concatenacion \n");
                                        apilarPolaca($1);
                                        apilarPolaca("=");
                                    }
    ;
concatenacion
    : ID OP_CONCAT ID                  {auxSymbol = getSymbol($1);
                                        if(strcmp(auxSymbol.tipo,"string")!=0 ){ auxSymbol = nullSymbol; yyerror("Tipos incompatibles");}
                                        auxSymbol = getSymbol($3);
                                        if(strcmp(auxSymbol.tipo,"string")!=0 ){ auxSymbol = nullSymbol; yyerror("Tipos incompatibles");}
                                        validarTipos("string");
                                        printf("acá hay que validar concatenacion: ID OP_CONCAT ID");
                                        apilarPolaca("++");
                                       }
    | ID OP_CONCAT constanteString     {auxSymbol = getSymbol($1);
                                        if(strcmp(auxSymbol.tipo,"string")!=0 ){ auxSymbol = nullSymbol; yyerror("Tipos incompatibles");}
                                        printf("acá hay que validar concatenacion: ID OP_CONCAT constanteString");
                                        validarTipos("string");
                                        apilarPolaca("++");
                                       }
    | constanteString OP_CONCAT ID     {auxSymbol = getSymbol($3);
                                        if(strcmp(auxSymbol.tipo,"string")!=0 ){ auxSymbol = nullSymbol; yyerror("Tipos incompatibles");}
                                        printf("acá hay que validar concatenacion: constanteString OP_CONCAT ID");
                                        validarTipos("string");
                                        apilarPolaca("++");
                                        }
    | constanteString OP_CONCAT constanteString {validarTipos("string");apilarPolaca("++");}
    | constanteString                   {validarTipos("string");}
    ;
condicion
    : expresion CMP_MAY expresion    {printf("condicion  : expresion CMP_MAY expresion \n");
                                        validarTipos("float");
                                        apilarPolaca("CMP");
                                        sprintf(buffer, "%d",posPolaca);
                                        apilarEtiqueta(buffer);
                                        apilarPolaca("pos");
                                        apilarPolaca("BLE");
                                    }
    | expresion CMP_MEN expresion    {printf("condicion  | expresion CMP_MEN expresion \n");
                                        validarTipos("float");
                                        apilarPolaca("CMP");
                                        sprintf(buffer, "%d",posPolaca);
                                        apilarEtiqueta(buffer);
                                        apilarPolaca("pos");
                                        apilarPolaca("BGE");
                                        }
    | expresion CMP_MAYI expresion   {printf("condicion  :  \n");
                                        validarTipos("float");
                                        apilarPolaca("CMP");
                                        sprintf(buffer, "%d",posPolaca);
                                        apilarEtiqueta(buffer);
                                        apilarPolaca("pos");
                                        apilarPolaca("BLT");
                                    }
    | expresion CMP_MENI expresion   {printf("condicion  : CMP_MENI expresion   \n");
                                        validarTipos("float");
                                        apilarPolaca("CMP");
                                        sprintf(buffer, "%d",posPolaca);
                                        apilarEtiqueta(buffer);
                                        apilarPolaca("pos");
                                        apilarPolaca("BGT");
                                    }
    | expresion CMP_DIST expresion   {printf("condicion  : CMP_DIST expresion   \n");
                                        validarTipos("float");
                                        apilarPolaca("CMP");
                                        sprintf(buffer, "%d",posPolaca);
                                        apilarEtiqueta(buffer);
                                        apilarPolaca("pos");
                                        apilarPolaca("BEQ");
                                    }
    | expresion CMP_IGUAL expresion  {printf("condicion  : CMP_IGUAL expresion  \n");
                                        validarTipos("float");
                                        apilarPolaca("CMP");
                                        sprintf(buffer, "%d",posPolaca);
                                        apilarEtiqueta(buffer);
                                        apilarPolaca("pos");
                                        apilarPolaca("BNE");
                                    }
    ;
expresion
    : expresion OP_SUM termino       {printf("expresion  : expresion OP_SUM termino \n"); validarTipos("float");apilarPolaca("+");}
    | expresion OP_RES termino       {printf("expresion  : expresion OP_RES termino\n"); validarTipos("float");apilarPolaca("-");}
    | termino                        {printf("expresion  : termino                 \n");}
    ;
termino
    : termino OP_MUL factor          {printf("termino    : termino OP_MUL factor \n"); validarTipos("float");apilarPolaca("*");}
    | termino OP_DIV factor          {printf("termino    : termino OP_DIV factor \n"); validarTipos("float");apilarPolaca("/");}
    | termino DIV factor             {printf("termino    : termino DIV factor \n"); validarTipos("float");apilarPolaca("DIV");}
    | termino MOD factor             {printf("termino    : termino MOD factor \n"); validarTipos("float");apilarPolaca("MOD");}
    | factor                         {printf("termino    : factor \n");}
    ;
factor
    : P_A expresion P_C              {printf("factor : P_A expresion P_C  \n");}
    | ID                             {  printf("factor : ID (insertando tipo) \n");
                                        auxSymbol=getSymbol($1);
                                        insertarTipo(auxSymbol.tipo);
                                        apilarPolaca($1);
                                    }
    | constanteNumerica
    ;
constanteNumerica
    : ENTERO                         {validarInt(yylval.s) ;printf("constante : ENTERO: %s\n" , yylval.s); apilarPolaca(yylval.s); }
    | REAL                           {validarFloat(yylval.s);printf("constante : REAL: %s  \n" , yylval.s); apilarPolaca(yylval.s);}
    | BINA                           {validarBin(yylval.s);printf("constante : BINA: %s\n" , yylval.s); apilarPolaca(yylval.s);}
    ;
constanteString
    : STRING_CONST                   {validarString(yylval.s);printf("constante : STRING \n" , yylval.s);apilarPolaca(yylval.s);}
    ;
%%

// //auxSymbol = getSymbol($1); if(strcmp(auxSymbol.tipo,"float")!=0 ){ auxSymbol = nullSymbol; yyerror("Tipos incompatibles");} ;printf("factor : ID: %s\n", yylval.s);}

/* funciones para validacion */

int validarInt(char entero[]) {
    int casteado = atoi(entero);
    char msg[100];
    if(casteado < -32768 || casteado > 32767) {
        sprintf(msg, "ERROR: Entero %d fuera de rango. Debe estar entre [-32768; 32767]\n", casteado);
        yyerror(msg);
    } else {
        //guardarenTS
        saveSymbol(entero,"cFloat", NULL);
        insertarTipo("cFloat");

        //printf solo para pruebas:
        //printf("Entero ok! %d \n", casteado);
        return 0;

    }

}

int validarFloat(char flotante[]) {
    double casteado = atof(flotante);
    casteado = fabs(casteado);
    char msg[300];

    if(casteado < FLT_MIN || casteado > FLT_MAX) {
        sprintf(msg, "ERROR: Float %f fuera de rango. Debe estar entre [1.17549e-38; 3.40282e38]\n", casteado);
        yyerror(msg);
    } else {
        saveSymbol(flotante,"cFloat", NULL);
        insertarTipo("cFloat");
        //guardarenTS
        //printf solo para pruebas:
    //    printf("Float ok! %f \n", casteado);
        return 0;

    }

}

int validarBin(char binario[]){
    char binFloat[50];
    char *ptr ;//puntero que misteriosamente usa esta funcion
    long casteado = strtol(binario+2, &ptr, 2);
    sprintf(binFloat,"%d",casteado);
    printf ("############### %s\n",binFloat);
    char msg[100];
    if(casteado < -32768 || casteado > 32767) {
        sprintf(msg, "ERROR: Entero %d fuera de rango. Debe estar entre [-32768; 32767]\n", casteado);
        yyerror(msg);
    } else {
        saveSymbol(binario,"cFloat", binFloat);
        insertarTipo("cFloat");
        //guardarenTS
        //printf solo para pruebas:
    //    printf("Binario ok! %d \n", casteado);
        return 0;

    }
}


int validarString(char cadena[]) {
    char msg[100];
    int longitud = strlen(cadena);

    if( strlen(cadena) > 32){ //en lugar de 30 verifica con 32 porque el string viene entre comillas
        sprintf(msg, "ERROR: Cadena %s demasiado larga. Maximo 30 caracteres\n", cadena);
        yyerror(msg);
    }
    char sincomillas[31];
    int i;
    for(i=0; i< longitud - 2 ; i++) {
            sincomillas[i]=cadena[i+1];
    }
    sincomillas[i]='\0';
    //guardarenTS();
    saveSymbol(sincomillas,"cString", NULL);
    insertarTipo("String");
/*
    // Bloque para debug
    printf("***************************\n");
    printf("%d\n",strlen(sincomillas));
    for ( i = 0; i < strlen(sincomillas)+1; i++) {
        printf("%d : %c , %d \n",i,sincomillas[i],sincomillas[i]);
    }
    printf("***************************\n");
*/

    //guardarenTS;
    return 0;
}

int verificarBalanceo(){
    if(longListaTipos != longListaId){
        yyerror("La declaracion de variables debe tener mismo numero de miembros a cada lado del : ");
    }
    longListaTipos = longListaId = 0;
    return 0;
}



/* fin de funciones para validacion */


/* funciones para que el bloque DecVar cargue la tabla de símbolos */

void collectId (char *id) {
    strcpy(varTypeArray[0][idPos++],id);
}

void collectType (char *type){
    strcpy(varTypeArray[1][typePos++],type);

}

void consolidateIdType() {
    printf("Guardando data en tabla de simbolos\n");
    int i;
    for(i=0; i < idPos; i++ ) {
        saveSymbol(varTypeArray[0][i],varTypeArray[1][i], NULL);
    }
    idPos=0;
    typePos=0;
}

/* fin de funciones para que el bloque DecVar cargue la tabla de símbolos */

/* funciones tabla de simbolos */

char *downcase(char *p){
    char *pOrig = p;
    for ( ; *p; ++p) *p = tolower(*p);
    return pOrig;
}

char *prefix_(char *p){
    int tam = strlen(p);
    p = p + tam ;
    int i;
    for(i=0; i < tam + 1 ; i++){
        *(p+1) = *p;
        p--;
    }
    *(p+1) = '_';
    return p+1;
}


int searchSymbol(char key[]){
    static int llamada=0;
    llamada++;
    char mynombre[100];
    strcpy(mynombre,key);
    prefix_(downcase(mynombre));
    int i;
    for ( i = 0;  i < pos_st ; i++) {
        if(strcmp(symbolTable[i].nombre, mynombre ) == 0){
            return i;
        }
    }

    return -1;
}

int saveSymbol(char nombre[], char tipo[], char valor[] ){
    char mynombre[100];
    char type[10];
    strcpy(type,tipo);
    strcpy(mynombre,nombre);
    downcase(type);
    int use_pos = searchSymbol(nombre);
    if ( use_pos == -1){
        use_pos = pos_st;
        pos_st++;
    }
    symbol newSymbol;
    strcpy(newSymbol.nombre, prefix_(downcase(mynombre)));
    strcpy(newSymbol.tipo, type);
    if (valor == NULL){
        strcpy(newSymbol.valor, nombre);
    } else {
        strcpy(newSymbol.valor, valor);
    }

    //strcpy(newSymbol.alias, alias);
    newSymbol.longitud = strlen(nombre);
    symbolTable[use_pos] = newSymbol;
    newSymbol = nullSymbol;
    return 0;
}

symbol getSymbol(char nombre[]){
    int pos = searchSymbol(nombre);
    if(pos >= 0) return symbolTable[pos];
    return nullSymbol;
}

void symbolTableToExcel(symbol table[],char * ruta)
{
//Declaracion de variables
int i;
//Definicion del archivo de salida y su cabecera
FILE  *ptr = fopen(ruta, "w");
fprintf (ptr,"nombre,tipo,valor,alias,longitud,limite\n");
//Recorrido de la symbol table, corta con el caracter @
//while(strncmp(table[i].nombre,"@",1)!=0)
for(i=0;i < pos_st ;i++) {
    fprintf(ptr, "%s,%s,%s,%s,%d,%d\n",table[i].nombre,table[i].tipo,table[i].valor,table[i].alias,table[i].longitud,table[i].limite);
}
//Fin
fclose(ptr);
}



/* fin de funciones tabla de simbolos */

/*funciones  para handle de tipos */

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
    char auxa[50];
    char auxb[50];
    strcpy(auxa,a);
    strcpy(auxb,b);
    downcase(auxa);
    downcase(auxb);
    printf("Comparando %s y %s\n",auxa,auxb);

    if (strstr(auxa,auxb) != NULL){
        return 0;
    }
    if (strstr(auxb,auxa) != NULL){
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




/*fin de funciones  para handle de tipos */


/* funciones para polaca */




/***************************************************
funcion que genera la polaca en el archivo intermedia.txt
***************************************************/
void apilarPolaca(char *strToken){
        strcpy(pilaPolaca[posPolaca],strToken);
        //fprintf(ArchivoPolaca, "%d : %s\n", posPolaca, strToken);
        posPolaca++;
   	/*if (c != EOF )
			fprintf(ArchivoPolaca, ",");*/
}

void insertarPolaca(char *strToken, int pos){
    strcpy(pilaPolaca[pos],strToken);
}

void grabarPolaca(){
    int i;
    for(i=0; i<posPolaca ; i++){
        fprintf(ArchivoPolaca, "%d : %s\n",i,pilaPolaca[i]);
    }
}


/***************************************************
funcion que genera etiquetas unicas
***************************************************/
void generarEtiqueta(){
     char string[25];

  	strcpy(Etiqueta,"@@etiq");

	contEtiqueta = contEtiqueta + 1;
    strcat(Etiqueta, itoa(contEtiqueta, string, 10) );
}

/***************************************************
funcion que guarda en la pila una etiqueta
***************************************************/
void apilarEtiqueta(char *strEtiq){
    strcpy(pilaEtiquetas[topeEtiquetas],strEtiq);
    topeEtiquetas = topeEtiquetas + 1;
}


void apilarWhile(int pos){
    pilaWhile[topePilaWhile]=pos;
    topePilaWhile++;
}

int desapilarWhile(){
    topePilaWhile--;
    return(pilaWhile[topePilaWhile]);
}

/***************************************************
funcion que saca de la pila una etiqueta
***************************************************/
void desapilarEtiqueta(){

    topeEtiquetas = topeEtiquetas - 1;
    strcpy(EtiqDesa,pilaEtiquetas[topeEtiquetas]);
	strcpy(pilaEtiquetas[topeEtiquetas],"");
}

/* fin de funciones para polaca */





int main(int argc,char *argv[]){
    if ((ArchivoPolaca = fopen("intermedia.txt", "wt")) == NULL) {
        fprintf(stderr,"\nNo se puede abrir el archivo: %s\n", "intermedia.txt");
        exit(1);
    }
    strcpy(nullSymbol.nombre,"!");//inicializando simbolo nulo
    yyparse();
    fclose(ArchivoPolaca);
    return 0;
}

int yyerror(char *msg){
    fprintf(stderr, "At line %d %s in text: %s\n", yylineno, msg, yytext);
    exit(1);
}
