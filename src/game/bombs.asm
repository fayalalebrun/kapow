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

; updates all the bombs on the screen
; ax - whether the bombs should be regenerated after touching the ground
update_bombs:
	push bp
	mov bp, sp
	
	mov di, number_of_bombs*2
	mov bx, 0
	
	push ax
upd_bl:
	sub di, 2

	mov ax, [cs:bomb_y+di]
	add ax, [cs:bomb_speed]
	mov [cs:bomb_y+di], ax
	cmp ax, 200-bomb_height << 4
	jbe upd_blc

	mov dx, bombs_initial_y<<4
	mov word [cs:bomb_y+di], dx
	mov dx, [cs:bomber_x]
	shr dx, 4
	mov [cs:bomb_x+di], dx
	mov si, di
	shr si, 1 		;Divide by 2

	mov bl, [cs:bomb_state+si]
	cmp bl, 0
	je upd_bc1
	push di
	call tran_scr_init 	; The bomb has reached the ground, time to reduce number of paddles
	pop di
upd_bc1:	
	pop ax
	push ax
	cmp ax, 1
	jne upd_blc
	mov byte [cs:bomb_state+si], 1

upd_blc:
	
	cmp di, 0
	jne upd_bl
	
	mov sp, bp
	pop bp
	ret
	
; Returns index of bomb with highest y
find_lowest_bomb:
	push bp
	mov bp, sp
	mov di, number_of_bombs*2
	mov si, 0

fi_lb_l:
	sub di, 2

	mov ax, [cs:bomb_y+di]
	mov bx, [cs:bomb_y+si]
	cmp ax, bx
	jbe fi_lb_c
	mov si, di
	
fi_lb_c:	
	cmp di, 0
	jne fi_lb_l
	
	mov ax, si
	shr ax, 1 		;Divide ax by 2
	
	mov sp, bp
	pop bp
	ret

; Returns true if any bomb is active
check_if_any_bomb_active:
	push bp
	mov bp, sp

	mov di, number_of_bombs
	xor ax, ax

c_i_al:
	dec di

	mov al, [cs:bomb_state+di]

	cmp al, 1
	je c_i_d
	
	cmp di, 0
	jne c_i_al



c_i_d:	mov sp, bp
	pop bp
	ret
