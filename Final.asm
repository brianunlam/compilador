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
	_1	dd	1.000000
	_3	dd	3.000000
	_2	dd	2.000000

.CODE
START:

	MOV AX, @DATA

	MOV DS, AX


;Comienzo codigo de usuario

	fld _1
	fstp @a
	fld _3
	fstp @b
	fld _2
	fstp @c

;finaliza el asm
 	mov ah,4ch
	mov al,0
	int 21h


END START