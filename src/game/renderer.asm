	
render:
	push bp
	mov bp, sp

	
 	mov ax, 0x0795
 	call draw_background
	

	mov ax, 100 		;y 
	mov bx, 50		;x
	mov ch, 16		;width
	mov cl, 32		;height
	mov dx, 0		;sprite location
	call draw_sprite

	mov ax, 100 		;y
	mov bx, 100		;x
	mov ch, 8		;width
	mov cl, 16		;height
	mov dx, bomb8_loc	;sprite location
	call draw_sprite


	mov  bx, [cs:bomber_x]	;x
	shr bx, 4		;4 fraction bits
	mov ax, 11 		;y
	mov ch, 32		;width
	mov cl, 32		;height
	mov dx, bomber_loc	;sprite location
	call draw_sprite
	
	call copy_buffer
	
	mov sp, bp
	pop bp
	ret


copy_buffer:
	push bp
	mov bp, sp

		mov cx, 0x7000
	mov ds, cx
	xor si, si             ;ds:si = source

	mov cx, 0xa000
	mov es, cx
	xor di, di             ;es:di = destination
	
	mov cx, 32000    	;32k words to fill the screen
	
	mov dx, 0x3da           ; VGA status register
vt_set:
	in al, dx              ;al = status bite
	and al, 8              ;check if vertical tracing bit is clear
	jnz vt_set           ;wait for it to clear

vt_clr:                  
	in al, dx
	and al, 8
	jz vt_clr

	rep movsw

	
	mov sp, bp
	ret
