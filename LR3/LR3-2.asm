use16
org 0x100

mov ax, 0xABCD;
mov bx, 0x1234;
mov cx, 0x124;
mov dx, 0xADAD;
mov ss, ax;
mov si, 0xA4F2
mov di, 0xDEF2;
mov sp, 0xDDDF;
mov bp, 0xFDA1;

call print_regs;		#two times to show correctness
call print_regs;
int 20h;

print_regs:
	pushf;				#procedure uses this regs
	push ax;			#after return restore them
	push dx;
	push cx;
	push bp;
	push di
	jmp my_pusha;		#to output regs in order: ax, bx, cx, dx
after_push:			   ;#cs, ss, ds, es, si, di, bp,(pusha pushes vice versa)
	mov cx, 13
	mov di, names;
lp:
	mov al, 0
	mov ah, 0x9
	mov dx, di;
	int 0x21

	pop dx; 			#pop value from stack to dx, to print it

	call print_dx
	call mov_di;		#this proc moves di to the next word in names(which is after symbol '$')

	loop lp;

	mov ah, 0x9
	mov dx, di;
	int 0x21

	pop di;
	pop bp;
	pop cx;
	pop dx
	pop ax
	popf
	ret

my_pusha:
	pushf
	push BP;
	mov bp,sp
	add bp, 0x10;		#before were pushed 8 regs, sp before was sb+0x10
	push BP;			#like a sp
	push DI;
	push SI; 
	push ES;
	push DS;
	push SS;
	push CS;
	push DX;
	push CX;
	push BX;
	push AX;
	jmp after_push

mov_di:
	push ax
	mov al,0x24;		#'$'
	again:
		scasb
		jne again;
	pop ax
	ret

print_dx:
	push cx
	mov cx, 0x2
	push dx
	push dx
	push dx
	mov dl, dh
	cycle:
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
		pop dx
		mov dh,dl
		loop cycle
		pop dx
		pop cx
		ret

names db 'AX = 0x$', '; BX = 0x$','; CX = 0x$', '; DX = 0x$', 0xD, 0xA, 'CS = 0x$', '; SS = 0x$','; DS = 0x$','; ES = 0x$', 0xD, 0xA, 'SI = 0x$','; DI = 0x$','; SP = 0x$', '; BP = 0x$', 0xD, 0xA, 'FLAGS = 0x$', 0xD, 0xA, '$'