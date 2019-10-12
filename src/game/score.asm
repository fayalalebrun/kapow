init_score:
	push bp
	mov bp, sp
	
	mov word [cs:score], 0
	mov word [cs:score+2], 0

	mov di, 8

in_s_l:
	sub di, 2

	mov word [cs:score_bcd+di], 0x0
	
	cmp di, 0
	jne in_s_l
	
	mov sp, bp
	pop bp
	ret

init_top_score:
	push bp
	mov bp, sp
	
	mov word [cs:top_score], 0
	mov word [cs:top_score+2], 0

	mov di, 8

in_ts_l:
	sub di, 2

	mov word [cs:top_score_bcd+di], 0x0
	
	cmp di, 0
	jne in_ts_l
	
	mov sp, bp
	pop bp
	ret

;adds points to the score
;ax - number of points
add_score:
	push bp
	mov bp, sp

	add [cs:score], ax
	jnc a_s_c
	inc word [cs:score+2]
a_s_c:	
	
	mov di, 0
	mov cx, 10
a_s_lo:
	xor bx, bx
	mov bl, [cs:score_bcd+di]

	add ax, bx
	xor dx, dx
	div cx
	mov [cs:score_bcd+di], dl

	cmp ax, 0
	je a_s_d

	inc di
	cmp di, 8
	jne a_s_lo

a_s_d:	mov sp, bp
	pop bp
	ret

; if the score is higher than the top score, sets the top score to it
set_top_score:
	push bp
	mov bp, sp

	mov ax, [cs:top_score+2]
	cmp ax, [cs:score+2]
	ja s_t_sd
	mov ax, [cs:top_score]
	cmp ax, [cs:score]
	jae s_t_sd

	mov ax, [cs:score]
	mov [cs:top_score], ax
	mov ax, [cs:score+2]
	mov [cs:top_score+2], ax

	mov di, 8

s_tsl:	dec di

	mov al, [cs:score_bcd+di]
	mov [cs:top_score_bcd+di], al
	
	cmp di, 0
	jne s_tsl
	
s_t_sd:
	mov sp, bp
	pop bp
	ret
