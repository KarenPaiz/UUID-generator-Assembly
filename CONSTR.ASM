.model small
.data
	numero DW 5678
	numero1 dw 0056
	numero2 dw 10000
	texto2 DB 25 DUP ('$')

.stack
.code
.386
programa:
;iniciar programa
	mov ax, @data
	mov ds, ax
	

XOR SI, SI
XOR DI, DI
LEA SI, texto2
LEA DI, texto2
XOR AX, AX
MOV AX, numero
CALL ConvertSTR

	mov dx, offset texto2
	mov ah, 09h
	int 21h
	;salto de linea
	MOV DL, 0Ah
	MOV AH, 02h
	int 21h

XOR SI, SI
XOR DI, DI
LEA SI, texto2
LEA DI, texto2
XOR AX, AX
MOV AX, numero1
CALL ConvertSTR

	mov dx, offset texto2
	mov ah, 09h
	int 21h
	;salto de linea
	MOV DL, 0Ah
	MOV AH, 02h
	int 21h
	XOR SI, SI
XOR DI, DI
LEA SI, texto2
LEA DI, texto2
XOR AX, AX
MOV AX, numero2
CALL ConvertSTR

	mov dx, offset texto2
	mov ah, 09h
	int 21h
	;salto de linea
	MOV DL, 0Ah
	MOV AH, 02h
	int 21h
JMP FIN

ConvertSTR proc near
	;GUARDA EN SI
	MOV bx, 0Ah
	MOV BP, SP
CSTR1:
	XOR DX, DX
	DIV BX
	ADD DX, 30H
	PUSH DX
	INC SI
	CMP AX, 0
	JNE CSTR1
	
CSTR2:
	XOR AX, AX
	POP AX
	MOV [DI], Al
	INC DI
	CMP BP, SP
	JNE CSTR2
	XOR DX, DX
	MOV DL, 36
	MOV [DI], Dl
RET
ConvertSTR endp

	
FIN:
;finalizar programa
	mov ah, 4ch
	int 21h
END programa
	