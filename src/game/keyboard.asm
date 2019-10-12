update_keys_pressed:
	push bp
	mov bp, sp

	mov bl, 0		;value that will be written
	mov cx, 1
kmore:	in al, 0x60
	mov bl, al
	in al, 0x64
	test al, 0x1
	jnz kmore		;If there are still bytes in the keyboard's output buffer, keep requesting bytes

	mov al, bl

	cmp al, 0x4B		;Left arrow pressed
	jne k_c1
	or byte [cs:keystate], 0x1
	jmp k_d
k_c1:	
	cmp al, 0xCB		;Left arrow released
	jne k_c2
	and byte [cs:keystate], 0xFE
	jmp k_d
k_c2:	
	cmp al, 0x4D		;Right arrow pressed
	jne k_c3
	or byte [cs:keystate], 0x2
	jmp k_d
k_c3:	
	cmp al, 0xCD		;Right arrow released
	jne k_c4
	and byte [cs:keystate], 0xFD
	jmp k_d

k_c4:	
	cmp al, 0x1C		;Enter key pressed
	jne k_c5
	or byte [cs:keystate], 0x4
	jmp k_d

k_c5:	cmp al, 0x9C		;Enter key released
	jne k_d
	and byte [cs:keystate], 0xFB
	
k_d:	
	mov sp, bp
	pop bp
	ret
