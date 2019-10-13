play_scr_init:
	push bp
	mov bp, sp

	call set_palette

	call init_rand
	call init_bomber
	call init_paddle
	call init_bombs
	call init_score

	mov word [cs:stage_timer], difficulty_inc_interval

	mov byte [cs:stage_vars], 1

	mov byte [cs:stage], 1
	
	mov sp, bp
	pop bp
	ret

tran_scr_init:
	push bp
	mov bp, sp

	call set_palette

	mov byte [cs:stage_vars], 0

	mov word [cs:stage_timer], 84
	
	
	mov byte [cs:stage], 3

	call find_lowest_bomb

	mov [cs:stage_vars+1], al
	
	mov sp, bp
	pop bp
	ret

score_scr_init:
	push bp
	mov bp, sp

	call set_palette
	call set_top_score

	mov byte [cs:stage], 2
	
	mov sp, bp
	pop bp
	ret

score_scr_loop:
	push bp
	mov bp, sp

	mov bl, [cs:keystate]
	test bl, 0x4
	jz cont
	call play_scr_init
cont:	
	call render_play_scr
	
	mov sp, bp
	pop bp
	ret

tran_scr_loop:
	push bp
	mov bp, sp

	dec word [cs:stage_timer]

	mov bx, [cs:stage_timer]
	cmp bx, 0
	jne tr_s_c2
	dec byte [cs:paddle_n]
	mov cl, [cs:paddle_n]
	cmp cl, 0
	je tr_s_c3		;The player has run out of paddles
	call set_palette	;reset the palette
	mov byte [cs:stage], 1	;set the stage to playing
	mov byte [cs:stage_vars], 1 ;The playing stage should not be waiting for bombs to explode
	mov word [cs:stage_timer], difficulty_inc_interval
	jmp tsc_e1
tr_s_c3:
	call score_scr_init
	jmp tsc_e1
tr_s_c2:	
	test bx, 0xF		; This should triger the function about 1/16th of the time
	jne tsc_e

	xor bx, bx
	mov bl, [cs:stage_vars+1]
	cmp bl, number_of_bombs
	jb tr_s_c1
	mov bl, 0
	mov [cs:stage_vars+1], bl ; Here is stored the index of the next bomb that we want to remove
tr_s_c1:	
	mov di, bx
	mov byte [cs:bomb_state+di], 0

	inc byte [cs:stage_vars+1]
	
	mov bl, [cs:stage_vars]	;Here we store whether the palette was inverted or normal on the last loop
	cmp bl, 0
	je tsc_c

	call set_palette
	mov byte [cs:stage_vars],0
	jmp tsc_e

tsc_c:	
	
	call set_palette_inverted
	mov byte [cs:stage_vars], 1

tsc_e:

	
	call render_play_scr

tsc_e1:	
	
	mov sp, bp
	pop bp
	ret


play_scr_loop:
	push bp
	mov bp, sp

	dec word [cs:stage_timer]
	mov bx, [cs:stage_timer]
	cmp bx, 0
	jne p_sl_c
	mov word [cs:stage_timer], difficulty_inc_interval
	call increase_difficulty
	mov byte [cs:stage_vars], 0 ;This means the game is waiting for all bombs to be done with
p_sl_c:	
	call handle_paddle_input

	mov al, [cs:stage_vars]
	cmp al, 0
	je p_sl_sk
	call update_bomber
p_sl_sk:	

	xor ax, ax
	mov al, [cs:stage_vars]
	push ax
	cmp al, 0
	jne p_sl_c1
	call check_if_any_bomb_active
	cmp al, 1
	je p_sl_c1
	mov byte[cs:stage_vars], 1
p_sl_c1:
	pop ax
	
	call update_bombs
	call handle_paddle_bombs_collision

	

	call render_play_scr

	mov sp, bp
	pop bp
	ret

update_stage:
	push bp
	mov bp, sp
	
	mov bl, [cs:stage]

	cmp bl, 1
	jne upd_s1
	call play_scr_loop
	jmp upd_d
upd_s1:
	cmp bl, 2
	jne upd_s2
	call score_scr_loop
	jmp upd_d

upd_s2:
	cmp bl,3
	jne upd_d
	call tran_scr_loop
upd_d:	
	mov sp, bp
	pop bp
	ret
