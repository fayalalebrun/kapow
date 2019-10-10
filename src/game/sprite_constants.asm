;This file keeps track of the way sprites are stored on disc and contains information about them 
bits 16
%define sprite_seg 0x4000
%define bomb 0x0  ;16x32		
%define bomb8_loc bomb+16*32 ;8*16
%define bomber_loc bomb8_loc+8*16 ;32*32
%define paddle_loc bomber_loc+32*32 ; 32*8
