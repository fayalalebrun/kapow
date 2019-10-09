bits 16
section .text


jmp short main
jmp short timer_irq

%include "src/game/debug.asm"

%include "src/game/sprite_constants.asm"
%include "src/game/var_locs.asm"

main:

	call init_rand
	call init_bomber
	mov word [cs:bomber_x], 0xFF
	

main_loop:	

	call get_rand

	
	call render
	

	jmp main_loop

timer_irq:
	call update_bomber


	iret


%include "src/game/renderer.asm"
%include "src/game/2dgfx.asm"
%include "src/game/random.asm"
%include "src/game/bomber.asm"	


times 0xFFFF - ($-$$) db 0
