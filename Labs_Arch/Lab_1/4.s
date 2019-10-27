.section .data
.section .text
.globl _start

_start:
	# Write your solution code here

    # Counter set to 42
    movq $42, %r8
    # resetting result to 0
    movq $0, %r9
    

# Start loop:
loopa:
    # jump to label for check modolus 5
    jmp mod5

# return from check 5
rtrn5:
    # jump to label for check modolus 3
    jmp mod3
rtrn3:
    # jump to extchck
    jmp extchck

# check if counter is divisible by 5, there is a rest of 0
# if rest = 0, jmp to addition
mod5:
    # rax / rcx, rest in rdx.
    # rax = counter
    movq $0, %rax
    addq %r8, %rax
    
    movq $5, %rcx
    movq $0, %rdx

    idivq %rcx

    # when rest is 0, jump to addone
    cmpq $0, %rdx
    je addone
    # otherwise jump to rtrn5
    jmp rtrn5

# check if counter is divisible by 3, there is a rest of 0
# if rest = 0, jmp to addition
mod3:
    # rax / rcx, rest in rdx.
    # rax = counter
    movq $0, %rax
    addq %r8, %rax

    movq $3, %rcx
    movq $0, %rdx

    idivq %rcx

    # when rest is 0, jump to addone
    cmpq $0, %rdx
    je addone
    # otherwise jump to rtrn3
    jmp rtrn3

# add the counter to the result, and jump to extchck
addone:
    addq %r8, %r9
    jmp extchck




# subtracts one, and exits loop, once counter has reached 0
extchck:
    # subtract 1, and ready up for next loop
    subq $1, %r8
    cmpq $0, %r8
    jne loopa

    movq %r9, %rax
	call print_rax            # print the RAX register
	# Syscall exit
	movq $60, %rax            # rax: int syscall number
	movq $0, %rdi             # rdi: int error code
	syscall


# Prints the contents of rax.
.type print_rax, @function   # This is for debugging
print_rax:
	# function prolog
	push %rbp
	movq %rsp, %rbp

	# saving registers the registers on the stack
	push %rax
	push %rcx
	push %rdx
	push %rdi
	push %rsi
	push %r9

	movq $6, %r9           # we always print the 6 characters "RAX: \n"
	push $10               # put '\n' on the stack

loop1:
	movq $0, %rdx
	movq $10, %rcx
	idivq %rcx             # idiv alwas divides rdx:rax/operand
						   # result is in rax, remainder in rdx
	addq $48, %rdx         # add 48 to remainder to get corresponding ASCII
	push %rdx              # save our first ASCII char on the stack
	addq $1, %r9           # counter
	# loop until rax = 0
	cmpq $0, %rax   
	jne loop1

	# and then push the prefix of our output
	movq $0x20, %rax       # ' '
	push %rax
	movq $0x3a, %rax       # ':'
	push %rax
	movq $0x58, %rax       # 'X'
	push %rax
	movq $0x41, %rax       # 'A"
	push %rax
	movq $0x52, %rax       # 'R'
	push %rax

print_loop:
	movq $1, %rax          # Here we make a syscall. 1 in rax designates a sys_write
	movq $1, %rdi          # rdx: int file descriptor (1 is stdout)
	movq %rsp, %rsi        # rsi: char* buffer (rsp points to the current char to write)
	movq $1, %rdx          # rdx: size_t count (we write one char at a time)
	syscall                # instruction making the syscall
	addq $8, %rsp          # set stack pointer to next char
	addq $-1, %r9
	jne print_loop

	# restore the previously saved registers
	pop %r9
	pop %rsi
	pop %rdi
	pop %rdx
	pop %rcx
	pop %rax

	# function epilog
	movq %rbp, %rsp
	pop %rbp
	ret
