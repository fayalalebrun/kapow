bits 16
section .text


jmp short main
jmp short timer_irq

%include "src/game/debug.asm"

%include "src/game/sprite_constants.asm"
%include "src/game/var_locs.asm"

main:
	
	
	

	
	
	mov word [cs:bomber_x], 0xFF

main_l:	
	

	
	call render

	jmp main_l

timer_irq:



	iret


%include "src/game/renderer.asm"
%include "src/game/2dgfx.asm"


times 0xFFFF - ($-$$) db 0
