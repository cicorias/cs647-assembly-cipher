                                        # Author: Ettore Forigo - Hexwell
 
.intel_syntax noprefix
 
.text
.globl main
main:
.PROLOGUE:
    push    rbp
    mov rbp, rsp
    sub rsp, 32
    mov QWORD PTR [rbp-32], rsi         # argv
 
.BODY:
    mov BYTE PTR [rbp-1], 0             # shift = 0
 
    .I_LOOP_INIT:
        mov BYTE PTR [rbp-2], 0         # i = 0
        jmp .I_LOOP_CONDITION           # I_LOOP_CONDITION
    .I_LOOP_BODY:
        movzx edx, BYTE PTR[rbp-1]      # shift
        mov eax, edx                    # shift
        sal eax, 2                      # shift << 2 == i * 4
        add eax, edx                    # shift * 4 + shift = shift * 5
        add eax, eax                    # shift * 5 + shift * 5 = shift * 10
        mov ecx, eax                    # shift * 10
        mov rax, QWORD PTR [rbp-32]     # argv
        add rax, 8                      # argv + 1
        mov rdx, QWORD PTR [rax]        # argv[1]
        movzx eax, BYTE PTR [rbp-2]     # i
        add rax, rdx                    # argv[1] + i
        movzx eax, BYTE PTR [rax]       # argv[1][i]
        add eax, ecx                    # shift * 10 + argv[1][i]
        sub eax, 48                     # shift * 10 + argv[1][i] - '0'
        mov BYTE PTR [rbp-1], al        # shift = shift * 10 + argv[1][i] - '0'
    .I_LOOP_INCREMENT:
        movzx eax, BYTE PTR [rbp-2]     # i
        add eax, 1                      # i + 1
        mov BYTE PTR [rbp-2], al        # i++
    .I_LOOP_CONDITION:
        mov rax, QWORD PTR [rbp-32]     # argv
        add rax, 8                      # argv + 1
        mov rax, QWORD PTR [rax]        # argv[1]
        movzx edx, BYTE PTR [rbp-2]     # i
        add rax, rdx                    # argv[1] + i
        movzx rax, BYTE PTR [rax]       # argv[1][i]
        test al, al                     # argv[1][i]?
        jne .I_LOOP_BODY                # I_LOOP_BODY
 
    .CAESAR_LOOP_INIT:
        mov BYTE PTR [rbp-2], 0         # i = 0
        jmp .CAESAR_LOOP_CONDITION      # CAESAR_LOOP_CONDITION
    .CAESAR_LOOP_BODY:
        mov rax, QWORD PTR [rbp-32]     # argv
        add rax, 16                     # argv + 2
        mov rdx, QWORD PTR [rax]        # argv[2]
        movzx eax, BYTE PTR [rbp-2]     # i
        add rax, rdx                    # argv[2] + i
        mov rbx, rax                    # argv[2] + i
        movzx eax, BYTE PTR [rax]       # argv[2][i]
        cmp al, 32                      # argv[2][i] == ' '
        je .CAESAR_LOOP_INCREMENT       # CAESAR_LOOP_INCREMENT
        movzx edx, BYTE PTR [rbx]       # argv[2][i]
        mov ecx, edx                    # argv[2][i]
        movzx edx, BYTE PTR [rbp-1]     # shift
        add edx, ecx                    # argv[2][i] + shift
        sub edx, 97                     # argv[2][i] + shift - 'a'
        mov BYTE PTR [rbx], dl          # argv[2][i] = argv[2][i] + shift - 'a'
        movzx eax, BYTE PTR [rbx]       # argv[2][i]
        cmp al, 25                      # argv[2][i] <=> 25
        jle .CAESAR_RESTORE_ASCII       # <= CAESAR_RESTORE_ASCII
        movzx edx, BYTE PTR [rbx]       # argv[2][i]
        sub edx, 26                     # argv[2][i] - 26
        mov BYTE PTR [rbx], dl          # argv[2][i] = argv[2][i] - 26
    .CAESAR_RESTORE_ASCII:
        movzx edx, BYTE PTR [rbx]       # argv[2][i]
        add edx, 97                     # argv[2][i] + 'a'
        mov BYTE PTR [rbx], dl          # argv[2][i] = argv[2][i] + 'a'
    .CAESAR_LOOP_INCREMENT:
        movzx eax, BYTE PTR [rbp-2]     # i
        add eax, 1                      # i + 1
        mov BYTE PTR [rbp-2], al        # i++
    .CAESAR_LOOP_CONDITION:
        mov rax, QWORD PTR [rbp-32]     # argv
        add rax, 16                     # argv + 2
        mov rdx, QWORD PTR [rax]        # argv[2]
        movzx eax, BYTE PTR [rbp-2]     # i
        add rax, rdx                    # argv[2] + i
        movzx eax, BYTE PTR [rax]       # argv[2][i]
        test al, al                     # argv[2][i]?
        jne .CAESAR_LOOP_BODY           # CAESAR_LOOP_BODY
 
    mov rax, QWORD PTR [rbp-32]         # argv
    add rax, 16                         # argv + 2
    mov rax, QWORD PTR [rax]            # argv[2]
    mov rdi, rax                        # argv[2]
    call    puts                        # puts(argv[2])
 
.RETURN:
    mov eax, 0                          # 0
    leave
    ret                                 # return 0
