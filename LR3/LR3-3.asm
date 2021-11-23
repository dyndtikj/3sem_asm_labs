use16
org 0x100
call print_addr
int 20h

print_addr:
	push bx
	push dx
	push cx
	push ax
	push si

	mov bx, 0x0;
	mov cx,0xF
	mov si, 0x28;			#40d = 28h
	lp1:

		push cx
		mov cx, 0xF

		lp2:
			mov dh, byte[bx+si];
			call print_dh

			inc si;
			loop lp2

		pop cx
		mov dl, 0xD;
		mov ah, 0x2;
		int 0x21;
		mov dl, 0xA;
		int 0x21
		loop lp1

	pop si
	pop ax
	pop cx
	pop dx
	pop bx
	ret

print_dh:
	push dx
	push ax
	mov dl, dh
	and dl, 0xF0
	shr dl, 4
	cmp dl, 0x9
	ja m1
	add dl, 0x30
	jmp m2
m1:
	add dl, 0x37

m2:
	mov ah, 0x2
	int 0x21

	mov dl, dh

	and dl, 0xF
	cmp dl, 0x9
	ja m3
	add dl, 0x30
	jmp m4

m3:
    add dl, 0x37
m4:
	mov ah, 0x2
	int 0x21
	mov dl, ' ';
	mov ah, 0x2
	int 0x21
	pop ax
	pop dx
	ret