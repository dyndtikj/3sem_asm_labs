use16                       
org 100h  

call Open_f;
jb error_msg
mov bx,[File_id]  
mov ah, 2
mov al, 1
mov ch, 0
mov cl, 1
mov dh, 0
mov dl, 80h;
mov bx, Buffer 
int 13h;
jb error_msg
      
call file_to_char    

mov ah,40h  
mov bx,[File_id]        
mov dx,Buffer2         
mov cx,620h    ; (32 байта символов + 16 пробелов + 1 перенос)*32   
int 21h 
jb error_msg

call close_file;

exit:
mov ax,4C00h
int 21h ;Завершение программы

Open_f:
    push dx
    mov ah,3Ch              
    mov dx,File_name        
    xor cx,cx              
    int 21h 
    jb error_msg                
    mov [File_id],ax
    pop dx
    ret  
         
 
close_file:
    mov ah,3Eh              
    mov bx,[File_id]  
    int 21h        
    jb error_msg         
    ret

file_to_char:
    push cx;
    mov cx,20h
    mov si,Buffer2
    mov di,Buffer
    lp1:
        push cx;
        mov cx, 0x10;
        lp2:
            mov bl, byte[es:di]
            inc di
            call Hex_to_c ; 2 symbols from bl to dx
            mov word[ds:si], dx
            add si,2;
            mov byte[ds:si], 20h; ' '
            inc si
        loop lp2;
        mov byte[ds:si], 0x0D;
        inc si;
        pop cx
    loop lp1
    pop cx
    ret;

Hex_to_c:
    push ax
    mov dh, bl 
    mov dl,dh
    and dh, 0xF
    cmp dh, 0x9
    ja m1
    add dh, 0x30
    jmp m2
m1:
    add dh, 0x37

m2:
    and dl, 0xF0
    shr dl, 4
    cmp dl, 0x9
    ja m3
    add dl, 0x30
    jmp m4

m3:
    add dl, 0x37
m4:
    pop ax
    ret

error_msg:
    mov ah,9
    mov dx,s_error
    int 21h
    jmp exit
    ret

Buffer db 200h dup(32)
Buffer2 db 620h dup(32)
File_name db 'VlasovMM.txt',0
s_error   db 'Error!',13,10,'$'
File_id rw 1;    Дескриптор