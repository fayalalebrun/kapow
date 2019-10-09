%define var_area_base 0xC000
%define bomber_x var_area_base		; 2 bytes, fixed point integer with 4 bit fraction
%define score bomber_x+2		; 2 bytes
%define last_rand score+2		; 2 bytes
%define paddle_x last_rand+2		; 2 bytes
%define bomb_base paddle_x+2		; structs
; There are 16 bombs. Each is structured in the following way:
; state 1 byte
; bomb_x 2 bytes
; bomb_y 2 bytes
%define bomb1_state bomb_base 	; 1 byte
%define bomb1_x bomb1_state+1	; 2 bytes
%define bomb1_y bomb1_x+2	; 2 bytes
