%define game_start 0x1000
%define asset_storage 0x4000	
%define game_main 0x0000
%define game_tirq game_main+2	; jmp short is 2 instructions
	

bits 16
section .text
global _start
start:
	cli			;disable interrupts
	
	mov sp,0x7c00
	
;	mov ax, 0x4f02		;set VESA mode
; 	mov bx, 0x101		;640*480 256 colors
;	int 0x10		

	mov ax, 0x13		
	int 0x10		

	mov ax, game_start
	mov es, ax		; segment address to copy to
	mov ah, 0x2 		; read sectors from drive
	mov al, 128		; amount of sectors to read
	mov ch, 0		; cylinder
	mov dh, 0		; head
	mov cl, 2		; sector
	mov dl, 0x80		; disk

	mov bx, 0		; address to copy to
	int 0x13

	mov ax, asset_storage
	mov es, ax
	mov ah, 0x2
	mov al, 2
	mov ch, 0
	mov dh, 2
	mov cl, 4
	mov dl, 0x80
	
	mov bx, 0		; address to copy to
	int 0x13


	
	mov ax, game_start	
	mov [cs:0x1c*4+2], ax	; move segment of game to IVT
	mov ax, game_tirq
	mov [cs:0x1c*4], ax	; move address of irq to IVT

	sti			;enable interrupts
	
	jmp game_start:game_main
