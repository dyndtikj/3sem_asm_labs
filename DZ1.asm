use16
org 0x100

mov dx, msg1;
call My_func;

mov ax, 0
int 20h

My_func:
	push cx
	push dx
	push bx
	push di

	call lengh; в di помещается длина строки из dx
	mov cx, 0xFF
	mov bx, 0
	lp1:
		push ax
		; смещение бегущей строки на экране
		call Print_empty;
		; печать строки (в dx лежит адрес строки)
		mov ah, 0x9
		int 0x21
		; задержка (sleep)
		call Delay
		; очистка экрана
		mov ax, 0x3
		int 10h

		pop ax
		loop lp1;
	pop di
	pop bx
	pop dx;
	pop cx;
	ret;
; процедура вывода 'пробелов', кол-во которых лежит в регистре bx
; каждый раз происходит взятие остатка от деления bx на (80-lengh+1)
; так как если bx==80 - lengh, то нужно вывести все эти пробелы, чтобы
; чтобы оставшиеся lengh символов были доступны для строки
; таким образом ни один символ строки не будет напечатан на строке ниже
Print_empty:
	push ax
	push cx
	push dx
	push di

	mov al, bl
	mov bl, 0x50
	sub bx, di;
	inc bx
	div bl
	mov bl, ah

	mov cx, 0
	lp4:
		cmp cx, bx 
		jae my_ret
		mov ah, 0x2
		mov dl, ' '
		int 21h
		inc cx;
		jmp lp4;
		
	my_ret:	
		pop di
		pop dx
		pop cx
		inc bx
		pop ax
		ret;
;процедура для подсчета кол-ва символов до символа '$', результат в di
lengh:
	push ax
	push dx
	push cx

	mov di, dx
	mov al,0x24;		#'$'
	mov cx, 0
	again:
		inc cx;
		scasb
		jne again;
	dec cx
	mov di, cx
	pop cx
	pop dx
	pop ax
	ret
	
Delay:
	push cx
	push ax
	push dx
	push bx
	push di
	mov ah, 0

	int 0x1a;
.Wait:
	push dx
	mov ah, 0
	int 0x1a
	pop bx
	cmp bx, dx
	je .Wait

	pop di
	pop bx
	pop dx
	pop ax
	pop cx
	ret;
; Если нужна большая задержка 1,2,3..*55 мс
; mov cx, 5
; lp3:
; .Wait:
; 	push cx
; 	push dx
; 	mov ah, 0
; 	int 0x1a
; 	pop bx
; 	cmp bx, dx
; 	pop cx
; 	je .Wait
; 	loop lp3;
; 	pop di
;  	pop bx
;  	pop dx
;  	pop ax
;  	pop cx
; 	ret

msg1 db 'TEST$'

