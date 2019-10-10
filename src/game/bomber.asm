init_bomber:
	push bp
	mov bp, sp

	mov word [cs:bomber_speed], 0xF
	mov ax, 320/2 - 32
	shl ax, 4
	mov [cs:bomber_x], ax

	mov byte [cs:bomber_state], 1

	mov sp, bp
	pop bp
	ret

update_bomber:
	push bp
	mov bp, sp
	

	mov ax, [cs:bomber_speed]

	mov cx, [cs:bomber_x]

	mov bl, [cs:bomber_state]
	
	test bl, 0x1
	jz up_s
	sub cx, ax
	jae up_ds
	mov word [cs:bomber_x], 10
	mov byte [cs:bomber_state], 0
	call rand_bomb_dist
	jmp up_d
up_s:
	add cx, ax
up_ds:
	mov [cs:bomber_x], cx
	
	
	shr cx, 4
	cmp cx, 0

	cmp cx, 320-32		;width screen minus bomber
	jb up_d
	mov word [cs:bomber_x], 0x11F0
	mov byte [cs:bomber_state], 1
	call rand_bomb_dist

up_d:
	call bomber_do_dir
	mov sp, bp
	pop bp
	ret


; checks if it is time that the bomber changes direction, and if so, randomly generates a new distance for the bomber to move and changes his direction
bomber_do_dir:
	push bp
	mov bp, sp

	mov ax, [cs:bomber_speed]
	mov bx, [cs:bomber_dist]
	mov cl, [cs:bomber_state]
	sub bx, ax
	ja bdd_s
brh:	xor cl, 1 		;flips first bit
	mov [cs:bomber_state], cl
	call rand_bomb_dist
	
	jmp bdd_d
bdd_s:	
	mov [cs:bomber_dist], bx
	
bdd_d:	mov sp, bp
	pop bp
	ret


; Randomly generates the distance the bomber has to move before it switches direction
rand_bomb_dist:
	push bp
	mov bp, sp


	call get_rand
	mov dx, 0
	mov ah, 0
	mov cx, 230
	div cx
	add dx, 100

	shl dx, 4
	mov [cs:bomber_dist], dx	

	
	mov sp, bp
	pop bp
	ret
