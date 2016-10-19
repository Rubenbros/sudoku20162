#include "sudoku_2016.h"

int sudokusIguales(CELDA cuadriculaA[NUM_FILAS][NUM_COLUMNAS],
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

void copiarCuadricula(CELDA cuadriculaOrigen[NUM_FILAS][NUM_COLUMNAS],
                      CELDA cuadriculaDestino[NUM_FILAS][NUM_COLUMNAS]) {
    int f=0, c=0;
    while (f<9) {
        c=0;
        while (c<9) {
            cuadriculaDestino[f][c] = cuadriculaOrigen[f][c];
            c++;
        }
        f++;
    }
}

int main() {

    CELDA cuadricula[NUM_FILAS][NUM_COLUMNAS] = {
        
        {0x8005,0x0000,0x0000,0x8003,0x0000,0x0000,0x0000,0x0000,0x0000,0,0,0,0,0,0,0},
        {0x0000,0x0000,0x0000,0x0000,0x8009,0x0000,0x0000,0x0000,0x8005,0,0,0,0,0,0,0},
        {0x0000,0x8009,0x8006,0x8007,0x0000,0x8005,0x0000,0x8003,0x0000,0,0,0,0,0,0,0},
        {0x0000,0x8008,0x0000,0x8009,0x0000,0x0000,0x8006,0x0000,0x0000,0,0,0,0,0,0,0},
        {0x0000,0x0000,0x8005,0x8008,0x8006,0x8001,0x8004,0x0000,0x0000,0,0,0,0,0,0,0},
        {0x0000,0x0000,0x8004,0x8002,0x0000,0x8003,0x0000,0x8007,0x0000,0,0,0,0,0,0,0},
        {0x0000,0x8007,0x0000,0x8005,0x0000,0x8009,0x8002,0x8006,0x0000,0,0,0,0,0,0,0},
        {0x8006,0x0000,0x0000,0x0000,0x8008,0x0000,0x0000,0x0000,0x0000,0,0,0,0,0,0,0},
        {0x0000,0x0000,0x0000,0x0000,0x0000,0x8002,0x0000,0x0000,0x8001,0,0,0,0,0,0,0}
        
        /*
        {0x8b97,0x0cd9,0x936e,0x34b0,0x1022,0x9b0e,0x9da2,0x68ae,0x001d,0,0,0,0,0,0,0},
        {0x5529,0x86fa,0x631d,0x37f5,0x6b0f,0x0245,0x9a8f,0x2bbc,0x9544,0,0,0,0,0,0,0},
        {0x0d9f,0x1824,0x84a0,0x484b,0x0fa1,0x95ca,0x12c5,0x385d,0x8cbc,0,0,0,0,0,0,0},
        {0x8ee9,0x0bab,0x8f47,0x9863,0x5811,0x79bc,0x46d3,0x871a,0x973f,0,0,0,0,0,0,0},
        {0x5e76,0x33f2,0x0123,0x941f,0x08d5,0x8bd6,0x0d48,0x130a,0x4abf,0,0,0,0,0,0,0},
        {0x7ad9,0x062f,0x0456,0x6999,0x198f,0x35e8,0x7737,0x34ca,0x3e68,0,0,0,0,0,0,0},
        {0x1099,0x7b3a,0x9563,0x1dbf,0x9546,0x9894,0x992a,0x96ed,0x1c2a,0,0,0,0,0,0,0},
        {0x4354,0x3930,0x6319,0x1938,0x6b1a,0x2ea8,0x5dba,0x3a5a,0x7c79,0,0,0,0,0,0,0},
        {0x2be4,0x95d9,0x4622,0x72d7,0x9428,0x954d,0x4f01,0x1aa1,0x6e12,0,0,0,0,0,0,0}
        */
    };
    CELDA cuadriculaA[NUM_FILAS][NUM_COLUMNAS];
    CELDA cuadriculaB[NUM_FILAS][NUM_COLUMNAS];
    CELDA cuadriculaC[NUM_FILAS][NUM_COLUMNAS];
    CELDA cuadriculaD[NUM_FILAS][NUM_COLUMNAS];
    CELDA cuadriculaE[NUM_FILAS][NUM_COLUMNAS];
    CELDA cuadriculaF[NUM_FILAS][NUM_COLUMNAS];
    copiarCuadricula(cuadricula, cuadriculaA);
    copiarCuadricula(cuadricula, cuadriculaB);
    copiarCuadricula(cuadricula, cuadriculaC);
    copiarCuadricula(cuadricula, cuadriculaD);
    copiarCuadricula(cuadricula, cuadriculaE);
    copiarCuadricula(cuadricula, cuadriculaF);
/*
    for (int i=0; i<NUM_FILAS; i++) {
        //std::bitset<NUM_COLUMNAS> y(cuadricula[0][0]);
        for (int j=0; j<NUM_COLUMNAS; j++) {
            //std::bitset<NUM_COLUMNAS> y(cuadricula[i][j]);
            //std::cout << y << flush;
            printf("%04x",cuadricula[i][j]);
            printf("|");
        }
        printf("\n");
    }
    printf("\n");
    for (int i=0; i<NUM_FILAS; i++) {
        //std::bitset<NUM_COLUMNAS> y(cuadricula[0][0]);
        for (int j=0; j<NUM_COLUMNAS; j++) {
            //std::bitset<NUM_COLUMNAS> y(cuadricula[i][j]);
            //std::cout << y << flush;
            printf("%04x",cuadricula[i][j]);
            printf("|");
        }
        printf("\n");
    }
    printf("\n");
    printf("\n");
    printf("\n");
    printf("\n");

*/
    char ready = '0';

    pruebasInitPropagar(cuadriculaA, 'C', 'C');
    pruebasInitPropagar(cuadriculaB, 'C', 'A');
    //pruebasInitPropagar(cuadriculaC, 'C', 'T');
    pruebasInitPropagar(cuadriculaD, 'A', 'C');
    pruebasInitPropagar(cuadriculaE, 'A', 'A');
    //pruebasInitPropagar(cuadriculaF, 'A', 'T');

    if (
        !sudokusIguales(cuadricula, cuadriculaA) ||
        !sudokusIguales(cuadricula, cuadriculaB) ||
        //!sudokusIguales(cuadricula, cuadriculaC) ||
        !sudokusIguales(cuadricula, cuadriculaD) ||
        !sudokusIguales(cuadricula, cuadriculaE) //||
        //!sudokusIguales(cuadricula, cuadriculaF)
        ) {
        return -1;
    }

/*
    for (int i=0; i<NUM_FILAS; i++) {
        //std::bitset<NUM_COLUMNAS> y(cuadricula[0][0]);
        for (int j=0; j<NUM_COLUMNAS; j++) {
            //std::bitset<NUM_COLUMNAS> y(cuadricula[i][j]);
            //std::cout << y << flush;
            printf("%04x",cuadricula[i][j]);
            printf("|");
        }
        printf("\n");
    }
    printf("\n");
    for (int i=0; i<NUM_FILAS; i++) {
        //std::bitset<NUM_COLUMNAS> y(cuadricula[0][0]);
        for (int j=0; j<NUM_COLUMNAS; j++) {
            //std::bitset<NUM_COLUMNAS> y(cuadricula[i][j]);
            //std::cout << y << flush;
            printf("%04x",cuadricula[i][j]);
            printf("|");
        }
        printf("\n");
    }

    return 0;
*/
}
/*
int main() {
    int algo[10]={
        0b1111111111111111,
        0b0111111111111111,
        0b0111111111111111,
        0b0111111111111111,
        0b1111111111111111,
        0b1111111111111111,
        0b1111111111111111,
        0b1111111111111111,
        0b1111111111111111,
        0b1111111111111111,
    };
    for (int i=0; i<10; i++) {
        //cout << algo[i] << flush;
        std::bitset<16> y(algo[i]);
        std::cout << y << endl;
    }
    cout << endl;
    for (int i=0; i<10; i++) {
        //cout << algo[i] << flush;
        std::bitset<16> y(algo[i]);
        std::cout << y << endl;
    }
    cout << endl;
    cout << endl;
    for (int i=0; i<10; i++) {
        algo[i] = algo[i] >> 15;
        std::bitset<16> y(algo[i]);
        std::cout << y << endl;
    }
    return 0;
}
*/
