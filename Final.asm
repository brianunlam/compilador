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
	_2	dd	2.000000
	_101	dd	101.000000
	_901	dd	901.000000
	_102	dd	102.000000
	_103	dd	103.000000
	_903	dd	903.000000
	_104	dd	104.000000

.CODE
START:

	MOV AX, @DATA

	MOV DS, AX


;Comienzo codigo de usuario

	fld _1
	fstp @a
	fld _2
	fstp @b
	fld _1
	fstp @c
	fld @b
	fcomp @a
	fstsw AX
	sahf
	JNAE @@etiq1
	fld _101
	fstp @y
@@etiq1:
	fld @a
	fcomp @b
	fstsw AX
	sahf
	JNAE @@etiq2
	fld _901
	fstp @y
@@etiq2:
	fld @c
	fcomp @a
	fstsw AX
	sahf
	JNAE @@etiq3
	fld _102
	fstp @y
@@etiq3:
	fld @a
	fcomp @b
	fstsw AX
	sahf
	JNBE @@etiq4
	fld _103
	fstp @y
@@etiq4:
	fld @b
	fcomp @a
	fstsw AX
	sahf
	JNBE @@etiq5
	fld _903
	fstp @y
@@etiq5:
	fld @c
	fcomp @a
	fstsw AX
	sahf
	JNBE @@etiq6
	fld _104
	fstp @y
@@etiq6:

;finaliza el asm
 	mov ah,4ch
	mov al,0
	int 21h


END START