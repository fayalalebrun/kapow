bits 16
%define last_bank 0x0000
%define vga_mem 0x7000	
%define screen_width 320
%define screen_half_height 200/2


section .text
; Draws a pixel on the screen
; al - color
; bx - x-coordinate
; cx - y-coordinate
	
put_pixel:
	push bp
	mov bp, sp

	push ax
	mov ax, screen_width
	mul cx
	add bx, ax
	pop ax
	
	mov dx, vga_mem
	mov gs, dx
	mov [gs:bx], al
	
	mov sp, bp
	pop bp
	ret


; Draws a column on pixels centered on the middle of the screen
; al - color 
; bx - x coordinate
; cx - height/2
draw_column:
	push bp
	mov bp, sp

	mov dx, vga_mem
	mov gs, dx
	
	mov dx, screen_half_height
	sub dx, cx 		; dx now has starting pixel
	
	shl cx, 1		; multiply cx by 2 to get height

	push ax
	mov ax, screen_width
	mul dx
	add bx, ax
	pop ax

	
	
d_c1:	
	
	
	mov [gs:bx], al
	add bx, screen_width
	loop d_c1
	
	
	mov sp, bp
	pop bp
	ret

; Draws a rectangle
; ax - y-position
; bx - x-position
; cx - width
; dh - height
; dl - color
draw_rectl:
	push bp
	mov bp, sp

	push dx
	mov dx, screen_width
	mul dx
	add bx, ax
	pop dx

	mov ax, vga_mem
	mov es, ax

	push cx
drl1:	mov [es:bx], dl
	inc bx
	loop drl1
	dec dh
	cmp dh, 0
	jz drd1
	pop cx
	push cx
	add bx, screen_width
	sub bx, cx
	jmp drl1
	
drd1:	pop cx
	
	mov sp, bp
	pop bp
	ret

; Draws a sprite
; ax - y-position
; bx - x-position
; ch - width
; cl - height
; dx - sprite location
draw_sprite:
	push bp
	mov bp, sp

	push dx
	mov dx, screen_width
	mul dx
	add bx, ax

	mov ax, vga_mem
	mov es, ax
	mov ax, sprite_seg
	mov gs, ax
		
	pop ax 			; move dx to ax
	xor dx, dx
	mov dl, cl

	shr cx, 8
	
	
	push cx
ds1:
	push ax
	push bx
	mov bx, ax
	mov al, [gs:bx]
	pop bx
	cmp al, 0xFF
	je dssk 		
	mov [es:bx], al
dssk:
	pop ax
	inc bx
	inc ax
	
	loop ds1
	dec dx
	cmp dx, 0
	jz dsd
	pop cx
	push cx
	add bx, screen_width
	sub bx, cx

	jmp ds1

dsd:	pop cx

	
	
	mov sp, bp
	pop bp
	ret
	
	
;Draws the background
; ah - first color of the background
; al - second color	
draw_background:
	push bp
	mov bp, sp

	push ax
	mov dl, ah		
	mov ax, 0
	mov bx, 0
	mov cx, 320
	mov dh, 40
	call draw_rectl

	pop ax
	mov dl, al
	mov ax, 40
	mov bx, 0
	mov cx, 320
	mov dh, 160
	call draw_rectl

	mov sp, bp
	pop bp
	ret

; Sets an index in a palette to a color
; ah - index
; bl - red (0-63)
; bh - green (0-63)
; cl - blue (0-63)
set_palette_index:
	push bp
	mov bp, sp

	mov al, 0xFF
	mov dx, 0x3C6 		; PEL Mask Register
	out dx, al		; Prepare VGA card for color change

	mov al, ah
	mov dx, 0x3C8		; PEL Address Write Mode Register
	out dx, al		; Send what color index to write to

	mov dx, 0x3C9		; PEL Data Register

	mov al, bl
	out dx, al

	mov al, bh
	out dx, al

	mov al, cl
	out dx, al

	
	
	mov sp, bp
	pop bp
	ret
