bits 16
section .text


jmp short main
jmp short timer_irq
jmp short keyboard_irq	

%include "src/game/sprite_constants.asm"
%include "src/game/var_locs.asm"
%include "src/game/game_constants.asm"	

main:

	
	call init_top_score
	call play_scr_init
	call score_scr_init
	call init_explosion

	mov word [cs:tirq_timer], 0

	
main_loop:	

	hlt


	jmp main_loop

timer_irq:
	pusha

	mov ax, [cs:tirq_timer]
	inc ax
	cmp ax, 50
	jne tirq_e
	call update_stage
	mov ax, 0
	
	
tirq_e:
	mov [cs:tirq_timer], ax
	
	popa
	iret

keyboard_irq:
	pusha

	

	call update_keys_pressed
	

	
	mov al, 0x61
	out 0x20, al 		;send EOI



	popa
	iret


%include "src/game/renderer.asm"
%include "src/game/2dgfx.asm"
%include "src/game/random.asm"
%include "src/game/bomber.asm"
%include "src/game/keyboard.asm"
%include "src/game/paddle.asm"
%include "src/game/bombs.asm"	
%include "src/game/collision_detection.asm"
%include "src/game/score.asm"
%include "src/game/stage.asm"
%include "src/game/difficulty.asm"
%include "src/game/explosion.asm"	

times 0xFFFF - ($-$$) db 0
