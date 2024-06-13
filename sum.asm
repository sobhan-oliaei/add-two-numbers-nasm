section	.data

firstmsg db 'enter ', 0x22,'+', 0x22,' to sum 2 numbers :', 0xa ;a message to print
firstmsglen equ $ - firstmsg ;the length of above message to print

askonemsg db 'enter number 1 :', 0xa ;a message to print
askonemsglen equ $ - askonemsg ;the length of above message to print

asktwomsg db 'enter number 2 :', 0xa ;a message to print
asktwomsglen equ $ - asktwomsg ;the length of above message to print

errormsg db 'error!', 0xa
errormsglen equ $ - errormsg

answermsg db 'the answer is : '
answermsglen equ $ - answermsg

numres db '        ', 0xa ;the result variable

section .bss

ourop resb 2 ; options variable
numone resb 8 ; first number variable
numonelen resb 2 ; length of first number variable
numtwo resb 8 ; second number variable
numtwolen resb 2 ; length of second number variable
numtwocounter resb 2 ; a counter variable for numtwo loops in sum


section	.text
   global _start    
	
_start:

    mov eax, 4
    mov ebx, 1
    mov ecx, firstmsg
    mov edx, firstmsglen
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, ourop
    mov edx, 2
    int 80h

    mov al, [ourop + 1]
    cmp al, 10
    jne _exit

    mov al, [ourop]
    cmp al, '+'
    je _summing

    jmp _exit

_summing:

    mov eax, 4
    mov ebx, 1
    mov ecx, askonemsg
    mov edx, askonemsglen
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, numone
    mov edx, 8
    int 80h

    mov esi, 0
    mov cl, 0
_get_size:
    mov al, [numone + esi]
    cmp al, 30h
    jl _check_ten_one
_back_to_get_size_one:
    cmp al, 39h
    jg _check_ten_two
_back_to_get_size_two:
    inc cl
    inc esi
    cmp al, 10
    jne _get_size
    sub cl, 1
    mov [numonelen], cl
    cmp cl, 0
    jle _exit
    cmp cl, 7
    jg _exit

    mov eax, 4
    mov ebx, 1
    mov ecx, asktwomsg
    mov edx, asktwomsglen
    int 80h

    mov eax, 3
    mov ebx, 0
    mov ecx, numtwo
    mov edx, 8
    int 80h

    mov esi, 0
    mov cl, 0
_get_size_two:
    mov al, [numtwo + esi]
    cmp al, 30h
    jl _check_ten_one_two
_back_to_get_size_one_two:
    cmp al, 39h
    jg _check_ten_two_two
_back_to_get_size_two_two:
    inc cl
    inc esi
    cmp al, 10
    jne _get_size_two
    sub cl, 1
    mov [numtwolen], cl
    cmp cl, 0
    jle _exit
    cmp cl, 7
    jg _exit

    mov cl, [numonelen]
    cmp cl, [numtwolen]
    jl _exit

    mov dx, 0
    
    mov dx, [numtwolen]
    mov [numtwocounter], dx
    
    mov ecx, 0
    mov esi, 0
    mov si, [numonelen]
    mov cx, [numonelen]
    mov dx, 0
_sum_loop:
    mov al, [numone + esi - 1]
    sub al, 30h
    push esi
    mov esi, 0
    mov si, [numtwocounter]
    cmp esi, 1
    jl _set_number_two
    mov bl, [numtwo + esi - 1]
_sum_loop_cont_withoutb:
    sub bl, 30h
    dec esi
    mov [numtwocounter], si
    pop esi
    add al, bl
    cmp dl, 0
    jne _add_to_al
_sum_loop_cont:
    cmp al, 9h
    jg _add_to_dl
_sum_loop_cont_two:
    add al, 30h
    mov [numres + esi], al
    dec esi
    loop _sum_loop
    cmp dl, 1h
    je _add_one_to_first
_sum_cont:

    mov eax, 4
    mov ebx, 1
    mov ecx, answermsg
    mov edx, answermsglen
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, numres
    mov edx, 9
    int 80h

    mov eax, 1
    mov ebx, 0
    int 80h

_check_ten_one:

    cmp al, 10
    je _back_to_get_size_one
    jmp _exit


_check_ten_two:

    cmp al, 10
    je _back_to_get_size_two
    jmp _exit


_check_ten_one_two:

    cmp al, 10
    je _back_to_get_size_one_two
    jmp _exit


_check_ten_two_two:

    cmp al, 10
    je _back_to_get_size_two_two
    jmp _exit

_add_to_dl:

    mov dl, 1h
    sub al, 10
    jmp _sum_loop_cont_two

_add_to_al:

    add al, 1h
    mov dl, 0h
    jmp _sum_loop_cont

_add_one_to_first:
    
    add dl, 30h
    mov [numres + esi], dl
    jmp _sum_cont

_set_number_two:

    mov bl, 30h
    jmp _sum_loop_cont_withoutb

_exit:

    mov eax, 4
    mov ebx, 1
    mov ecx, errormsg
    mov edx, errormsglen
    int 80h

    mov eax, 1
    mov ebx, 0
    int 80h