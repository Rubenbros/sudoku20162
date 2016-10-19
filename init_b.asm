.text

#        ENTRY                  /*  mark the first instruction to call */
.global start

start:
.arm    /* indicates that we are using the ARM instruction set */

#------standard initial code
# --- Setup interrupt / exception vectors
      B       Reset_Handler
/* In this version we do not use the following handlers */
################################################################################
#-----------Undefined_Handler:
#      B       Undefined_Handler
#----------SWI_Handler:
#      B       SWI_Handler
#----------Prefetch_Handler:
#      B       Prefetch_Handler
#----------Abort_Handler:
#      B       Abort_Handler
#         NOP      /* Reserved vector */
#----------IRQ_Handler:
#      B       IRQ_Handler
#----------FIQ_Handler:
#      B       FIQ_Handler

################################################################################
# Reset Handler:
# the processor starts executing this code after system reset
################################################################################
Reset_Handler:
#
        MOV     sp, #0x4000      /*  set up stack pointer (r13) */
#
#  USING A .C FUNCTION
#
# FUNCTION CALL the parameters are stored in r0 and r1
# If there are 4 or less parameters when calling a C function the compiler
# assumes that they have been stored in r0-r3.
# If there are more parameters you have to store them in the data stack
# using the stack pointer
# function __c_copy is in copy.c

# function main is in prueba.c
.extern     main
        LDR     r3, = main
        MOV     lr, pc

# FUNCTION CALL the parameters are stored in r0 and r1
# If there are 4 or less parameters when calling a C function
# the compiler assumes that they have been stored in r0-r3.
# If there are more parameters you have to store them
# in the data stack using the stack pointer
        BX      r3
stop_pruebas:
        B       stop_pruebas        /*  end of program */

#####################################
        LDR     r0, =cuadricula  /*  puntero a la @ inicial de la cuadricula */

/*.extern     sudoku9x9
        ldr         r5, = sudoku9x9
        mov         lr, pc
        bx          r5*/
.global sudoku_candidatos_init_arm
sudoku_candidatos_init_arm:
        mov         r6,#0           /* celdas vacias */
        ldr         r3,=mascara     /* mascara */
        ldr         r3,[r3]
        mov         r1,#0           /* f */
        mov         r2,#0           /* c */
buc1:
        cmp         r1,#288         //compara la fila con 288 (32*9)
        beq         finbuc1         //(f=9)
buc2:
        cmp         r2,#18          //compara la columna con 18 (2*9)
        beq         finbuc2         //(c=9)
        add         r4,r1,r2        //r4=[f][c]
        ldrh        r5,[r0,r4]      //r5=celda[f][c]
        orr         r5,r3,r5        //r5=celda[f][c] | mascara
        strh        r5,[r0,r4]      //celda[f][c] = r5
        add         r2,r2,#2        //c++
        b           buc2
finbuc2:
        add         r1,r1,#32       //f++
        mov         r2,#0           //c=0
        b           buc1
finbuc1:
        mov         r1,#0           //f=0
buk1:
        cmp         r1,#288         //compara la fila con 288 (32*9)
        beq         finbuk1         //(f=9)
buk2:
        cmp         r2,#18          //compara la columna con 18 (2*9)
        beq         finbuk2         //(c=9)
        add         r4,r1,r2        //r4=[f][c]
        ldrh        r5,[r0,r4]      //r5=celda[f][c]
        and         r5,r5,#15       //r5=valor_celda
        cmp         r5,#0           //compara valor con 0
        addeq       r6,r6,#1        //(celdas_vacias++)
        beq         nay             //(valor_celda=0)
        push        {r0-r10}        //guardar contexto
        ADR         r3, sudoku_candidatos_propagar_thumb+1 /* the last address bit is not really used to specify the address but to select between ARM and Thumb code */
        ADR         r14,return       /* we store the return address in r14 */
        BX          r3
return:
        pop         {r0-r10}        //restablecer contexto
nay:
        add         r2,r2,#2        //c++
        b           buk2
finbuk2:
        add         r1,r1,#32       //f++
        mov         r2,#0           //c=0
        b           buk1
finbuk1:
        mov         r0,r6           //return celdas_vacias
        bx          r14


.global sudoku_candidatos_propagar_arm
sudoku_candidatos_propagar_arm:
        add         r3,r2,r1                //r3=[f][c]
        ldrh        r4,[r0,r3]              //r4=celda[f][c]
        and         r4,r4,#15               //r4=valor de celda
        add         r5,r4,#3                //r5=valor+3
        mov         r6,#1                   //r6=1 (preparar operandos para mascara)
        mvn         r5,r6,LSL r5            //r5=mascara
        mov         r6,#192                 //r6=fila0=192=(32*6)
        cmp         r1,r6                   //(comparar fila con 6)*32
        bge         fila0                   //(f>=192)
        mov         r6,#96                  //r6=fila0=96=(32*3)
        cmp         r1,r6                   //(f>=64)
        movlt       r6,#0                   //(r6=fila0=0)
fila0:
        mov         r7,#12                  //r7=column0=12=(2*6)
        cmp         r2,r7                   //(comparar columna con 6)*2
        bge         column0                 //(c>=12)
        mov         r7,#6                   //r7=column0=6=(2*3)
        cmp         r2,r7                   //(c>=6)
        movlt       r7,#0                   //(r7=column0=0)
column0:
        mov         r3,#0                   //r3=ifila=0
        mov         r4,#0                   //r4=icolumna=0
        add         r8,r0,r1                //r8=celda[fila][i]
        add         r9,r0,r2                //r9=celda[i][columna]
buck:
        cmp         r3,#288                 //compara la fila con 288 (32*9)
        beq         finbuck                 //(f=9)
        ldrh        r10,[r8,r4]             //r10=contenido de la celda [fila][i]
        and         r10,r10,r5              //r10=celda[fila][i] & mascara
        strh        r10,[r8,r4]             //celda[fila][i]=celda[fila][i] & mascara
        ldrh        r10,[r9,r3]             //r10=contenido de la celda [i][columna]
        and         r10,r10,r5              //r10=celda[i][columna] & mascara
        strh        r10,[r9,r3]             //celda[i][columna]=celda[i][columna] & mascara
        add         r3,r3,#32               //ifilas++
        add         r4,r4,#2                //icolumnas++
        b           buck
finbuck:
        mov         r3,r6                   //r3=fila_0=f
        add         r6,r6,#96               //fila_0=fila_0+3
buc:
        cmp         r3,r6                   //compara fila con fila_0+3
        bge         finbuc                  //fila>=fila_0+3
        mov         r4,r7                   //r4=columna_0=c
        add         r8,r7,#6                //r8=columna_0+3
        add         r9,r0,r3                //r9=celda[fila_0][0]
bux:
        cmp         r4,r8                   //compara columna_0 con columna_0+3
        bge         finbux                  //columna_0>=columna_0+3
        ldrh        r10,[r9,r4]             //r10=celda[f][c]
        and         r10,r10,r5              //r10=celda[f][c] & mascara
        strh        r10,[r9,r4]             //celda[f][c]=celda[f][c] & mascara
        add         r4,r4,#2                //c++
        b           bux
finbux:
        add         r3,r3,#32               //f++
        b           buc
finbuc:
        bx          r14                     //return


stop:
        B       stop        /*  end of program */
################################################################################
.global sudoku_candidatos_propagar_thumb
sudoku_candidatos_propagar_thumb:
.thumb
        add         r3,r2,r1                //r3=[f][c]
        ldrh        r4,[r0,r3]              //r4=celda[f][c]
        mov         r5,#15                  //r5=0x000F
        and         r4,r4,r5                //r4=valor de celda
        add         r5,r4,#3                //r5=valor+3
        mov         r6,#1                   //r6=1 (preparar operandos para mascara)
        lsl         r6,r6,r5
        mvn         r5,r6                   //r5=mascara
        mov         r3,#0                   //r3=ifila=0
        mov         r4,#0                   //r4=icolumna=0
bucx:
        cmp         r4,#18
        beq         finbucx                 //(i=9)
        add         r6,r0,r1                //r6=celda[fila][i]
        ldrh        r7,[r6,r4]              //r10=contenido de la celda [fila][i]
        and         r7,r7,r5                //r10=celda[fila][i] & mascara
        strh        r7,[r6,r4]              //celda[fila][i]=celda[fila][i] & mascara
        add         r6,r0,r2
        ldrh        r7,[r6,r3]              //r10=contenido de la celda [i][columna]
        and         r7,r7,r5                //r10=celda[i][columna] & mascara
        strh        r7,[r6,r3]              //celda[i][columna]=celda[i][columna] & mascara
        add         r3,#32                  //ifilas++
        add         r4,#2                   //icolumnas++
        b           bucx
finbucx:
        mov         r6,#192                 //r6=fila0=192=(32*6)
        cmp         r1,r6                   //(comparar fila con 6)*32
        bge         fil0                    //(f>=192)
        mov         r6,#96                  //r6=fila0=96=(32*3)
        cmp         r1,r6                   //(f>=64)
        bge         fil0
        mov         r6,#0                   //(r6=fila0=0)
fil0:
        mov         r7,#12                  //r7=column0=12=(2*6)
        cmp         r2,r7                   //(comparar columna con 6)*2
        bge         colu0                   //(c>=12)
        mov         r7,#6                   //r7=column0=6=(2*3)
        cmp         r2,r7                   //(c>=6)
        bge         colu0
        mov         r7,#0                   //(r7=column0=0)
colu0:
        mov         r1,r6                   //r1=fila_0=f
        add         r6,r6,#96               //fila_0=fila_0+3
        add         r3,r7,#6                //r3=columna_0+3
        add         r0,r0,r1                //r0=celda[fila_0][0]
        add         r0,r0,r7                //r0=celda[fila_0][columna_0]
col:
        cmp         r1,r6                   //compara fila con fila_0+3
        bge         fincol                  //fila>=fila_0+3
        mov         r2,r7                   //r2=columna_0=c
bus:
        cmp         r2,r3                   //compara columna_0 con columna_0+3
        bge         finbus                  //columna_0>=columna_0+3
        ldrh        r4,[r0]                 //r4=celda[f][c]
        and         r4,r4,r5                //r10=celda[f][c] & mascara
        strh        r4,[r0]                 //celda[f][c]=celda[f][c] & mascara
        add         r2,#2                   //c++
        add         r0,#2
        b           bus
finbus:
        add         r1,#32                  //f++
        add         r0,#26
        b           col
fincol:
        bx          r14                     //return

################################################################################
.data

.ltorg

.align 5    /* guarantees 32-byte alignment (2^5) */

# huecos para cuadrar
cuadricula:
     /* 9 filas de 16 entradas para facilitar la visualizacion, 16 bits por celda */
    .hword   0x8005,0x0000,0x0000,0x8003,0x0000,0x0000,0x0000,0x0000,0x0000,0,0,0,0,0,0,0
    .hword   0x0000,0x0000,0x0000,0x0000,0x8009,0x0000,0x0000,0x0000,0x8005,0,0,0,0,0,0,0
    .hword   0x0000,0x8009,0x8006,0x8007,0x0000,0x8005,0x0000,0x8003,0x0000,0,0,0,0,0,0,0
    .hword   0x0000,0x8008,0x0000,0x8009,0x0000,0x0000,0x8006,0x0000,0x0000,0,0,0,0,0,0,0
    .hword   0x0000,0x0000,0x8005,0x8008,0x8006,0x8001,0x8004,0x0000,0x0000,0,0,0,0,0,0,0
    .hword   0x0000,0x0000,0x8004,0x8002,0x0000,0x8003,0x0000,0x8007,0x0000,0,0,0,0,0,0,0
    .hword   0x0000,0x8007,0x0000,0x8005,0x0000,0x8009,0x8002,0x8006,0x0000,0,0,0,0,0,0,0
    .hword   0x8006,0x0000,0x0000,0x0000,0x8008,0x0000,0x0000,0x0000,0x0000,0,0,0,0,0,0,0
    .hword   0x0000,0x0000,0x0000,0x0000,0x0000,0x8002,0x0000,0x0000,0x8001,0,0,0,0,0,0,0

mascara:
    .hword  0x1FF0
.end
#        END
