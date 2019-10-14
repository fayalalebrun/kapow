%define var_area_base 0xC000

%define bomber_x var_area_base		; 2 bytes, fixed point integer with 4 bit fraction
%define bomber_speed bomber_x+2	; 2 bytes
%define bomber_state bomber_speed+2 	; 1 byte, 0 means going right, 1 means going left
%define bomber_dist bomber_state+1	; 2 byte, how much the bomber will travel until it changes direction, fixed point integer with 4 bit fraction


%define score bomber_dist+2		; 4 bytes
%define score_bcd score+4		; score in BCD format, 8 bytes, starts from LSD
%define top_score score_bcd+8	
%define top_score_bcd top_score+4
%define stage top_score_bcd+8		; 1 byte, 0 = no stage 1 = playing 2 = top score screen 3 = transition
%define stage_timer stage+1		; 2 bytes, used to time stages
%define stage_vars stage_timer+2	; 2 bytes, misc stage variables
	
%define keystate stage_vars+2 	; 1 byte
				; bit 0 is left arrow pressed
				; bit 1 is right arrow pressed
				; bit 2 is enter key pressed

%define last_rand keystate+1		; 2 bytes

%define paddle_x last_rand+2		; 2 bytes, fixed point integer with 4 bit fraction
%define paddle_n paddle_x+2		; 1 byte


%define bomb_speed paddle_n+1		; 2 bytes, fixed point integer with 4 bit fraction
%define bomb_state bomb_speed+2		; n of bombs elements, 1 byte per element
%define bomb_x bomb_state+1*number_of_bombs	; n of bombs elements, 2 byte per element
%define bomb_y bomb_x+2*7	; n of bombs elements, 2 bytes per element, fixed point with 4 bit fraction

%define explosion_state bomb_y+2*number_of_bombs ;n of explosions elements, 2 bytes per element, fixed point with 8 bit fraction
%define explosion_x explosion_state+2*number_of_explosions ;n of explosions elements, 2 bytes
%define explosion_y explosion_x+2*number_of_explosions	   ;n of explosions elements, 2 bytes
%define explosion_start_index explosion_y+2*number_of_explosions ; 1 byte, contains the index of the first explosion that is still active
%define explosion_end_index explosion_start_index+1		 ; 1 byte, contains the index of the position after the last one that should be rendered
