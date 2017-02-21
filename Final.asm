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
	@pri	db	MAXTEXTSIZE dup (?),'$'
	@ccc	db	MAXTEXTSIZE dup (?),'$'
	@laf	db	MAXTEXTSIZE dup (?),'$'
	@seg	db	MAXTEXTSIZE dup (?),'$'
	_bria	db	'bria','$',45 dup (?)
	_n	db	'n','$',48 dup (?)
	_despues	db	'despues','$',42 dup (?)

.CODE
START:

	MOV AX, @DATA

	MOV DS, AX

	MOV ES, AX


;Comienzo codigo de usuario

	MOV SI, OFFSET _bria
	MOV DI, OFFSET @pri
	call COPIAR
	MOV SI, OFFSET _n
	MOV DI, OFFSET @seg
	call COPIAR
	MOV SI, OFFSET @pri
	MOV DI, OFFSET __auxConc
	CALL COPIAR
	MOV SI, OFFSET @seg
	MOV DI, OFFSET __auxConc
	CALL CONCAT
	MOV SI, OFFSET __auxConc
	MOV DI, OFFSET @ccc
	CALL COPIAR
	MOV SI, OFFSET @pri
	MOV DI, OFFSET __auxConc
	CALL COPIAR
	MOV SI, OFFSET _despues
	MOV DI, OFFSET __auxConc
	CALL CONCAT
	MOV SI, OFFSET __auxConc
	MOV DI, OFFSET @laf
	CALL COPIAR

	LEA DX, @ccc 
	MOV AH, 9
	INT 21H
	newline

	LEA DX, @laf 
	MOV AH, 9
	INT 21H
	newline

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
