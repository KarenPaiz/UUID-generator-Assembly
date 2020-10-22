.model small
.data
	textoMen DB 'Ingrese la opción del menu deseada$',0Ah
	OpcionesMen DB '1. Generar un UUID $',0Ah, '2. Generar varios UUID $',0Ah,'3. Validar un UUID $',0Ah,'4. Salir del programa$',0Ah
	ErrorMensaje DB 'Opción incorrecta del menú, elija de nuevo $',0Ah
	FinMensaje DB 'Gracias por usar.$'
	CantUUID DW ?
	AÑO DW ?
	MES DB ?
	DIA DB ?
	HORA DW ?
	MIN DW ?
	SEGS DW ?
	CENTISEG DW ?
	DEFAULT DB '59918400000$'
	CONTDIAS DB 0
	CONTDIASSTR DB 80 DUP ('$')
	CADRESUL DB 250 DUP ('0'), '$'
	CENSEGXD DB 0h
	CENSEGXDstr DB 80 DUP ('$')
	SEGCONstr DB 80 DUP ('$')
	SEGCON DB 0h
	B DB '2531011$'
	q	dw 0
	r	dw 0
	ax_	dw	0
	bx_	dw	0
	cx_	dw	0
	dx_	dw	0
	MUL1 DB 80 DUP ('$')
	MUL2 DB '864$'
	numMod DW 0h
	contMod DB 4
	contImpri db 0h
.stack
.code
.386
programa:
	;iniciar programa
	mov ax, @data
	mov ds, ax
;-------------------------------------------MENU-------------------------------------
MENU:
;imprimir
	mov dx, offset textoMen
	mov ah, 09h
	int 21h
;imprimir
	mov dx, offset OpcionesMen
	mov ah, 09h
	int 21h
;leer opción
	mov ah, 01h    
	int 21h	
;opcion 1
	MOV Dl, 49
    CMP Al, Dl
	JE OPCION1
;opcion 2	
	MOV Dl, 50
    CMP Al, Dl
	JE OPCION2
;opcion 3
	MOV Dl, 51
    CMP Al, Dl
	JE OPCION3
;opcion 4	
	MOV Dl, 52
    CMP Al, Dl
	JE OPCION4
;opcion incorrecta del menu	
	mov dx, offset ErrorMensaje
	mov ah, 09h
	int 21h
	JMP MENU
	
;------------------------------------------OPCION1-----------------------------------
OPCION1:
	CALL GENUUID
;opcion  terminada	
	JMP MENU
;------------------------------------------OPCION2-----------------------------------
OPCION2:
	MOV CantUUID, ?
OP21:
	CALL GENUUID
	DEC CantUUID
	CMP CantUUID , 0h
;opcion  terminada	
	JMP MENU
;------------------------------------------OPCION3-----------------------------------
OPCION3:
;PENDIENTE
	JMP MENU
;------------------------------------------OPCION4-----------------------------------
OPCION4:
	mov dx, offset FinMensaje
	mov ah, 09h
	int 21h
	jmp FIN

FIN:	
	;finalizar programa
	mov ah, 4ch
	int 21h
;-------------------------------------GUARDAR REGISTROS-----------------------------------
GuardarRegs proc near
		mov ax_, AX
		mov bx_, BX
		mov cx_, CX
		mov dx_, DX
		ret
GuardarRegs endp
;-------------------------------------CARGAR REGISTROS GUARDADOS-----------------------------------
CargarRegs proc near
		mov ax, ax_
		mov bx, bx_
		mov cx, cx_
		mov dx, dx_
		ret
CargarRegs endp
;-------------------------------------LIMPIAR REGISTROS-----------------------------------
LimpiarRegs proc near
		xor ax, ax
		xor bx, bx
		xor cx, cx
		xor dx, dx
		XOR DI, DI
		XOR SI, SI
		ret
LimpiarRegs endp
;-------------------------------------COPIAR UN STRING A OTRA-----------------------------------
CopiarStrings proc near
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
CopiarStrings endp
;-------------------------------------MULTIPLICAION DE CADENAS-----------------------------------
Multiplicar proc near
	MOV R1,0
	MOV R2,0
	MOV CONT , 0h
	MOV CONT2 , 0h
	MOV CONT , 0h
	LEA SI, MUL1
	LEA DI, MUL2
	MOV BP, SP
	MOV R1, SI
	DEC R1
FINM1:
	XOR BL, BL 
	MOV BL , [DI]
	INC R2
	INC CONT
	CMP BL,36
	JE HOLA
	INC DI
	JMP FINM1
HOLA:
	DEC R2
	DEC CONT
	DEC DI
FINM2:
	XOR BX, BX
	MOV BL , [SI]
	CMP BX, 36
	JE FM
	INC SI
	JMP FINM2
FM: 
	DEC SI
	XOR BX, BX
CONTMUL:
	XOR DX, DX
	XOR AX, AX
	XOR CX, CX
	CMP SI, R1
	JNE NOTEQUAL0SM
	JMP FIN
NOTEQUAL0SM:
	MOV DL, [SI]
	DEC SI
	SUB Dl, 30h
	MOV DI , 0h
	ADD DI , ULTCONT
	MOV AL, MUL2[DI]
	SUB Al, 30h
	MUL DL 
	ADD AX, BX
	XOR BX, BX
	CMP AX, 9h
	JLE	CONTINUA3M
CONTINUA5M:	
	SUB AX, 10
	INC BX
	CMP AX, 9h
	JG CONTINUA5M
CONTINUA3M:
	ADD AX, 30h
	PUSH AX
	CMP SI, R1
	JG CONTMUL
	ADD BX, 30h
    PUSH BX
	CMP ULTCONT, 0h
	JE PRIMERO
	CMP ULTCONT , 1h
	JE SEGUNDO
	JMP TERCERO
PRIMERO:
	LEA SI, CAD1
	JMP CONTINUA4M
SEGUNDO:
	LEA SI, CAD2
	JMP CONTINUA4M
TERCERO:	
	LEA SI, CAD3
CONTINUA4M:
	POP AX
	MOV [SI], AX
	INC SI
	CMP BP, SP
	JNE CONTINUA4M
	MOV CONT2, 0
	DEC CONT
UNCERO:	
	MOV DL, CONT2
	CMP CONT, DL
	JE NADA
	INC CONT2
	MOV AX, 30h
	MOV [SI], AX
	INC SI
	JMP UNCERO
NADA:	
	INC ULTCONT
	MOV AX, 24h
	MOV [SI], AX
	
	MOV AUX1, DI
	MOV DI, AUX1
	DEC DI				
	LEA SI, MUL1
	mov DX, ULTCONT
	CMP DL, R2
	JNE FINM2
	MOV SI, 0h
	MOV DI, 0h
	LEA SI, CAD1
	LEA DI, CAD2
	CALL SUMAR
	MOV SI, 0h
	MOV DI, 0h
	LEA SI, CAD3
	LEA DI, CADRESUL
	CALL SUMAR
RET
Multiplicar endp
;-------------------------------------SUMA DE CADENAS-----------------------------------
Sumar proc near
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
Sumar endp
;-------------------------------------CONVERTIR UN NUMERO A UNA STRING-----------------------------------
ConvertStrings proc near
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
ConvertStrings endp
;-------------------------------------OBTENER EL MÓDULO 16 DE UNA CADENA-----------------------------------
METMOD proc near
	
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
METMOD endp
;-------------------------------------IMPRIMIR VALORES-----------------------------------
IMPRIMIR proc NEAR
;IMPRIME DX
	CMP contImpri, 8
	JE GUION
	CMP contImpri, 13
	JE GUION
	CMP contImpri, 18
	JE GUION
	CMP contImpri, 23
	JE GUION
	CMP contImpri, 14
	JE UNO
	JMP VALN
GUION:
	XOR AX, AX
	MOV AX, DX
	XOR DX, DX
	MOV DX, 45
	mov ah, 02h
	int 21h
	INC contImpri
	
	XOR DX, DX
	MOV DX, AX
	CALL VALHEX
	mov ah, 02h
	int 21h
	inc contImpri
	JMP NADA
UNO:
	XOR DX, DX
	MOV DX, 49
	mov ah, 02h
	int 21h
	INC contImpri
	JMP NADA
ESPECIAL:
	XOR AX, AX
	MOV AX, DX
	XOR BX, BX
	MOV BX, 4
	DIV BX
	ADD DX, 8
	ADD DX, 30h
	CALL VALHEX
	mov ah, 02h
	int 21h
	JMP NADA
VALN:
	CALL VALHEX
	mov ah, 02h
	int 21h
	inc contImpri
NADA:
	
RET
IMPRIMIR endp


;------------------------------------- CAMBIA DE VALOR A HEXADECIMAL----------------------------------
VALHEX proc NEAR
	;CAMBIA EL VALOR DE DX 
	CMP DX, 40h
	JE valA
	CMP DX, 41h
	JE valB
	CMP DX, 42h
	JE valC
	CMP DX, 43h
	JE valD
	CMP DX, 44h
	JE valE
	CMP DX, 45h
	JE valF
	JMP valSale
valA:
XOR DX, DX
	MOV DX, 65
	JMP valSale
valB:
XOR DX, DX
	MOV DX, 66
	JMP valSale
valC:
XOR DX, DX
	MOV DX, 67
	JMP valSale
valD:
XOR DX, DX
	MOV DX, 68
	JMP valSale
valE:
XOR DX, DX
	MOV DX, 69
	JMP valSale
valF:
XOR DX, DX
	MOV DX, 70
	JMP valSale
valSale:
RET
VALHEX endp

;-------------------------------------GENERADOR DE UN UUID-----------------------------------
GENUUID proc NEAR
	CALL LimpiarRegs
	mov contImpri, 0h
	mov ah, 2Ah
	int 21h
	MOV AÑO, CX
	MOV MES, DH
	MOV DIA, DL
	XOR CX, CX
	XOR DX, DX
	mov ah, 2Ch
	int 21h
	MOV HORA, CH
	MOV MIN, CL
	MOV SEGS, DH
	MOV CENTISEG, DL
	SUB AÑO, 2020
SALTO:
	CMP AÑO, 0
	JE SALTO2
	ADD CONTDIAS , 365
	JMP SALTO
	
	
SALTO2:
	CMP MES, 1
	JE SALTO3
	CMP MES, 2
	JE FEBRERO
	CMP MES, 3
	JE MARZO
	CMP MES, 4
	JE ABRIL
	CMP MES, 5
	JE MAYO
	CMP MES, 6
	JE JUNIO
	CMP MES, 8
	JE JULIO
	CMP MES, 9
	JE AGOSTO
	CMP MES, 10
	JE SEPTIEMBRE
	CMP MES, 11
	JE OCTUBRE
	CMP MES, 12
	JE NOVIEMBRE
FEBRERO:
	ADD CONTDIAS, 31
	JMP SALTO3
MARZO:
	ADD CONTDIAS, 59
	JMP SALTO3
ABRIL:
	ADD CONTDIAS, 90
	JMP SALTO3
MAYO:
	ADD CONTDIAS, 120
	JMP SALTO3
JUNIO:
	ADD CONTDIAS, 151
	JMP SALTO3
JULIO:
	ADD CONTDIAS, 181
	JMP SALTO3
AGOSTO:
	ADD CONTDIAS, 212
	JMP SALTO3
SEPTIEMBRE:
	ADD CONTDIAS, 243
	JMP SALTO3
OCTUBRE:
	ADD CONTDIAS, 273
	JMP SALTO3
NOVIEMBRE:
	ADD CONTDIAS, 304
	JMP SALTO3
SALTO3:
	MOV AL, DIA
	ADD CONTDIAS , AL
	SUB CONTDIAS, 1
	
	XOR SI, SI
	XOR DI, DI
	LEA SI , CONTDIASSTR
	LEA DI, CONTDIASSTR
	XOR AX, AX
	MOV AX, CONTDIAS
	CALL ConvertStrings ;EL NUMERO QUE ESTÁ EN AX A SI
	
	CALL LimpiarRegs
	MOV DI, CONTDIASSTR
	MOV SI, MUL1
	CALL CopiarStrings
	CALL LimpiarRegs
	CALL Multiplicar ;RESULTADO EN CADRESUL
	mov CENSEGXD, 0h
	MOV SEGCON, 0h
SALTO4:
	CMP HORAS, 0
	JE SALTO5
	ADD SEGCON, 360
	DEC HORAS
	JMP SALT04
SALTO5:
	CMP MIN , 0
	JE SALTO6
	ADD SEGCON, 6
	DEC MIN
	JMP SALT05
SALTO6:
	CMP SEGS , 0
	JE SALTO7
	ADD CENSEGXD, 100
	DEC SEGS
	JMP SALT06
SALTO7:
	XOR AX, AX
	MOV AX, CENTISEG
	ADD CENSEGXD, AX 
	
	CALL LimpiarRegs
	LEA SI, CENSEGXDstr
	LEA DI, CENSEGXDstr
	XOR AX, AX
	MOV AX, CENSEGXD
	CALL ConvertStrings 
	CALL LimpiarRegs
	LEA SI, SEGCONstr
	LEA DI, SEGCONstr
	XOR AX, AX
	MOV AX, SEGCON
	CALL ConvertStrings 
	

	CALL LimpiarRegs
	LEA DI SEGCONstr
	MOV AL, 24h
ADD0S1:
	INC DI
	cmp [DI], AL
	JNE ADD0S1
ADD0S2:
	XOR AX, AX
	MOV AX, 30H
	MOV [DI], AX
	INC DI
	MOV [DI], AX
	INC DI
	MOV [DI], AX
	INC DI
	XOR AX, AX
	MOV AX, 24h
	MOV [DI], AX
	CALL LimpiarRegs
	XOR DI, DI
	XOR SI, SI
	LEA SI, SEGCONstr
	LEA DI, CADRESUL
	CALL Sumar
	
	CALL LimpiarRegs
	XOR DI, DI
	XOR SI, SI
	LEA SI, CENSEGXDstr
	LEA DI, CADRESUL
	CALL Sumar
	
	CALL LimpiarRegs
	XOR DI, DI
	XOR SI, SI
	LEA SI, DEFAULT
	LEA DI, CADRESUL
	CALL Sumar
	
	CALL LimpiarRegs
	LEA DI, MUL2
	MOV AX, 57
	MOV [DI], AX
	INC DI
	MOV [DI], AX
	INC DI
	XOR AX, AX 
	MOV AX, 55
	MOV [DI], AX
	INC DI
	XOR AX, AX 
	MOV AX, 24H
	MOV [DI], AX
	MOV CX, 31
SALTO8:
	CALL LimpiarRegs
	XOR DI, DI
	LEA DI, CADRESUL
	CALL METMOD
	CALL IMPRIMIR
	CALL LimpiarRegs
	XOR DI, DI
	XOR SI, SI
	LEA DI, CADRESUL
	LEA SI, MUL1
	CALL Multiplicar
	
	CALL LimpiarRegs
	LEA SI, CADRESUL
	LEA DI, B
	CALL PROCESUMA
	LOOP SALTO8
RET
GENUUID ENDP


END programa	
	

