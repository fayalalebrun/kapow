init_paddle:
	push bp
	mov bp, sp

	mov ax, paddle_initial_x
	shl ax, 4
	mov [cs:paddle_x], ax

	
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
