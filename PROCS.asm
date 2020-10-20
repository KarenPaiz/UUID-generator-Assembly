.model small
.data
	
	CADENA1 DB '10$'
	CADRESUL DB '10', 50 DUP ('$') 
	A1 DW ?
	A2 DW ?
.stack
.code
programa:
;iniciar programa
	mov ax, @data
	mov ds, ax

	XOR DI, DI
	XOR SI, SI
	LEA SI, CADRESUL
	LEA DI, CADENA1
CALL PROCESUMA

mov dx, offset CADRESUL
mov ah, 09h
int 21h


JMP FIN

PROCESUMA proc near
	MOV A1, 0
	MOV A2, 0
	MOV A1, SI
	MOV A2, DI
	DEC A1
	DEC A2
	MOV BP, SP
FINS1:
	XOR BL, BL 
	MOV BL , [SI]
	CMP BL,36
	JE FINS2
	INC SI
	JMP FINS1
FINS2:
	XOR BL, BL
	MOV BL , [DI]
	CMP BX, 36
	JE FSUM
	INC DI
	JMP FINS2
FSUM: 
	DEC DI
	DEC SI
	XOR BX, BX
CONTSUM:
	XOR DX, DX
	XOR AX, AX
	XOR CX, CX
	CMP SI, A1
	JNE NOTEQUAL0SS
	MOV DL, 0h 
	JMP CONTINUA1S
NOTEQUAL0SS:
	MOV DL, [SI]
	DEC SI
	SUB Dl, 30h
CONTINUA1S:	
	CMP DI, A2
	JNE NOTEQUAL0SD
	MOV AL, 0h 
	JMP CONTINUA2S
NOTEQUAL0SD:
	MOV AL, [DI]
	DEC DI
	SUB Al, 30h
CONTINUA2S:
	ADD AX, DX
	ADD AX, BX
	XOR BX, BX
	CMP AX, 9h
	JLE	CONTINUA3S
CONTINUA5S:	
	SUB AX, 10
	INC BX
	CMP AX, 9h
	JG CONTINUA5S
CONTINUA3S:
	ADD AX, 30h
	PUSH AX
	CMP DI, A2
	JG CONTSUM
	CMP SI, A1
	JG CONTSUM
	ADD BX, 30h
    PUSH BX
	MOV DI, 0
CONTINUA4S:
	POP AX
	CMP AX, 30h
	JE CONTINUA4S
	PUSH AX
CONTINUA6S:	
	POP AX
	MOV CADRESUL[DI], AL
	INC DI
	CMP BP, SP
	JNE CONTINUA6S
	MOV AL, 24h
	MOV CADRESUL[DI], AL
RET
PROCESUMA ENDP


	

FIN:	
;finalizar programa
	mov ah, 4ch
	int 21h
END programa
	