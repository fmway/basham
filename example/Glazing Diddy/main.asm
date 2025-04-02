section .data
    msg1 db 0xa, "P. Diddy is innocent.", 0xa
    len1 equ $ - msg1
    msg2 db 0xa, "P. Diddy is a sigma.", 0xa
    len2 equ $ - msg2

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, len1
    int 0x80
    
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, len2
    int 0x80

    mov eax, 1
    mov ebx, 1945
    int 0x80