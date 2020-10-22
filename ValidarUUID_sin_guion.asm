.model small
.data
	validaruiid db '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
	msg db 'El uuid es valido $'
	msgcaracter db 0
	msg2 db 'El uuid no es valido$'
	booluiidvalido db 1h
	msgIngreseuiid db 'Ingrese el uuid a validar$'
	opcion1 db '1) Generar uuid$'
	opcion2 db '2) Generar varios uuid$'
	opcion3 db '3) Validar un uuid$'
	opcion4 db '4) Salir del programa$'


.stack
.code
main:
	Opciones:
	XOR AX,AX
	MOV Ax, @data ; Mover variables a data segment
	MOV DS, AX 
	
	MOV DX, offset opcion1 ;Imprimir opcion 1
	MOV AH,09h
	INT 21h
	
	CALL NuevaLinea
	
	MOV DX, offset opcion2 ;Imprimir opcion 2
	MOV AH,09h
	INT 21h
	
	CALL NuevaLinea
		
	MOV DX, offset opcion3 ;Imprimir opcion 3
	MOV AH,09h
	INT 21h
	
	CALL NuevaLinea
	
	MOV DX, offset opcion4 ;Imprimir opcion 4
	MOV AH,09h
	INT 21h
	
	CALL NuevaLinea
	
	XOR AX,AX ;Recibir entrada de usuario
	MOV AH,01h
	INT 21h
	
	CMP AL,31h; comparar para saltar a opcion 
	jz PrimeraOpcion
	CMP AL,32h
	jz SegundaOpcion
	CMP AL,33h
	jz TerceraOpcion
	CMP AL,34h
	jz CuartaOpcion
	
	PrimeraOpcion:
	
	SegundaOpcion:
	
	TerceraOpcion:; Validar UUID
	CALL NuevaLinea
	call Validaruiidp
	JMP Opciones
	
	CuartaOpcion:
	MOV AH,4Ch ;Terminar programa
	INT 21h
	
	;PROCEDIMIENTO PARA INSERTAR NUEVA LINEA EN BLANCO
	NuevaLinea proc
	MOV dl, 0Ah; Salto de linea
	MOV ah,02h
	INT 21h
	ret
	NuevaLinea endp
	;_________________________________________________
	
	;PROCEDIMIENTO PRINCIPAL PARA VALIDAD UUID
	Validaruiidp proc
	MOV booluiidvalido,01h
	
	MOV DX, offset msgIngreseuiid ;Pedir que ingrese un UUID
	MOV AH,09h
	INT 21h
	
	CALL NuevaLinea
	
	LEA DI,validaruiid; indexar validaruiid	
	MOV CX,32 
	AgregarValor:; Agregar los caracteres a la cadena
		call AgregarCadValuiid
	LOOP AgregarValor
	
	CALL NuevaLinea
	
	XOR AX,AX 
	LEA SI,validaruiid; Indexar cadena
	
	MOV CX,12 ;Comenzando a validar caracteres del uiid
	primergrp:
		call Validar0a9yAaF
	LOOP primergrp
	
	call Validar1
	
	MOV CX,3
	segundogrp:
		call Validar0a9yAaF
	LOOP segundogrp
	
	call Validar8a9yAaB
	
	MOV CX,15
	tercergrp:
		call Validar0a9yAaF
	LOOP tercergrp; Terminando de validar UUID
							
	CMP booluiidvalido,01h ;Si es 1 imprimir valido si es 0 no valido
	jz ImprimirSi
	jnz ImprimirNo
	
	ImprimirSi:
	MOV DX,OFFSET msg
	mov ah, 09h
	int 21h
	jmp ConcluirValidacion
	
	ImprimirNo:
	MOV DX,OFFSET msg2
	mov ah, 09h
	int 21h
	jmp ConcluirValidacion
	
	ConcluirValidacion:
	
	CALL NuevaLinea
	CALL NuevaLinea
	
	ret
	Validaruiidp endp
	;_________________________________________________
	
	;Procedimiento para ingresar caracteres a la cadena cuando ingrese el usuario
	AgregarCadValuiid proc
		
		XOR AX,AX ; Pedir caracter
		MOV AH,01h
		INT 21h
	
		MOV [DI],AL; mover caracter a cadena
	
		INC DI;mover puntero a derecha
	RET
	AgregarCadValuiid endp 
	;_________________________________________________
	
	; PROCEDIMIENTO PARA VALIDAR 1 
	Validar1 proc
		MOV AL,[SI] ; COMPARAR SI ES 1
		CMP AL,31h
		JZ Es_uno
		JNZ No_es_uno
	
		Es_uno:; si es uno no hace nada
			jmp TerminarProc2 
	
		No_es_uno:; No es uno cambia bool a 0
			MOV booluiidvalido,0h
	
		TerminarProc2:
			INC SI
			XOR AX,AX
			
		RET	
	Validar1 endp
	
	
	
	
	;PROCEDIMIENTO PARA VALIDAR DE 0 15 EN HEX
	Validar0a9yAaF proc
			MOV AL,[SI]
	
			CMP AL,40h
			JZ No_es_valido
			JC Menor_a_9
			JNC Mayor_igual_a_10
	
		Menor_a_9: ; Es menor a nueve ahora comparar que sea mayor que 0
			CMP AL,30h
			JNC Es_valido
			JMP No_es_valido
	
		Mayor_igual_a_10:; Es mayor que nueve ahora comparar que sea menor a 16
			CMP AL,47h
			JC Es_valido
			JMP No_es_valido
	
		Es_valido: ; Es valido entre 0 y 15
			JMP TerminarProc1
	
			;MOV DX,OFFSET msg
			;mov ah, 09h
			;int 21h
			;jmp TerminarProc1
	
		No_es_valido: ;el caracter no es valido
			MOV booluiidvalido,0h
	
			;MOV DX,OFFSET msg2
			;mov ah, 09h
			;int 21h
			;jmp TerminarProc1
	
		TerminarProc1:
			INC SI
			XOR AX,AX
			ret
	Validar0a9yAaF endp
	;_________________________________________________
	
	
	;PROCEDIMIENTO PARA VALIDAR DE 8-9 Y A-B
	Validar8a9yAaB proc 
			MOV AL,[SI]
	
			CMP AL,40h
			JZ No_esvalido
			JC Menor_a10
			JNC Mayor_igual_a10
	
		Menor_a10: ; Es menor a nueve ahora comparar que sea mayor que 7
			CMP AL,38h
			JNC Es_valido
			JMP No_es_valido
	
		Mayor_igual_a10:; Es mayor que nueve ahora comparar que sea menor a 16
			CMP AL,43h
			JC Esvalido
			JMP No_esvalido
	
		Esvalido: ; Es valido entre 0 y 15
			JMP TerminarProc3
	
		No_esvalido: ;el caracter no es valido
			MOV booluiidvalido,0h
	
		TerminarProc3:
			INC SI
			XOR AX,AX
			ret
	
	Validar8a9yAaB endp
	;_________________________________________________
end main