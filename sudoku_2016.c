#include "sudoku_2016.h"

/* *****************************************************************************
 * Funciones privadas (static)
 * (no pueden ser invocadas desde otro fichero) */

/* *****************************************************************************
 * modifica el valor almacenado en la celda indicada */
static inline void
celda_poner_valor(CELDA *celdaptr, uint8_t val)
{
    *celdaptr = (*celdaptr & 0xFFF0) | (val & 0x000F);
}

/* *****************************************************************************
 * extrae el valor almacenado en los 16 bits de una celda */
static inline uint8_t
celda_leer_valor(CELDA celda)
{
    return (celda & 0x000F);
}

/* *****************************************************************************
 * propaga el valor de una determinada celda
 * para actualizar las listas de candidatos
 * de las celdas en su su fila, columna y regi�n */
static void
sudoku_candidatos_propagar_c(CELDA cuadricula[NUM_FILAS][NUM_COLUMNAS],
                             uint8_t fila, uint8_t columna)
{
    /* valor que se propaga */
    uint8_t valor = celda_leer_valor(cuadricula[fila][columna]);

    // INICIO DEL C�DIGO PROPIO
    uint16_t mascara = ~(1 << (3 + valor)); // para borrar [valor] como candidato
    //printf("%u\n",mascara);
    uint8_t fila_0 = (fila/3)*3; // fila 0 del cuadrante actual
    uint8_t columna_0 = (columna/3)*3; // columna 0 del cuadrante actual
    uint8_t i=0;
    while(i<9) {
        /* recorrer fila descartando valor de listas candidatos */
        cuadricula[fila][i] = cuadricula[fila][i] & mascara;
        /* recorrer columna descartando valor de listas candidatos */
        cuadricula[i][columna] = cuadricula[i][columna] & mascara;
        i++;
    }
    /* recorrer region descartando valor de listas candidatos */
    uint8_t f=fila_0;
    while(f<fila_0+3) {
        uint8_t c=columna_0;
        while(c<columna_0+3) {
            cuadricula[f][c] = cuadricula[f][c] & mascara;
            c++;
        }
        f++;
    }
    // FIN DEL C�DIGO PROPIO
}

/* *****************************************************************************
 * calcula todas las listas de candidatos (9x9)
 * necesario tras borrar o cambiar un valor (listas corrompidas)
 * retorna el numero de celdas vacias */
static int
sudoku_candidatos_init_c(CELDA cuadricula[NUM_FILAS][NUM_COLUMNAS],
						 char propagar)
{
    int celdas_vacias = 0;
    /* recorrer cuadricula celda a celda */
        /* inicializa lista de candidatos */
    // INICIO DEL C�DIGO PROPIO
    uint16_t mascara = 0x1FF0; // para marcar todos los candidatos como posibles
    uint8_t f=0;
    while(f<9) {
        uint8_t c=0;
        while(c<9) {
            cuadricula[f][c] = cuadricula[f][c] | mascara; // se marca todo como posible candidato (1)
            c++;
        }
        f++;
    }
    // ¡estos dos bucles no se pueden fusionar!
    f=0;
    while(f<9) {
        uint8_t c=0;
        while(c<9) {
            if (celda_leer_valor(cuadricula[f][c]) != 0) {
				switch (propagar) {
					case 'C': // C
					sudoku_candidatos_propagar_c(cuadricula, f, c);
					break;

					case 'A': // ARM
					sudoku_candidatos_propagar_arm(cuadricula, f*32, c*2);
					break;

					case 'T': // Thumb
					sudoku_candidatos_propagar_thumb(cuadricula, f*32, c*2);
					break;
				}
			}
            else {
                celdas_vacias++;
            }
            c++;
        }
        f++;
    }
    // FIN DEL C�DIGO PROPIO
    /* recorrer cuadricula celda a celda */
        /* si celda tiene valor */
        /*    sudoku_candidatos_propagar_c(...); */
        /* else actualizar contador de celdas vacias */

    /* retorna el numero de celdas vacias */
    return (celdas_vacias);
}

int sudokusIguales(const CELDA cuadriculaA[NUM_FILAS][NUM_COLUMNAS],
                   CELDA cuadriculaB[NUM_FILAS][NUM_COLUMNAS]) {
    int iguales = 1; // partimos de que son iguales
    int f=0, c=0;
    while (f<9 && iguales) {
        c=0;
        while (c<9 && iguales) {
            iguales = cuadriculaA[f][c] == cuadriculaB[f][c];
            c++;
        }
        f++;
    }
    return iguales;
}

/* *****************************************************************************
 * Funciones p�blicas
 * (pueden ser invocadas desde otro fichero) */

/* *****************************************************************************
 * programa principal del juego que recibe el tablero,
 * y la se�al de ready que indica que se han actualizado fila y columna */
void
sudoku9x9(CELDA cuadricula[NUM_FILAS][NUM_COLUMNAS], char *ready)
{
    int celdas_vacias;     //numero de celdas aun vacias
	
	const CELDA cuadriculaIdeal[NUM_FILAS][NUM_COLUMNAS] = {
			{0x8cb5,0x00b0,0x0c30,0x8293,0x00b0,0x0a80,0x1c10,0x18b0,0x1ea0,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000},
			{0x0cf0,0x00f0,0x0c70,0x0290,0x80b9,0x0a80,0x0c10,0x08b0,0x8ea5,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000},
			{0x08b0,0x80b9,0x8836,0x8097,0x00b0,0x8885,0x0810,0x88b3,0x08a0,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000},
			{0x0470,0x8078,0x0470,0x8089,0x0580,0x0480,0x8156,0x0130,0x0060,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000},
			{0x1460,0x0060,0x9465,0x8008,0x8406,0x8401,0x9044,0x1020,0x1060,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000},
			{0x1010,0x0210,0x9014,0x8002,0x0100,0x8003,0x1910,0x9917,0x1800,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000},
			{0x08d0,0x80d7,0x0850,0x8095,0x00d0,0x8089,0x8842,0x8886,0x08c0,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000},
			{0x90f6,0x01f0,0x1070,0x0090,0x84d8,0x0480,0x1540,0x1180,0x14c0,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000},
			{0x18c0,0x01c0,0x1840,0x0280,0x04c0,0x8682,0x1d40,0x1980,0x9cc1,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000}
		};

    /* calcula lista de candidatos, versi�n C */
    celdas_vacias = sudoku_candidatos_init_c(cuadricula, 'A');
	if (!sudokusIguales(cuadriculaIdeal, cuadricula)) {
		int tmp=0;
	}
    celdas_vacias = sudoku_candidatos_init_c(cuadricula, 'C');
	if (!sudokusIguales(cuadriculaIdeal, cuadricula)) {
		int tmp=0;
	}
    celdas_vacias = sudoku_candidatos_init_c(cuadricula, 'T');
	if (!sudokusIguales(cuadriculaIdeal, cuadricula)) {
		int tmp=0;
	}
	/*
    celdas_vacias = sudoku_candidatos_init_arm(cuadricula, 'C');
	if (!sudokusIguales(cuadriculaIdeal, cuadricula)) {
		int tmp=0;
	}
    celdas_vacias = sudoku_candidatos_init_arm(cuadricula, 'A');
	if (!sudokusIguales(cuadriculaIdeal, cuadricula)) {
		int tmp=0;
	}
    celdas_vacias = sudoku_candidatos_init_arm(cuadricula, 'T');
	if (!sudokusIguales(cuadriculaIdeal, cuadricula)) {
		int tmp=0;
	
	*/
}

/* repetir para otras versiones (ARM, THUMB) */
