.section .data
    Str: .string "\n"
.section .text
.globl _start

# Prints out each argument passed
_start:
    pop %rax

loopPop:
    # i pop the argument into r8
    pop %rax
    
    # when rax is 0, exit loop
    cmp $0, %rax
    je exitLp

    movq %rax, %rdi
    # calling printString, rdi is string argument
    call printString

    movq $Str, %rdi
    call printString

    jmp loopPop

exitLp:
    movq $60, %rax            # rax: int syscall number
	movq $0, %rdi             # rdi: int error code
	syscall
