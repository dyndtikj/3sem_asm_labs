use16
org 0x100

mov bx, 0x0
mov es, bx
mov di, 0x28
int 0x84;	дамп памяти по адресу es:di

mov ax, 0
int 0x20;
