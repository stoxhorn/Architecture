.section .data
.section .text
.globl _start

_start:
    pop %rax
    pop %rax

#  need a loop that reads all arguments.
loopPop:
    # i pop the argument into r8
    pop %rax
    
    # check if argument = 0, leave loop
    cmp $0, %rax
    je loopOut

    # move argument to %rdi as a function argument 
    movq %rax, %rdi
    
    # call function
    call intFromString

    # move result to arg for next funciton
    movq %rax, %rdi
    call printNum
    
    jmp loopPop
    
    
loopOut:


    movq $60, %rax            # rax: int syscall number
	movq $0, %rdi             # rdi: int error code
	syscall
