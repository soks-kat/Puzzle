/**
 * AQUESTA CODI NO ES POT MODIFICAR I NO CAL LLIURAR-HO
 * */

#include <stdlib.h>
#include <stdio.h>
#include <termios.h>     //termios, TCSANOW, ECHO, ICANON
#include <unistd.h>      //STDIN_FILENO

/**
 * Constants
 */
#define ROWDIM  4		//files de la matriu
#define COLDIM  4		//columnes de la matriu
#define DimMatrix 4		//Dimensió de la matriu

/**
 * Definición de variables globales
 */

int row = 1;			//fila de la pantalla
char col = 'A';   		//columna actual de la pantalla*/
int rowIni;
char colIni;
int rowEmpty = 3;
char colEmpty = 'B';

char  tecla;
char carac, carac2;
int moves = 0;
int victory = 0;

int opc;
int indexMat;
int indexMatIni;
int rowScreen;
int colScreen;
int RowScreenIni= 6; //Fila inicial del taulell
int ColScreenIni= 14; //Columna inicial del taulell


//Matriu 4x4 que conté l'estat inicial del tauler  
char puzzle[ROWDIM][COLDIM] = { 
	               {'A','B','C','D'},
                   {'E','J','F','H'},
                   {'I',' ','G','K'},
                   {'M','N','O','L'}};

/**
 * Definició de les subrutines d'assemblador que s'anomenen des de C en la pràctica 15puzzle
 */
	void posCurScreen();
	void getMove();
	void moveCursor();
	void moveCursorContinuo();
	void moveTile();
	void playTile();
	void playBlock();	

/**
 Definició de les funcions de C d'accès
  */
	void printch_C(char);
	void clearScreen_C();
	char printMenu_C();
	void gotoxy_C(int, int);
	char getch_C();
	void printBoard_C();
	void victory_C();
	//void continue_C(); ??


/**
 * Esborrar la pantalla
 *
 * Variables globals utilitzades:
 * Cap
 *
 * Paràmetres d'entrada:
 * Cap
 *
 * Paràmetres de sortida :
 * Cap
 *
 * Aquesta funció no és crida des d'assemblador
 * i no hi ha definida una subrutina d'assemblador equivalent.
 */
void clearScreen_C(){
   
    printf("\x1B[2J");
    
}


/**
 * Situar el cursor en una fila i una columna de la pantalla
 * en funció de la fila (rowScreen) i de la columna (colScreen)
 * rebuts com a paràmetre.
 *
 * Variables globals utilitzades:
 * Cap
 *
 * Paràmetres d'entrada:
 * (rowScreen): rdi(edi): Fila
 * (colScreen): rsi(esi): Columna
 *
 * Paràmetres de sortida :
 * Cap
 *
 * S'ha definit un subrutina en assemblador equivalent 'gotoxy'
 * per a poder cridar a aquesta funció guardant l'estat dels registres
 * del processador. Això es fa perquè les funcions de C no mantenen
 * l'estat dels registres.
 * El pas de paràmetres és equivalent.
 **/
void gotoxy_C(int rowScreen, int colScreen){
   
   printf("\x1B[%d;%dH",rowScreen,colScreen);
   
}


/**
 * Mostrar un caràcter (c) en pantalla, rebut com a paràmetre,
 * a la posició on hi ha el cursor.
 *
 * Variables globals utilitzades:
 * Cap
 *
 * Paràmetres d'entrada:
 * dil: Caràcter que volem mostrar.
 *
 * Paràmetres de sortida :
 * Cap
 *
 * S'ha definit un subrutina en assemblador equivalent 'printch'
 * per a cridar a aquesta funció guardant l'estat dels registres del
 * processador. Això es fa perquè les funcions de C no mantenen
 * l'estat dels registres.
 * El pas de paràmetres és equivalent.
 */
void printch_C(char c){
   
   printf("%c",c);
   
}


/**
 * Llegir una tecla i retornar el caràcter associat
 * sense mostrar-ho en pantalla.
 *
 * Variables globals utilitzades:
 * Cap
 *
 * Paràmetres d'entrada:
 * Cap
 *
 * Paràmetres de sortida :
 * al: Caràcter que llegim de teclat
 *
 * S'ha definit un subrutina en assemblador equivalent 'getch' per a 
 * cridar a aquesta funció guardant l'estat dels registres del processador.
 * Això es fa perquè les funcions de C no mantenen l'estat dels
 * registres.
 * El pas de paràmetres és equivalent.
 */
char getch_C(){

   int c;   

   static struct termios oldt, newt;

   /*tcgetattr obtenir els paràmetres del terminal
   STDIN_FILENO indica que s'escriguin els paràmetres de l'entrada estàndard (STDIN) sobre oldt*/
   tcgetattr( STDIN_FILENO, &oldt);
   /*se copian los parámetros*/
   newt = oldt;

    /* ~ICANON per tractar l'entrada de teclat caràcter a caràcter no com a línia sencera acabada a /n
    ~ECHOperquè no es mostri el caràcter llegit.*/
   newt.c_lflag &= ~(ICANON | ECHO);          

   /*Fixeu els nous paràmetres del terminal per a l'entrada estàndard (STDIN)
   TCSANOW indica a tcsetattr que canviï els paràmetres immediatament. */
   tcsetattr( STDIN_FILENO, TCSANOW, &newt);

   /*Llegir un caràcter*/
   c=getchar();                 
    
   /*restaurar els paràmetres originals*/
   tcsetattr( STDIN_FILENO, TCSANOW, &oldt);

   /*Tornar el caràcter llegit*/
   return (char)c;
   
}

void victory_C()
{
	//int col_central = 39, row_central = 11;
	int col_central = 16, row_central = 11;
	int row, col;
	
	for (int i = 0; i < 5; i++)
	{
		//Dibuixar la primera fila
		gotoxy_C(row_central - i, col_central - i);
		printf("+----");
		for (int j = 0; j < i; j++)
		{
			printf("--");
		}
		printf("---+");

		//Dibuixar files superiors buides
		for (int j = 1; j < i; j++)
		{
			gotoxy_C(row_central - j, col_central - i);
			printf("|    ");
			for (int k = 0; k < i; k++)
			{
				printf("  ");
			}
			printf("   |");
		}

		//Dibuixar la línia de VICTORY
		gotoxy_C(row_central, col_central - i);
		printf("|");
		for (int k = 0; k < i; k++)
		{
			printf(" ");
		}
		printf("VICTORY");
		for (int k = 0; k < i; k++)
		{
			printf(" ");
		}
		printf("|");

		//Dibuixar files inferiors buides
		for (int j = 1; j < i; j++)
		{
			gotoxy_C(row_central + j, col_central - i);
			printf("|    ");
			for (int k = 0; k < i; k++)
			{
				printf("  ");
			}
			printf("   |");
		}

		//Dibuixar la última fila
		gotoxy_C(row_central + i, col_central - i);
		printf("+----");
		for (int j = 0; j < i; j++)
		{
			printf("--");
		}
		printf("---+");

		//sleep(150);
	}
}




/**
 * Mostrar a la pantalla el menú del joc i demanar una opció.
 * Només accepta una de les opcions correctes del menú ('0'-'6')
 *claer
 * Variables globals utilitzades:
 * Cap
 *
 * Paràmetres d'entrada:
 * Cap
 *
 * Paràmetres de sortida :
 * (charac): rax(al): Opció escollida del menú, llegida de teclat.
 *
 * Aquesta funció no es crida des d'assemblador
 * i no hi ha definida una subrutina d'assemblador equivalent.
 */
char printMenu_C(){
	
   clearScreen_C();
   gotoxy_C(1,1);
   printf("                                 \n");
   printf("                                 \n");
   printf("                                 \n");
   printf(" _______________________________ \n");
   printf("|                               |\n");
   printf("|           MAIN MENU           |\n");
   printf("|_______________________________|\n");
   printf("|                               |\n");
   printf("|       1. Show Cursor          |\n");
   printf("|       2. Move Cursor          |\n");
   printf("|       3. Move Continuous      |\n");
   printf("|       4. Move Tile            |\n");
   printf("|       5. Play(Tile movement)  |\n");
   printf("|                               |\n");
   printf("|        0. Exit                |\n");
   printf("|_______________________________|\n");
   printf("|                               |\n");
   printf("|           OPTION:             |\n");
   printf("|_______________________________|\n"); 

   char charac =' ';
   while (charac < '0' || charac > '5') {
     gotoxy_C(18,20);          //Posicionar el cursor
     charac = getch_C();       //Llegir una opció
     opc=charac;
   }
   return charac;
}


/**
* Mostrar el tauler de joc a la pantalla. Les línies del tauler.
 *
 * Variables globals utilitzades:
 * Cap
 *
 * Paràmetres d'entrada:
 * Cap
 *
 * Paràmetres de sortida :
 * Cap
 *
 * Aquesta funció no és crida des d'assemblador
 * i no hi ha definida una subrutina d'assemblador equivalent.
 * No hi ha pas de paràmetres.
 */
void printBoard_C(){
//Carga valores en pantalla!!

	int i, j, r = 1, c = 1; //25

	clearScreen_C();
	gotoxy_C(r++, 1); //25
	printf("     ============================");
	gotoxy_C(r++, c); 	      //Ti­tol
	printf("          PUZZLE      moves: 0");
	gotoxy_C(r++, c);
	gotoxy_C(r++, 1); //25
	printf("     ============================");
	gotoxy_C(r++, c); 	      
	printf("                                   ");
	gotoxy_C(r++, c); 	      //Coordenades
	printf("            A   B   C   D           ");
	for (i = 0; i < DimMatrix; i++) {
		gotoxy_C(r++, c);
		printf("\t   +"); 	      // "+" cantonada inicial
		for (j = 0; j < DimMatrix; j++) {
			printf("---+");   //segment horitzontal	
		}
		gotoxy_C(r++, c);
		printf("\t%d  |", i + 1);     //Coordenades
		for (j = 0; j < DimMatrix; j++) {
			printf(" %c |", puzzle[i][j]);
		}
	}
	gotoxy_C(r++, c);
	printf("\t   +");
	for (j = 0; j < DimMatrix; j++) {
		printf("---+");
	}

                          
                       
}


//Programa Principal
int main(void){
   
	opc = 1;
	RowScreenIni = 8;
	ColScreenIni = 14;
	moves = 0;
   
   while (opc!='0') {
		printMenu_C();					//Mostrar menú
		gotoxy_C(18, 20);				//Situar el cursor
		//opc = getch_C();				//Llegir una opció
		row = 3;
		col = 'B';
      switch(opc){
          case '1': //Show cursor
			clearScreen_C();  			//Esborra la pantalla
			printBoard_C();				//Mostrar el tauler

			gotoxy_C(17, 14);			//Situar el cursor a sota del tauler
			printf("Press any key ");

			posCurScreen();				//Posicionar el cursor a pantalla

			getch_C();					//Esperar que es premi una tecla
         break;    
         case '2': // Move Cursor
			clearScreen_C();  			//Esborra la pantalla
			printBoard_C();				//Mostrar el tauler

			posCurScreen();				//Posicionar el cursor a pantalla
			getMove();					//Llegir tecla i comprovar que sigui vàlida
			moveCursor();				//Moure el cursor

			gotoxy_C(17, 14);			//Situar el cursor a sota del tauler
			printf("Press any key ");

			posCurScreen();				//Posicionar el cursor a pantalla.
			getch_C();
         break;
         
          case '3': //Move Cursor Continuos
			clearScreen_C();  			//Esborra la pantalla
			printBoard_C();   	 		//Mostrar el tauler.

			posCurScreen();				//Posicionar el cursor a pantalla.
			moveCursorContinuo();		//Moure el cursor múltiples cops fins pulsar 's' o 'm'.

			gotoxy_C(17, 14);			//Situar el cursor a sota del tauler
			printf("Press any key ");

			getch_C();
         break;
         
        case '4': //Move Tile
			clearScreen_C();  			//Esborra la pantalla
			printBoard_C();   	 		//Mostrar el tauler.

			posCurScreen();				//Posicionar el cursor a pantalla.
			moveCursorContinuo();		//Moure el cursor múltiples cops fins pulsar 's' o 'm'.
			if (tecla == 'm')
			{
				moveTile();
			}

			gotoxy_C(17, 14);			//Situar el cursor a sota del tauler
			printf("Press any key ");

			getch_C();
         break;
         
		case '5'://Play (Tile movement)
			clearScreen_C();  	 		//Esborra la pantalla
			printBoard_C();   	 		//Mostrar el tauler.

			posCurScreen();				//Posicionar el cursor a pantalla.
			playTile();
			
			if (victory==1) { victory_C();}
				
			gotoxy_C(17, 14);			//Situar el cursor a sota del tauler
			printf("Press any key ");

			getch_C();
			break;         

     }
   }
   printf("\n\n");
   
   return 0;
   
}
