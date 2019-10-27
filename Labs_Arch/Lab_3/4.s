.section .data
.section .text
.globl _start


# Prints out the length of each argument given
_start:
    pop %rax
    pop %rax

    # i pop the argument into r8
    pop %rax
    
    # check if argument = 0, leave loop
    cmp $0, %rax
    je exitr

    # currently first argument is stored in rax
    # i need to call the stringLength in utils

    # move result to arg for next funciton
    movq %rax, %rdi
    
    # iterator argument, needs to be one as we start at fib(1):
    movq $0, %r8

    movq $1, %rbx

    # calling stringLength
    call stringLength
retu:

    # move result to arg register
    movq %rax, %rdi

    call printNum

exitr:
    movq $60, %rax            # rax: int syscall number
	movq $0, %rdi             # rdi: int error code
	syscall
