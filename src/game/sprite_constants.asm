;This file keeps track of the way sprites are stored on disc and contains information about them 
bits 16
%define sprite_seg 0x4000
%define palette_loc 0x0		    ; 256*3 bytes
%define bomb palette_loc + 256*3  ;16x32		
%define bomb8_loc bomb+16*32 ;8*8
%define bomber_loc bomb8_loc+8*8 ;32*32
%define paddle_loc bomber_loc+32*32 ; 32*8
