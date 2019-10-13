increase_difficulty:
	push bp
	mov bp, sp

	mov ax, bomber_speed_inc
	add [cs:bomber_speed], ax

	mov ax, bomb_speed_inc
	add [cs:bomb_speed], ax
	
	mov sp, bp
	pop bp
	ret
