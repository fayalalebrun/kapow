%define ANote  1193180/440
%define CNote 1193180/523
%define ENote 1193180/659

init_sound:
	push bp
	mov bp, sp


	

	mov word [cs:sound_time], 0
	
	
	mov sp, bp
	pop bp
	ret


play_rand_note:
	push bp
	mov bp, sp


	call get_rand

	mov dx, 0
	mov cx, 3
	div cx

	cmp dx, 0
	jne p_c1
	mov ax, ANote
	jmp p_s
p_c1:	
	cmp dx, 1
	jne p_c2
	mov ax, CNote
	jmp p_s
p_c2:	
	mov ax, ENote
p_s:
	push ax
	mov al, 0xb6
	out 0x43, al
	pop ax

	out 0x42, al
	mov al, ah
	out 0x42, al

	in al, 0x61
	or al, 0x3
	out 0x61, al

	mov word [cs:sound_time], note_length
	
p_se:	mov sp, bp
	pop bp
	ret

; ax - PIT counter value
; bx - duration
play_sound:
	push bp
	mov bp, sp

	push ax
	mov al, 0xb6
	out 0x43, al
	pop ax

	out 0x42, al
	mov al, ah
	out 0x42, al

	in al, 0x61
	or al, 0x3
	out 0x61, al

	mov word [cs:sound_time], bx


	mov sp, bp
	pop bp
	ret


sound_loop:
	push bp
	mov bp, sp

	mov cx, [cs:sound_time]
	dec cx
	mov [cs:sound_time], cx
	cmp cx, 0
	jne s_le

	in al, 0x61
	and al, 0xFC
	out 0x61, al
	
s_le:	mov sp, bp
	pop bp
	ret
