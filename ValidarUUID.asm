.model small
.data
	validaruiid db '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
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
		
	MOV DX, offset opcion3 ;Imprimir mensaje 3
	MOV AH,09h
	INT 21h
	
	CALL NuevaLinea
	
	MOV DX, offset opcion4 ;Imprimir opcion 4
	MOV AH,09h
	INT 21h
	
	CALL NuevaLinea
	
	XOR AX,AX ;Recibir entrada de usuario para opcion
	MOV AH,01h
	INT 21h
	
	CMP AL,31h ;El valor recibido indica que opcion realizar
	jz PrimeraOpcion
	CMP AL,32h
	jz SegundaOpcion
	CMP AL,33h
	jz TerceraOpcion
	CMP AL,34h
	jz CuartaOpcion
	
	PrimeraOpcion:
	
	SegundaOpcion:
	
	TerceraOpcion:
	CALL NuevaLinea
	call Validaruiidp
	JMP Opciones
	
	CuartaOpcion:
	MOV AH,4Ch ;Terminar programa
	INT 21h
	
	;PROCEDIMIENTO PARA INGRESAR LINEA EN BLANCO
	NuevaLinea proc
	MOV dl, 0Ah; 
	MOV ah,02h
	INT 21h
	ret
	NuevaLinea endp
	;____________________________________________
	
	;PROCEDIMIENTO PRINCIPAL PARA VALIDAR UN UUID
	Validaruiidp proc
	
	MOV booluiidvalido,01h 
	
	MOV DX, offset msgIngreseuiid ;pedir que ingrese el UUID
	MOV AH,09h
	INT 21h
	
	CALL NuevaLinea
	
	LEA DI,validaruiid; indexar validaruiid	
	
	MOV CX,36 ;Ciclo guarda los 36 caracteres del uiid 
	AgregarValor:
	call AgregarCadValuiid
	LOOP AgregarValor
	
	CALL NuevaLinea
	
	XOR AX,AX 
	
	LEA SI,validaruiid ;indexar uuid para validar
	MOV CX,8 ;Comenzando a validar caracteres del uiid por grupos
	PGP:
	call Validar0a9yAaF
	LOOP PGP
	
	CALL ValidarGuion
	
	MOV CX,4 
	SGP:
	call Validar0a9yAaF
	LOOP SGP
	
	CALL ValidarGuion
	Call Validar1
	
	MOV CX,3
	TGP:
		call Validar0a9yAaF
	LOOP TGP
	
	Call ValidarGuion
	call Validar8a9yAaB
	
	MOV CX,3
	CGP:
		call Validar0a9yAaF
	LOOP CGP
	
	Call ValidarGuion
	
	MOV CX,12
	QGP:
		call Validar0a9yAaF
	LOOP QGP
	
			;Terminando de validar grupos de uuid	
			
	CMP booluiidvalido,01h ;si es 1 al final del uiid es valido si es 0 no
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
	;____________________________________________
	
	
	;PROCEDIMIENTO PARA AGREGAR A LA CADENA EL UUID
	AgregarCadValuiid proc
		XOR AX,AX 
		MOV AH,01h; entrada de caracter
		INT 21h
	
		MOV [DI],AL; agregar el caracter a la cadena
	
		INC DI; incrementar la posicion
	RET
	AgregarCadValuiid endp 
	;____________________________________________
	
	;PROCEDIMIENTO PARA VALIDAR GUION
	ValidarGuion proc
	MOV AL,[SI] ; COMPARAR SI ES -
	CMP AL, 2Dh
	JZ EsGuion
	JNZ NoGuion
	
	EsGuion:;Si es guion no hacer nada
	jmp  TerminarProc4
	
	NoGuion:;No es guion cambiar a 0
	MOV booluiidvalido,0h

	TerminarProc4:	
			INC SI; Incrementar apuntador
			XOR AX,AX
	ret
	
	ValidarGuion endp
	;____________________________________________
	
	;PROCEDIMIENTO PARA VALIDAR 1
	Validar1 proc
		MOV AL,[SI] ; COMPARAR SI ES 1
		CMP AL,31h
		JZ Es_uno
		JNZ No_es_uno
	
		Es_uno: ;Es uno termina el procedimiento
			jmp TerminarProc2 
	
		No_es_uno:; No es uno cambiar bool a 0
			MOV booluiidvalido,0h
	
		TerminarProc2:
			INC SI
			XOR AX,AX
			
		RET	
	Validar1 endp
	;____________________________________________
	
	
	
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
	
		No_es_valido: ;el caracter no es valido
			MOV booluiidvalido,0h

		TerminarProc1:
			INC SI
			XOR AX,AX
			ret
	Validar0a9yAaF endp
;____________________________________________		
	
	
	;PROCEDIMIENTO PARA VALIDAR ENTRE 8-9 Y A-B
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
	;____________________________________________
end main