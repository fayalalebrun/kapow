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
	
