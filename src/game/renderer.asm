	
render:
	push bp
	mov bp, sp



 	mov ax, 0x0795
 	call draw_background
	


	call render_bombs
	
	mov  bx, [cs:bomber_x]	;x
	shr bx, 4		;4 fraction bits
	mov ax, bomber_initial_y 		;y
	mov ch, 32		;width
	mov cl, 32		;height
	mov dx, bomber_loc	;sprite location
	call draw_sprite

	mov ax, paddle_initial_y 		;y
	mov bx, [cs:paddle_x]		;x
	shr bx, 4			;4 fraction bits
	mov ch, 32		;width
	mov cl, 8		;height
	mov dx, paddle_loc	;sprite location
	call draw_sprite


	
	call copy_buffer
	
	mov sp, bp
	pop bp
	ret

render_bombs:
	push bp
	mov bp, sp

	mov di, number_of_bombs * 2
	mov bx, 0

r_bl:
	sub di, 2
	push di
	mov bx, 0
	mov word ax, [cs:bomb_y+bx+di]
	shr ax, 4
	mov word cx, [cs:bomb_x+bx+di]
	mov bx, cx
	mov ch, 8		;width
	mov cl, 16		;height
	mov dx, bomb8_loc	;sprite location
	call draw_sprite
	

	pop di

	cmp di, 0
	jne r_bl
	
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
	pop bp
	ret
