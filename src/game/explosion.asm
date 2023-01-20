init_explosion:
	push bp
	mov bp, sp


	mov byte [cs:explosion_start_index], 0
	mov byte [cs:explosion_start_index], 0

	mov sp, bp
	pop bp
	ret

update_explosion:
	push bp
	mov bp, sp

	xor bx, bx
	mov bl, [cs:explosion_start_index]
	mov di, bx

	xor cx, cx
	mov cl, [cs:explosion_end_index]

up_ex_l:
	cmp di, cx
	je up_ex_e

	shl di, 1

	mov ax, [cs:explosion_state+di]
	add ax, explosion_speed
	cmp ax, explosion_frames << 8
	jb up_ex_c
	mov ax, 0
	inc byte [cs:explosion_start_index]
	xor dx, dx
	mov dl, [cs:explosion_start_index]
	cmp dl, number_of_explosions
	jne up_ex_c
	mov byte [cs:explosion_start_index], 0
up_ex_c:
	mov [cs:explosion_state+di], ax
	shr di, 1
	
	inc di
	cmp di, number_of_explosions
	jne up_ex_l
	mov di, 0
	jmp up_ex_l


up_ex_e:	
	mov sp, bp
	pop bp
	ret

; Starts an explosion animation where a bomb is
; ax - bomb index
explode_bomb:
	push bp
	mov bp, sp

	push si
	push di
	push bx

	
	mov si, ax
	
	xor bx, bx
	mov bl, [cs:explosion_end_index]
	push bx
	inc bl
	mov ax, 0
	cmp bl, number_of_explosions
	
	jnz expb1
	mov bx, ax
expb1:	
	cmp bl, [cs:explosion_start_index]
	pop bx
	je expb_e

	mov di, bx
	
	inc byte [cs:explosion_end_index]

	cmp di, number_of_explosions-1
	jne expb_c
	mov byte [cs:explosion_end_index], 0

expb_c:	

	shl di, 1
	shl si, 1
	mov ax, [cs:bomb_x+si]
	mov [cs:explosion_x+di], ax

	mov ax, [cs:bomb_y+si]
	mov [cs:explosion_y+di], ax

	mov word [cs:explosion_state+di], 0


expb_e:
	pop bx
	pop di
	pop si
	
	mov sp, bp
	pop bp
	ret
	
