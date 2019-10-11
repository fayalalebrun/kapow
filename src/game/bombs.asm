init_bombs:
	push bp
	mov bp, sp

	mov word [cs:bomb_speed], bomb_initial_speed

	mov si, number_of_bombs
	mov bx, 0
	
init_l1:
	dec si

	mov byte [cs:bomb_state+bx+ si], 0
	
	
	cmp si, 0
	jne init_l1


	mov di, number_of_bombs*2
	mov bx, 0
	
init_l2:
	sub di, 2

	mov word [cs:bomb_x+bx+di], 30
	

	cmp di, 0
	jne init_l2
	

	mov si, number_of_bombs*2
	mov bx, 0
	mov ax, bombs_initial_y
init_l3:
	
	sub si, 2

	push ax
	shl ax, 4
	mov word [cs:bomb_y+bx+si], ax

	pop ax
	add ax, 24
	

	cmp si, 0
	jne init_l3

	
	
	mov sp, bp
	pop bp
	ret

update_bombs:
	push bp
	mov bp, sp
	
	mov di, number_of_bombs*2
	mov bx, 0

upd_bl:
	sub di, 2

	mov ax, [cs:bomb_y+di]
	add ax, [cs:bomb_speed]
	mov [cs:bomb_y+di], ax
	cmp ax, 200-16 << 4
	jbe upd_blc

	mov dx, bombs_initial_y<<4
	mov word [cs:bomb_y+di], dx
	mov dx, [cs:bomber_x]
	shr dx, 4
	mov [cs:bomb_x+di], dx
	
upd_blc:
	
	cmp di, 0
	jne upd_bl
	
	mov sp, bp
	pop bp
	ret
