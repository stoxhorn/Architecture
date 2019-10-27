.globl sum
.type sum, @function
sum:
    # Clear rax for result
    movq $0, %rax

    # i need to add all numbers below rax, together.
    
loopAdd:
    addq %rdi, %rax


    # decrease Iterator with 1
    subq $1, %rdi

    # compare itetor to 0
    cmp $0, %rdi
    jne loopAdd

    # otherwise, exit function
    ret
