.MODEL LARGE
.386
.STACK 200h

.DATA
	MAXTEXTSIZE equ 50
 	__result dd ? 
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
	@d	db	MAXTEXTSIZE dup (?),'$'
	_1	dd	1.000000
	_2	dd	2.000000
	_hola_mundo	db	'hola mundo','$',39 dup (?)
