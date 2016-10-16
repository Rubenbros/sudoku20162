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
        LDR     r0, =cuadricula  /*  puntero a la @ inicial de la cuadricula */

.extern     sudoku9x9
        ldr         r5, = sudoku9x9
        mov         lr, pc
        bx          r5

sudoku_candidatos_init_arm:
        mov         r3,#0x1FF0      /* mascara */
        mov         r4,#0           /* f */
        mov         r5,#0           /* c */
buc1    cmp         r4,#144
        beq         finbuc1
buc2    cmp         r5,#18
        moveq       r5,#0
        beq         finbuc2
        add         r6,r4,r5
        ldr         r7,[r0+r6]
        orr         r7,r6,r3
        str         r7,[r0+r6]
        add         r5,r5,#2
        b           buc2
finbuc2 add         r4,r4,#32
        mov         r5,#0
        b           buc1
finbuc1 mov         r4,#0
buk1    cmp         r4,#144
        beq         finbuk1
buk2    cmp         r5,#18
        moveq       r5,#0
        beq         finbuk2
        add         r6,r4,r5
        ldr         r7,[r0+r6]
        and         r7,r7,#15
        cmp         r7,#0
        
        
stop:
        B       stop        /*  end of program */

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

.end
#        END
