.section .data
    nl: .string "\n"
    nul: .string "\0"
.section .text
.globl _start

_start:
    movq $nul, %rbx
    movq $0, %rbx
    # first i pop the op, as it's irrelevant
    pop %rax
    movq $0, %r12
    movq $-1, %r13
    # i need a loop that pops, and loops, if pop is not 0.
loopPop:
    # i pop the argument into r8
    movq (%rsp, %r12, 8), %r8
    # move argument to the top of the stack
    addq %r8, (%rsp, %r13, 8)
    addq $1, %r12
    subq $1, %r13
    # check if argument = 0, leave loop
    cmp $0, %r8
    jne loopPop

loopInd:
    # print argument
    pop %rax
    movq $0, %r11
    movq $0, %rbx
# need to know how much to print
# counting the number of letters============================================
loopLet:
    movq $0, %rbx

    # Load the next r8 bytes into lowest byte of rbx
    addb (%rax, %r11, 1), %bl
	
    # increase iterator by 1
    addq $1, %r11

    # compare this byte to the value of 0
    # loop if not 0
    cmp $0, %rbx
    jne loopLet

    movq %rax, %rsi
    movq $1, %rax
    movq $1, %rdi      
    movq %r11, %rdx           
    syscall
    call printLn
    
    addq $1, %r13

    cmp $-2, %r13
    jne loopInd




loopLeave:

    movq $60, %rax            # rax: int syscall number
	movq $0, %rdi             # rdi: int error code
	syscall

.type printLn @function
.globl printLn
printLn:

    movq $nl, %rsi
    movq $1, %rax
    movq $1, %rdi      
    movq $1, %rdx           
    syscall
    ret



# prints what is inside r10
.type printRax, @function
.globl printRax
printRax:

    
# iterator for counting letters:
    movq $0, %r11
    movq $0, %rbx
# need to know how much to print
# counting the number of letters============================================
loopLet1:
    
    # Load the next r8 bytes into lowest byte of rbx
    addb (%rax, %r11, 1), %bl
	
    # increase iterator by 1
    addq $1, %r11

    # compare this byte to the value of 0
    # loop if not 0
    cmp $0, %bl
    jne loopLet1

    movq %rax, %rsi
    movq $1, %rax
    movq $1, %rdi      
    movq %r11, %rdx           
    syscall
    ret
 

# Print RDI as an unsigned integer following by a newline.
# Note: the function does not follow the ordinary calling convention,
#       but restores all registers.
.type printNum, @function
.globl printNum
printNum:
	push %rbp
	movq %rsp, %rbp

	# save
	push %rax
	push %rdi
	push %rsi
	push %rdx
	push %rcx
	push %r8
	push %r9

	movq %rdi, %rax # arg

	movq $1, %r9 # we always print "\n"
	push $10 # '\n'
.LprintNum_convertLoop:
	movq $0, %rdx
	movq $10, %rcx
	idivq %rcx
	addq $48, %rdx # '0' is 48
	push %rdx
	addq $1, %r9
	cmpq $0, %rax   
	jne .LprintNum_convertLoop
.LprintNum_printLoop:
	movq $1, %rax # sys_write
	movq $1, %rdi # stdout
	movq %rsp, %rsi # buf
	movq $1, %rdx # len
	syscall
	addq $8, %rsp
	addq $-1, %r9
	jne .LprintNum_printLoop

	# restore
	pop %r9
	pop %r8
	pop %rcx
	pop %rdx
	pop %rsi
	pop %rdi
	pop %rax

	movq %rbp, %rsp
	pop %rbp
	ret


