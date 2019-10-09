init_bomber:
	push bp
	mov bp, sp

	mov word [cs:bomber_speed], 0xF
	mov ax, 0
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

up_d:	
	mov sp, bp
	pop bp
	ret
