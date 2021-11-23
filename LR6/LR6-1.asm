use16                       
org 100h                    

mov di,0h
call print_addr; (dump from es:di)

exit:
mov ax,4C00h
int 21h ;Завершение программы

Open_f:
    push dx
    mov ah,3Ch              
    mov dx,File_name        
    xor cx,cx              
    int 21h                 
    mov [File_id],ax
    jb error_msg
    pop dx
    ret  

print_addr:         
    push dx
    push cx
    push ax
    push di

    call Open_f
    
    mov cx,0x10
    lp1:

        push cx
        mov cx, 0x10

        lp2:
            push cx             ;вывод двух hex чисел
            mov bx,[File_id]              
            mov ah,40h 
            mov dh, byte[es:di];
            call Hex_to_c;      ; из каждого шест-ого числа из dh делает символ и записывает два ASCII кода в SYMBOLS
            
            mov dx,Symbols          
            mov cx,2        
            int 21h 

            mov ah,40h          ;вывод пробела
            mov [Symbols],0x20
            mov dx,Symbols          
            mov cx,1        
            int 21h 

            inc di;
            pop cx
        loop lp2

        mov ah,40h              ; вывод переноса строки
        mov [Symbols],0xA
        mov dx,Symbols          
        mov cx,1        
        int 21h 
        
        pop cx
        loop lp1

    call close_file
    pop di
    pop ax
    pop cx
    pop dx
    ret              
 
close_file:
    mov ah,3Eh              
    mov bx,[File_id]  
    int 21h        
    jb error_msg         
    ret

Hex_to_c:
    push ax
    mov dl,dh
    and dl, 0xF
    cmp dl, 0x9
    ja m1
    add dl, 0x30
    jmp m2
m1:
    add dl, 0x37

m2:
    and dh, 0xF0
    shr dh, 4
    cmp dh, 0x9
    ja m3
    add dh, 0x30
    jmp m4

m3:
    add dh, 0x37
m4:
    mov [Symbols],dx
    pop ax
    ret

error_msg:
    mov ah,9
    mov dx,s_error
    int 21h
    jmp exit
    ret

File_name db 'VlasovMM.txt',0
s_error   db 'Error!',13,10,'$'
File_id rw 1;    Дескриптор
Symbols rw 1;    Буффер для 2 символов
