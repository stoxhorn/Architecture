.globl printNum			# void printNum(int n)
# Pre: n >= 0
.type printNum, @function
printNum:
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
	ret

.globl intFromString	# int intFromString(char *str)
# Pre: str != 0
# Pre: all characters in the string are one of 0123456789.
.type intFromString, @function
intFromString:
	xorq %rax, %rax
.LintFromString_loop:
	movzx (%rdi), %rsi # Move a single character/byte %rbx and zero-extend it.
	cmpq $0, %rsi # A string ends with a 0-byte.
	je .LintFromString_done
	movq $10, %rcx # Shift the number 1 decimal place to the left.
	mulq %rcx
	subq $48, %rsi # Convert from ASCII character to number. ASCII '0' has value 48. '1' is 49, etc.
	addq %rsi, %rax # Add the number.
	addq $1, %rdi
	jmp .LintFromString_loop
.LintFromString_done:
	ret


# returns length of string stored in rdi
.globl stringLength
.type stringLength, @function
stringLength:
	# 1. r8: counter
	# 2. rdi: string 
	movq $0, %rbx
	# every call i check next byte
	addb (%rdi, %r8, 1), %bl
	
	# base case:
	# byte = 0
	cmp $0, %bl
    je endRec

	# next case is increase counter by one, and call again
	addq $1, %r8

	# 1. counter is incremented
	# 2. string has not been changed
	call stringLength


endRec:
	movq %r8, %rax
	ret

# prints a string stored in rdi
.globl printString
.type printString, @function
printString:
	# rdi: address of a string
	# 

	# i have the address of a string
	# i have a method for finding the length of a string
    movq $0, %r8
	call stringLength
	movq %rax, %r8

	movq $1, %rax
	movq %rdi, %rsi
	movq %r8, %rdx
	movq $1, %rdi
	syscall
	ret

