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
	_999	dd	999.000000

.CODE
START:

	MOV AX, @DATA

	MOV DS, AX


;Comienzo codigo de usuario

	fld _999
	fstp @a
	displayFloat @a, 2

;finaliza el asm
 	mov ah,4ch
	mov al,0
	int 21h


END START
