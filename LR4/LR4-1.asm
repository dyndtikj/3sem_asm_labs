use16
org	0x100

Start:
	jmp Init

Begin:
	sti
	push ax
	push dx
	push ds

	push ax
	mov ax, cs
	mov ds, ax
	pop ax
	call print_addr; (dump from es:di)
	
	pop ds
	pop dx
	pop ax
	iret

print_addr:
	push dx
	push cx
	push ax
	push di

	mov cx,0x10
	lp1:

		push cx
		mov cx, 0x10

		lp2:
			mov dh, byte[es:di];
			call print_dh

			inc di;
			loop lp2

		pop cx
		mov dl, 0xD;
		mov ah, 0x2;
		int 0x21;
		mov dl, 0xA;
		int 0x21
		loop lp1

	pop di
	pop ax
	pop cx
	pop dx
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

Init:
	mov ah, 0x25
	mov al, 0x84
	mov dx, Begin
	int 0x21
	mov dx, Init
	int 0x27
