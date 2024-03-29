%define n_frequence 100
%define PIT0_reload (0x1234DC/n_frequence) & 0xfffe
	
%define game_start 0x1000	
%define asset_storage 0x4000	
%define game_main 0x0000
%define game_tirq game_main+2	; jmp short is 2 instructions
%define game_kirq game_tirq+2

bits 16
cpu 186
section .text
global _start
start:
	cli			;disable interrupts
	
	mov sp,0x7c00
	mov ax, 0x0
	mov ss, ax
	
;	mov ax, 0x4f02		;set VESA mode
; 	mov bx, 0x101		;640*480 256 colors
;	int 0x10		

	mov ax, 0x13		
	int 0x10		

	mov ax, game_start
	mov es, ax		; segment address to copy to
	mov ah, 0x2 		; read sectors from drive
	mov al, 7		; amount of sectors to read
	mov ch, 0		; cylinder
	mov dh, 0		; head
	mov cl, 2		; sector
	mov dl, 0x0		; disk

	mov bx, 0		; address to copy to
	int 0x13

	mov ax, game_start
	mov es, ax
	mov ah, 0x2
	mov al, 8
	mov ch, 1
	mov dh, 0
	mov cl, 1
	mov dl, 0x0

	mov bx, 7 * 512		; address to copy to
	int 0x13


	mov ax, asset_storage
	mov es, ax
	mov ah, 0x2
	mov al, 7
	mov ch, 0x5
	mov dh, 0
	mov cl, 0x2
	mov dl, 0x0
	
	mov bx, 0		; address to copy to
	int 0x13		


	mov ax, asset_storage
	mov es, ax
	mov ah, 0x2
	mov al, 8
	mov ch, 0x6
	mov dh, 0
	mov cl, 0x1
	mov dl, 0x0
	
	mov bx, 7 * 512		; address to copy to
	int 0x13
	
	mov ax, asset_storage
	mov es, ax
	mov ah, 0x2
	mov al, 8
	mov ch, 0x7
	mov dh, 0
	mov cl, 0x1
	mov dl, 0x0
	
	mov bx, (7 + 8)*512		; address to copy to
	int 0x13			


 
	mov al,00110100b                  ;channel 0, lobyte/hibyte, rate generator
	out 0x43, al
 
	mov ax,PIT0_reload	;         ;ax = 16 bit reload value
	out 0x40,al                       ;Set low byte of PIT reload value
	mov al,ah                         ;ax = high 8 bits of reload value
	out 0x40,al                       ;Set high byte of PIT reload value

	
	mov ax, game_start	
	mov [cs:0x9*4+2], ax	; move segment of game to IVTn/
	mov ax, game_kirq
	mov [cs:0x9*4], ax	; move address of irq to IVT

	mov ax, game_start	
	mov [cs:0x1c*4+2], ax	; move segment of game to IVT
	mov ax, game_tirq
	mov [cs:0x1c*4], ax	; move address of irq to IVT

	mov al, 0xfe
	out 0x21, al		; enable timer interrupt


	
	sti			;enable interrupts
	
	jmp game_start:game_main
