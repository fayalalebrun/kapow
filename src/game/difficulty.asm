increase_difficulty:
	push bp
	mov bp, sp

	mov ax, [cs:bomber_speed]
	cmp ax, max_bomber_speed
	jb i_d_c1
	mov word [cs:bomber_speed], max_bomber_speed
	jmp i_d_s
i_d_c1:
	cmp ax, max_bomber_speed*60/100
	jae i_d_c2
	add ax, bomber_speed_inc_1
	mov [cs:bomber_speed], ax
	jmp i_d_s
i_d_c2:
	add ax, bomber_speed_inc_2
	mov [cs:bomber_speed], ax
	
i_d_s:
	mov ax, [cs:bomb_speed]
	cmp ax, max_bomb_speed
	jb i_d_c3
	mov word [cs:bomb_speed], max_bomb_speed
	jmp i_d_e
i_d_c3:	
	cmp ax, max_bomb_speed*60/100
	jae i_d_c4
	add ax, bomb_speed_inc_1
	mov [cs:bomb_speed], ax
	jmp i_d_e
i_d_c4:
	add ax, bomb_speed_inc_2
	mov [cs:bomb_speed], ax
	
i_d_e:	mov sp, bp
	pop bp
	ret
