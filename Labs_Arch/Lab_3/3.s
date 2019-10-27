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
    
    # iterator argument, needs to be one as we start at fib(1):
    movq $1, %rsi

    # current sum, (base case) 1
    movq $1, %rax

    # No previous sum
    movq $0, %r8

    # calling fibonacci
    call fib
    
    # move result to arg register
    movq %rax, %rdi

    call printNum
    
    jmp loopPop
    
    
loopOut:


    movq $60, %rax            # rax: int syscall number
	movq $0, %rdi             # rdi: int error code
	syscall
