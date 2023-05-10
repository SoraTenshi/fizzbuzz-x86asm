section .data
        szFizz: db "Fizz", 0xa
        lenFizz equ $ - szFizz
        szBuzz: db "Buzz", 0xa
        lenBuzz equ $ - szBuzz
        szFb: db "FizzBuzz", 0xa
        lenFb equ $ - szFb
        asciiBuf db 3

section .text
        global _start

_start:
        push ebp
        mov ebp, esp
        sub esp, 16 ; 16 byte sized stack
        mov ecx, 0
        jmp loop_start

print_fb:
        push ecx ; push the counter on the stack
        mov eax, 0x4
        mov ebx, 0x1
        lea ecx, [szFb]
        mov edx, lenFb
        int 0x80
        pop ecx ; restore ecx
        jmp loop_start

print_fizz:
        push ecx ; push the counter on the stack
        mov eax, 0x4
        mov ebx, 0x1
        lea ecx, [szFizz]
        mov edx, lenFizz
        int 0x80
        pop ecx ; restore ecx
        jmp loop_start

print_buzz:
        push ecx ; push the counter on the stack
        mov eax, 0x4
        mov ebx, 0x1
        lea ecx, [szBuzz]
        mov edx, lenBuzz
        int 0x80
        pop ecx ; restore ecx
        jmp loop_start

print_num:
        push ecx ; push the counter on the stack

        ; "itoa"
        mov eax, ecx
        xor edx, edx
        mov ebx, 10
        div ebx ; eax is quotient, edx is remainder

        cmp eax, 0
        je single_digit

        add eax, '0'
        mov byte [asciiBuf], al
        jmp next
single_digit:
        mov byte [asciiBuf], 0x0
next:
        add edx, '0'
        mov byte[asciiBuf+1], dl
        mov byte[asciiBuf+2], 0xa
        ; end itoa

        mov eax, 0x4
        mov ebx, 0x1
        lea ecx, [asciiBuf]
        mov edx, 3
        int 0x80
        pop ecx
        jmp loop_start

loop_start:
        inc ecx
        cmp ecx, 101
        je loop_end

        ; fizzbuzz compare
        mov eax, ecx
        mov ebx, 15
        xor edx, edx ; write into edx
        div ebx ; edx has remainder
        cmp edx, 0
        je print_fb

        ; fizz compare
        mov eax, ecx
        mov ebx, 3
        xor edx, edx ; write into edx
        div ebx ; edx has remainder
        cmp edx, 0
        je print_fizz

        ; buzz compare
        mov eax, ecx
        mov ebx, 5
        xor edx, edx ; write into edx
        div ebx ; edx has remainder
        cmp edx, 0
        je print_buzz
        jmp print_num

loop_end:
        mov eax, 1
        xor ebx, ebx
        int 0x80
        leave
        ret
