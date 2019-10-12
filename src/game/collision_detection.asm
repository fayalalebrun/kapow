
; Checks if there is a collision in a single dimension
; ax - position 1
; bx - position 2
; cx - size 1
; dx - size 2
; Returns 1 if true and 0 if false
detect_collision_1d:
	push bp
	mov bp, sp

	shr cx, 1 		; divide by 2
	shr dx, 1

	add ax, cx
	add bx, dx		; get the midpoint by adding half the size to the positions

	sub ax, bx
	jae dtc1_c
	not ax
	inc ax 			; if ax is lesser than bx, ax = ax * -1 (2's complement)
dtc1_c:
	add cx, dx
	cmp cx, ax
	mov ax, 1
	ja dtc1_d
	mov ax, 0
	
dtc1_d:	
	mov sp, bp
	pop bp
	ret


; Checks if two bounding boxes are colliding
; ax - x 1
; bx - x 2
; cx - width 1
; dx - width 2
; stack 2 bytes - y 1
; stack 2 bytes - y 2
; stack 2 bytes - height 1
; stack 2 bytes - height 2
; returns 1 if collision detected, 0 if no collision
detect_collision_2d:
	push bp
	mov bp, sp

	call detect_collision_1d
	cmp ax, 0
	je dtc2_d

	mov ax, [bp+4]
	mov bx, [bp+6]
	mov cx, [bp+8]
	mov dx, [bp+10]
	call detect_collision_1d


	
dtc2_d:
	mov sp, bp
	pop bp
	ret
