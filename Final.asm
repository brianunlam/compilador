include macros2.asm
include number.asm
.MODEL LARGE
.386
.STACK 200h

.DATA
	MAXTEXTSIZE equ 50
 	__flags dw ? 
	__descar dd ? 
	oldcw dw ? 
	__auxConc db MAXTEXTSIZE dup (?), '$'
	__resultConc db MAXTEXTSIZE dup (?), '$'
	msgPRESIONE db 0DH, 0AH,'Presione una tecla para continuar...','$'
	_newLine db 0Dh, 0Ah,'$'
vtext db 100 dup('$')
 
;Declaracion de variables de usuario
	@a	dd	?
	@b	dd	?
	@c	dd	?
	@y	dd	?
	@d	db	MAXTEXTSIZE dup (?),'$'
	@pri	db	MAXTEXTSIZE dup (?),'$'
	@ccc	db	MAXTEXTSIZE dup (?),'$'
	@laf	db	MAXTEXTSIZE dup (?),'$'
	@seg	db	MAXTEXTSIZE dup (?),'$'
	_concatena_dos_cadenas	db	'Concatena dos cadenas','$',28 dup (?)
	_hola	db	'Hola','$',45 dup (?)
	__mundo_	db	' mundo!','$',42 dup (?)
	_solo_los_impares_usando_mod	db	'Solo los impares usando MOD','$',22 dup (?)
	_0	dd	0.000000
	_10	dd	10.000000
	_2	dd	2.000000
	_1	dd	1.000000

.CODE
START:

	MOV AX, @DATA

	MOV DS, AX

	MOV ES, AX


;Comienzo codigo de usuario


	LEA DX, _concatena_dos_cadenas 
	MOV AH, 9
	INT 21H
	newline
	MOV SI, OFFSET _hola
	MOV DI, OFFSET @pri
	call COPIAR
	MOV SI, OFFSET __mundo_
	MOV DI, OFFSET @ccc
	call COPIAR
	MOV SI, OFFSET @pri
	MOV DI, OFFSET __auxConc
	CALL COPIAR
	MOV SI, OFFSET @ccc
	MOV DI, OFFSET __auxConc
	CALL CONCAT
	MOV SI, OFFSET __auxConc
	MOV DI, OFFSET @seg
	CALL COPIAR

	LEA DX, @seg 
	MOV AH, 9
	INT 21H
	newline

	LEA DX, _solo_los_impares_usando_mod 
	MOV AH, 9
	INT 21H
	newline
	fld _0
	fstp @a
@@etiq1:
	fld _10
	fcomp @a
	fstsw AX
	sahf
	JNA @@etiq2
	fld _2
	fld @a
ParialLp:	fprem1
	fstsw ax
	test ah, 100b
	jnz ParialLp
	fabs
	fstp @b
	fld _0
	fcomp @b
	fstsw AX
	sahf
	JNB @@etiq3
	displayFloat @a, 2
	newline
@@etiq3:
	fld _1
	fld @a
	fadd St(0),St(1)
	fstp @a
	jmp @@etiq1
@@etiq2:

;finaliza el asm
 	mov ah,4ch
	mov al,0
	int 21h

STRLEN PROC NEAR
	mov BX,0

STRL01:
	cmp BYTE PTR [SI+BX],'$'
	je STREND
	inc BX
	jmp STRL01

STREND:
	ret

STRLEN ENDP

COPIAR PROC NEAR
	call STRLEN
	cmp BX,MAXTEXTSIZE
	jle COPIARSIZEOK
	mov BX,MAXTEXTSIZE

COPIARSIZEOK:
	mov CX,BX
	cld
	rep movsb
	mov al,'$'
	mov BYTE PTR [DI],al
	ret

COPIAR ENDP

CONCAT PROC NEAR
	push ds
	push si
	call STRLEN
	mov dx,bx
	mov si,di
	push es
	pop ds
	call STRLEN
	add di,bx
	add bx,dx
	cmp bx,MAXTEXTSIZE
	jg CONCATSIZEMAL

CONCATSIZEOK:
	mov cx,dx
	jmp CONCATSIGO

CONCATSIZEMAL:
	sub bx,MAXTEXTSIZE
	sub dx,bx
	mov cx,dx

CONCATSIGO:
	push ds
	pop es
	pop si
	pop ds
	cld
	rep movsb
	mov al,'$'
	mov BYTE PTR [DI],al
	ret

CONCAT ENDP
END START; final del archivo. 
