;This file keeps track of the way sprites are stored on disc and contains information about them 
bits 16

%define char_length 12
%define char_spr_size char_length*char_length
%define char_separation 12	

%define sprite_seg 0x4000
%define palette_loc 0x0		    ; 256*3 bytes
%define bomb palette_loc + 256*3  ;16x32		
%define bomb8_loc bomb+16*32 ;8*8
%define bomber_loc bomb8_loc+8*8 ;32*32
%define paddle_loc bomber_loc+32*32 ; 32*8
%define chars_loc paddle_loc + 32 * 8 ; Position of first number character, 10 digits 12x12 each
%define topsc_loc chars_loc + 12*12*10 ; 40*12
%define expls_loc tops_loc + 40*12     ; Position of first explosion frame, 4 frames 8x8 each
	
