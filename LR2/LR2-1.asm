use16                           ; Для генерации 16 битного кода
org 0x100                       ; Программа под DOS

mov ax,0xb800                   ; Начало памяти видеоадаптера
                                ; Записать в регистр ax число 0xb800h
mov es,ax                       ; Записать в регистр es значение из регистра ax

mov di, 0x4b0			; Начальное смещение
mov si, msg    		        ; Первая буква

mov cx, 12			;
lp:
	movsw			; si+=2 , di += 2
	loop lp
mov ah, 0
int 20h

msg:
 dw 0x0f4d, 0x0f61,0x0f78, 0x0f69, 0x0f6d, 0x0f20, 0x0f56, 0x0f6c, 0x0f61, 0x0f73, 0x0f6f, 0x0f76


