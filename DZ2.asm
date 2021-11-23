use16                       
org 100h  

init:
	mov ax,len-Scan_codes
	mov [len], ax
	push es
	mov ax, 0x3515
	int 21h

	mov [Save1], bx
	mov [Save2], es

	pop es
	mov ax, 0x2515;
	mov dx, my_0x15
	int 21h;

testing:
; вывод того, что ожидается ввод
mov dx, Greeting
mov	ah, 9h
int	21h
mov dx, Press
int	21h

mov cx,200
call Delay


recovery:
	push ds
	mov dx, [Save1]
	mov ax, [Save2]
	mov ds,ax;
	mov ax, 0x2515;
	int 21h;
	pop ds
exit:
	mov dx, Finish
	mov	ah, 9h
	int	21h

	mov ax, 0
	int 0x20;

my_0x15:
	pusha
	pushf

	mov cx,0
	push cs
	pop ds

	lp3:
		mov di, Scan_codes
		add di,cx
		cmp al, byte[ds:di]
		je good
		inc cx;
		cmp cx, [len]
		jl lp3
	jmp return;
	
	good:
	call make_beep;

return:
 	popf
	popa
	iret

make_beep:
	pusha
	mov al, 0xb6
	out 0x43, al

	mov ax, (1190000/440) 
	out 0x42, al
	mov al, ah
	out 0x42, al
	; включили 
	in al, 0x61
	or al, 00000011b
	out 0x61, al

	; Ожидаем изменение 2 измененения по ~55 ms
	mov cx,2
	call Delay;
	
	; выключили
 	in al, 0x61
	and al, 11111100b
	out 0x61, al 
	popa
	ret

Delay:
	push cx
	push ax
	push dx
	push bx
	push di
	push cx
	mov ah, 0

	int 0x1a;
	pop cx
lp2:
.Wait:
	push cx
	push dx
	mov ah, 0
	int 0x1a
	pop bx
	cmp bx, dx
	pop cx
	je .Wait
	loop lp2;
	pop di
 	pop bx
 	pop dx
 	pop ax
 	pop cx
	ret

Greeting:	db 'Beep for every symbolic key', 10, 13, '$'
Press:		db 'You have 10 seconds to input different keys and hear a sound for symbols', 10, 13, '$'
Finish:		db 'END',10, 13,'$'

Scan_codes:	db 0x29, 0x2,0x3,0x4,0x5,0x6,0x7,0x8,0x9,0xA,0xB,0xC,0xD,\
			   0x10,0x11,0x12,0x12,0x13,0x14,0x15,0x15,0x16,0x17,0x18,0x19,0x1A,0x1B,\
			   0x1E, 0x1F,0x20,0x21,0x22,0x23,0x23,0x24,0x25,0x26,0x27,0x28,\
			   0x2C,0x2D,0x2E,0x2F,0x30,0x31,0x32,0x33,0x34, 0x35,0x39;
len dw 0;
Save1: dw 0
Save2: dw 0
