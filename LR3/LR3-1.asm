use16
org 0x100

	mov di, 0x3;   		#Номер строки (1 – 25)
	mov si, 0x28;		#Номер столбца (1- 80)
	mov dh, 0x0f;		#Атрибуты символа
	mov dl, 0x4d;  		#ASCII код символа
	
	call print
	int 20h
	
print:
	push di;			# значения заданных регистров кладутся в стэк
	push si;
	push dx;
	
	mov al, 0xA0; 		#160 dec = A0h
	mul di;			#Byte*Byte, result to ax
	
	push ax;		#Положили в стэк, чтобы затем прибавить к этому числу смещение в столбце
	mov ah, 0;
	mov al, 0x2;
	mul si;			#Умножили на 2, результат в ax
	pop bx;			
	add bx, ax;		#Получили смещение в видеобуффере
	
	mov ax,0xb800		        
	mov ds,ax
	mov si,bx	
	pop dx;			# начальные значения регистров вынимаем из стэка
	
	mov word [ds:si], dx;
	pop si
	pop di
	ret;

