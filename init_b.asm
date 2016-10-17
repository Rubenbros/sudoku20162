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
        mov         r6,#0     		/* celdas vacias */
        mov			r3,#0x1FF0		/* mascara */
        mov         r1,#0           /* f */
        mov         r2,#0           /* c */
buc1    cmp         r1,#288
        beq         finbuc1
buc2    cmp         r1,#18
        moveq       r2,#0
        beq         finbuc2
        add         r4,r1,r2
        ldr         r5,[r0+r4]
        orr         r5,r4,r6
        str         r5,[r0+r4]
        add         r2,r2,#2
        b           buc2
finbuc2 add         r1,r1,#32
        mov         r2,#0
        b           buc1
finbuc1 mov         r1,#0
buk1    cmp         r1,#288
        beq         finbuk1
buk2    cmp         r2,#18
        moveq       r2,#0
        beq         finbuk2
        add         r4,r1,r2
        ldr         r5,[r0+r4]
        and         r5,r5,#15
        cmp         r5,#0
        pushne		{r3-r6}
        blne		sudoku_candidatos_propagar_arm
        popne		{r3-r6}
        addeq		r6,r6,#1
        b           buc2
finbuk2 add         r1,r1,#32
        mov         r2,#0
        b           buc1
finbuk1 bx

sudoku_candidatos_propagar_arm:
		add			r3,r2,r1
		ldr			r4,[r0+r3]
		and			r4,r4,#15				/*r4=valor de celda*/
		add			r5,r4,#3				/*r5=valor+3*/
		mov			r6,#1
		mvn			r5,r6 LSL r5			/*r5=mascara*/
		mov			r6,#5
		cmp			r6,r1 LSR #5
		movhi		r6,#6					/*r6=fila_0*/
		bhi			fila0			
		cmp			r6,r1 LSR #5
		movhi		r6,#3
		bhi			fila0
		mov			r6,#0
fila0	mov			r7,#5
		cmp			r7,r2 LSR #1
		movhi		r7,#6					/*r7=columna_0*/
		bhi			column0			
		cmp			r7,r2 LSR #1
		movhi		r2,#3
		bhi			column0
		mov			r7,#0	
column0	mov			r8,#0					//r8=i=0
buc		cmp			r8,#9
		beq			finbuck
		add			r9,r0,r1				//r9=primera columna de fila en r1
		ldr			r9,[r9,+r8,LSL #1]		//r9=contenido de la celda [fila][i]

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
