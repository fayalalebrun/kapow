init_paddle:
	push bp
	mov bp, sp

	mov ax, paddle_initial_x
	shl ax, 4
	mov [cs:paddle_x], ax

	mov byte [cs:paddle_n], paddle_initial_n
	
	mov sp, bp
	pop bp
	ret

handle_paddle_input:
	push bp
	mov bp, sp


	test byte [cs:keystate], 0x1
	jz hpic1

	mov ax, [cs:paddle_x]
	sub ax, paddle_speed
	mov [cs:paddle_x], ax
	jae hpid
	mov word [cs:paddle_x], 0
	jmp hpid
	
hpic1:	
	test byte [cs:keystate], 0x2
	jz hpid

	add word [cs:paddle_x], paddle_speed
	mov ax, [cs:paddle_x]
	shr ax, 4
	cmp ax, 320-32
	jb hpid
	mov word [cs:paddle_x], (320-32)<<4

hpid:	
	mov sp, bp
	pop bp
	ret

handle_paddle_bombs_collision:
	push bp
	mov bp, sp

	
	xor bx, bx
	mov bl, [cs:paddle_n]

	cmp bx, 0
	je hpbc_d
	
	dec bx
	mov ax, paddle_height+paddle_gap
	mul bx
	add ax, paddle_height	; ax now contains the total height of the paddle bounding box
	mov cx, ax

	mov di, number_of_bombs*2

hpbc_l:	
	sub di, 2
	push cx
	
	push bomb_height
	push cx
	mov bx, [cs:bomb_y+di]
	shr bx, 4		;fixed point 4 fraction bits
	push bx
	push paddle_initial_y
	mov dx, bomb_width
	mov cx, paddle_width
	mov ax, [cs:paddle_x]
	shr ax, 4		;fixed point 4 fraction bits
	mov bx, [cs:bomb_x+di]
	call detect_collision_2d
	
	cmp ax, 1
	jne hpbc_c
	push di
	mov ax, di
	
	shr di, 1		;divide di by 2
	mov dl, [cs:bomb_state+di]
	mov byte [cs:bomb_state+di], 0
	cmp dl, 0
	je hpbc_as
	mov ax, di
	call explode_bomb
	mov ax, 50
	call add_score
hpbc_as:	
	pop di
	
hpbc_c:	
	
	add sp, 8		;clears the last 4 words pushed to the stack

	pop cx
	
	cmp di, 0
	jne hpbc_l


hpbc_d:	
	mov sp, bp		
	pop bp
	ret
