.model small
.data
	texto1 DB 'VOY A COPIAR ESTE TEXTO$', 25 DUP ('$')
	textO2 DB 'voy a borrar este texto$', 25 DUP ('$')
	texto3 DB '123456$', 25 DUP ('$')
	texto4 DB '789$', 25 DUP ('$')
.stack
.code
.386
programa:
;iniciar programa
	mov ax, @data
	mov ds, ax
	

	mov dx, offset texto2
	mov ah, 09h
	int 21h
	;salto de linea
	MOV DL, 0Ah
	MOV AH, 02h
	int 21h
XOR DI, DI
XOR SI, SI
LEA DI, texto1
LEA SI, texto2
CALL CopSTR
	mov dx, offset texto2
	mov ah, 09h
	int 21h
	;salto de linea
	MOV DL, 0Ah
	MOV AH, 02h
	int 21h
	;salto de linea
	MOV DL, 0Ah
	MOV AH, 02h
	int 21h
	
	
JMP FIN

CopSTR proc near
;COPIA DE DI A SI
CS1:
	XOR AX, AX
	MOV AX, [DI]
	MOV [SI], AX
	CMP AL, 36
	JE CS2
	INC DI
	INC SI
	JMP CS1
CS2:
RET
CopSTR endp

FIN:
;finalizar programa
	mov ah, 4ch
	int 21h
END programa
	