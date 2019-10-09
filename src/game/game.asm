bits 16
section .text


jmp short main
jmp short timer_irq

%include "src/game/debug.asm"

%include "src/game/sprite_constants.asm"

main:

	
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
	

	

	mov al, 0x34
	xor bx, bx
	xor cx, cx
	call put_pixel
	
	mov ax, 0x34
	mov bx, 33
	mov cx, 22
	mov dh, 10		
	mov dl, 0x34
	call draw_column


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
	
	jmp main

timer_irq:



	iret


%include "src/game/2dgfx.asm"


times 0xFFFF - ($-$$) db 0
