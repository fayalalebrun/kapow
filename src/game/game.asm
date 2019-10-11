bits 16
section .text


jmp short main
jmp short timer_irq
jmp short keyboard_irq	

%include "src/game/debug.asm"

%include "src/game/sprite_constants.asm"
%include "src/game/var_locs.asm"

main:

	call init_rand
	call init_bomber

main_loop:	
	

	call get_rand

	
	call render
	

	jmp main_loop

timer_irq:
	pusha


	call update_bomber	


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


times 0xFFFF - ($-$$) db 0
