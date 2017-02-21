include macros2.asm
include number.asm
.MODEL LARGE
.386
.STACK 200h

.DATA
	MAXTEXTSIZE equ 50
 	__flags dw ? 
	__descar dd ? 
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
	_0	dd	0.000000
	_100	dd	100.000000
	_chupamela	db	'chupamela','$',40 dup (?)
	_1	dd	1.000000

.CODE
START:

	MOV AX, @DATA

	MOV DS, AX


;Comienzo codigo de usuario

	fld _0
	fstp @a
@@etiq1:
	fld _100
	fcomp @a
	fstsw AX
	sahf
	JNA @@etiq2

	LEA DX, _chupamela 
	MOV AH, 9
	INT 21H
	newline
	displayFloat @a, 2
	newline
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


END START