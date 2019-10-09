init_rand:
	push bp
	mov bp, sp

	mov ah, 0x00
	int 0x1a 		;get clock ticks since midnight

	mov [cs:last_rand], dx 	;store starting seed

	
	mov sp, bp
	pop bp
	ret

; Generates a new random number
; Returns new random number
get_rand:
	push bp
	mov bp, sp

	mov ax, [cs:last_rand]


	mov dx, 7	
	mul dx

	inc ax

	mov dx, 0
	cmp ax, 0xFFFF

	cmove ax, dx
	

	mov [cs:last_rand], ax






	mov sp, bp
	pop bp
	ret
