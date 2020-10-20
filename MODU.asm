.model small
.data
	texto1 DB '6500000$'
	texto2 DB '4987100$'
	texto3 DB '0009800$'
	numMod DW 0h
	contMod DB 4
.stack
.code
.386
programa:
;iniciar programa
	mov ax, @data
	mov ds, ax
XOR DI, DI
LEA DI, texto1
CALL MODULO
;salto de linea
	MOV DL, 0Ah
	MOV AH, 02h
	int 21h
XOR DI, DI
MOV contMod, 4
LEA DI, texto2
CALL MODULO
;salto de linea
	MOV DL, 0Ah
	MOV AH, 02h
	int 21h
XOR DI, DI
MOV contMod, 4
	LEA DI, texto3
CALL MODULO
;salto de linea
	MOV DL, 0Ah
	MOV AH, 02h
	int 21h
JMP FIN

MODULO PROC NEAR
	
	XOR AX, AX
	MOV AL, [DI]
	SUB AX, 30H 
	MOV numMod, AX
	CMP AX, 6h
	JB MOD1
	SUB AX, 4H 
	MOV numMod, AX
	xor dx, dx
MOD1:
	XOR AX ,AX 
	MOV AX, numMod
	xor bx, bx
	MOV BX, 10
	MUL BX
	MOV numMod, AX
	XOR AX, AX
	INC DI
	MOV Al, [DI]
	SUB AX, 30H
	ADD numMod, Ax
	DEC contMod
	CMP contMod, 0
	JA MOD1

	xor bx, bx
	MOV AX, numMod
	MOV BX, 16
	DIV BX
	ADD DX, 30H
RET
MODULO ENDP

FIN:
	;finalizar programa
	mov ah, 4ch
	int 21h
END programa