%define var_area_base 0xC000

%define bomber_x var_area_base		; 2 bytes, fixed point integer with 4 bit fraction
%define bomber_speed bomber_x+2	; 2 bytes
%define bomber_state bomber_speed+2 	; 1 byte, 0 means going right, 1 means going left
%define bomber_dist bomber_state+1	; 2 byte, how much the bomber will travel until it changes direction, fixed point integer with 4 bit fraction


%define score bomber_dist+2		; 2 bytes

%define keystate score+2 	; 1 byte
				; bit 0 is left arrow pressed
				; bit 1 is right arrow pressed
				; bit 2 is enter key pressed

%define last_rand keystate+1		; 2 bytes

%define paddle_x last_rand+2		; 2 bytes, fixed point integer with 4 bit fraction


%define bomb_speed paddle_x+2		; 2 bytes, fixed point integer with 4 bit fraction
%define bomb_state bomb_speed+2		; 7 elements, 1 byte per element
%define bomb_x bomb_state+1*7	; 7 elements, 2 byte per element
%define bomb_y bomb_x+2*7	; 7 elements, 2 bytes per element, fixed point with 4 bit fraction
