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
sudoku_candidatos_init_c(CELDA cuadricula[NUM_FILAS][NUM_COLUMNAS])
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
            if (celda_leer_valor(cuadricula[f][c]) != 0) sudoku_candidatos_propagar_c(cuadricula, f, c);
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

    /* calcula lista de candidatos, versi�n C */
    celdas_vacias = sudoku_candidatos_init_c(cuadricula);
}

//void
//sudoku9x9_Copt(CELDA cuadricula[NUM_FILAS][NUM_COLUMNAS],
//               char *ready)
//{
//    int celdas_vacias;     //numero de celdas aun vacias
//
//    /* calcula lista de candidatos, versi�n C optimizada */
//    celdas_vacias = sudoku_candidatos_init_c_opt(cuadricula);
//
//}

/* repetir para otras versiones (ARM, THUMB) */
