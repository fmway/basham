section .data
    msg     db "skibidi sigma boy", 10
    msg_len equ $ - msg

section .text
    global _start

_start:
    mov ecx, 10

print_loop:
    mov eax, 4
    mov ebx, 1
    mov edx, msg_len
    mov ecx, msg
    int 0x80

    dec ecx
    jnz print_loop

    mov eax, 1
    xor ebx, ebx
    int 0x80
