use16                       
org 100h
 
mov ah, 0x9
mov dx, Header;
int 0x21
mov ebx,0 
again:
	mov ax,0xE820;
	mov edx,0x534D4150
	mov ecx,14h 
	mov di,Buf;
	int 15h
	jc error_msg;

	jc error_msg;
	mov eax,dword[es:di];
	add di,8;
	call print_eax;
	mov eax,dword[es:di];
	call print_eax;
	add di,8
	mov ax,word[es:di];
	call print_ax;

	cmp ebx,0;
	jne again;

exit:
mov ax,4C00h
int 21h ;Завершение программы

print_eax:
    push ax
    mov ah, 0x9
    mov dx, Hex;
    int 0x21
    pop ax
    push eax;
    shr eax,24;
    mov dh,al;
    call print_dh;
    pop eax
    push eax;
    shr eax,16;
    mov dh,al;
    call print_dh;
    pop eax
    push eax;
    shr eax,8;
    mov dh,al;
    call print_dh;
    pop eax

    mov dh,al;
    call print_dh;

    mov ah, 0x9
    mov dx, Space
    int 0x21
    ret;
    
print_ax:
    push ax
    mov ah, 0x9
    mov dx, Hex;
    int 0x21
    pop ax
	push ax;
    shr ax,8;
    mov dh,al;
    call print_dh;
    pop ax
    mov dh,al;
    call print_dh;
    mov ah, 0x9
    mov dx, Next;
    int 0x21
	ret;

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
    pop ax
    pop dx
    ret

error_msg:
    mov ah,9
    mov dx,s_error
    int 21h
    jmp exit

Header db 'Basic adr  | Lengh      | type', 0xD,0xA, '$'
s_error db 'Error! Cant read mmap!',13,10,'$'
Buf rb 14h 
Hex db '0x$'
Space db ' | $'
Next db 0xD,0xA, '$'
