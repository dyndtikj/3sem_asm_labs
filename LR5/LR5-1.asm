use16
org 100h

pushf
while_wrong:
	push ax;
	push dx;
	mov ah, 0x9
	mov dx, Message
	int 0x21
	pop dx
	pop ax
	call Check_pw;
	jne while_wrong

popf

mov ax,0
int 20h

Check_pw:
	push di
	push dx
	pushf
	mov di, Password;
	call Input_str; // to dx
	popf 
	call Are_equal
	pop dx 
	pop di
	ret;

Input_str:
	push ax
	mov ah, 0ah ; Ввод строки с клавиатуры
	mov dx, Lang_pass_max
	int 21h
	add dx, 2
	pop ax
	ret

Are_equal:
	push cx
	push dx
	push es
	push si
	
	call lengh		;// lengh to cx

	mov si, dx
	repe cmpsb
		jne bad_ret

	jmp good_ret;

	bad_ret:
	mov ah, 0x9
	mov dx, Bad
	int 0x21
	jmp equal_ret;

	good_ret:
	mov ah, 0x9
	mov dx, Good
	int 0x21

	equal_ret:
	pop si
	pop es
	pop dx
	pop cx
	ret;

lengh:
	push ax
	push bx
	push di

	mov al,0x24;		#'$'
	mov cx, 0
	again:
		inc cx;
		scasb
		jne again;
	dec cx

	pop di
	pop bx
	pop ax
	ret

Message db 'Enter a password : $'
Password db 'Aggy2$';
Good db 0xD, 0xA,'Correct, you are welcome!',0xD, 0xA,'$'
Bad db 0xD, 0xA,'Wrong, try again!',0xD, 0xA, '$'

Lang_pass_max db 9 ; Максимольная длина пароля