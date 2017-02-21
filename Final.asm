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
	_hola	db	'hola','$',45 dup (?)

.CODE
START:

	MOV AX, @DATA

	MOV DS, AX


;Comienzo codigo de usuario


	LEA DX, _hola 
	MOV AH, 9
	INT 21H

;finaliza el asm
 	mov ah,4ch
	mov al,0
	int 21h


END START