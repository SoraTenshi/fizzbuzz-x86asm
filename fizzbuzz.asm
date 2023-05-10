section .data
        szFizz: db "Fizz"
        lenFizz equ $ - szFizz
        szBuzz: db "Buzz"
        lenBuzz equ $ - szBuzz
        szLf: db 0xa
        lenLf equ $ - szLf
        asciiBuf db 2

section .text
        global _start

_start:
        push ebp
        mov ebp, esp
        sub esp, 4 ; 4 byte sized stack
        mov ecx, 0
        jmp loop_start

print_fizz:
        push ecx ; push the counter on the stack
        mov eax, 0x4
        mov ebx, 0x1
        lea ecx, [szFizz]
        mov edx, lenFizz
        int 0x80
        pop ecx ; restore ecx

        mov eax, ecx
        mov ebx, 15
        xor edx, edx ; write into edx
        div ebx ; edx has remainder
        cmp edx, 0
        je print_buzz
        jmp print_lf

print_buzz:
        push ecx ; push the counter on the stack
        mov eax, 0x4
        mov ebx, 0x1
        lea ecx, [szBuzz]
        mov edx, lenBuzz
        int 0x80
        pop ecx ; restore ecx
        jmp print_lf

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
        ; end itoa

        mov eax, 0x4
        mov ebx, 0x1
        lea ecx, [asciiBuf]
        mov edx, 2
        int 0x80
        pop ecx
        jmp print_lf

print_lf: 
        push ecx
        mov eax, 0x4
        mov ebx, 0x1
        lea ecx, [szLf]
        mov edx, lenLf
        int 0x80
        pop ecx
        jmp loop_start

loop_start:
        inc ecx
        cmp ecx, 101
        je loop_end

        ; fizzbuzz compare
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
