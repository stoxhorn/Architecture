.section .data
    Hello: .String "Hello world/n"
.section .text
.globl _start

_start:
	# I need to count the amount of letters in Hello
    # Each letter fills 8 bytes.
    # i need a loop, to iterate through each letter, and a counter/iterator
    
    # iterator
    movq $0, %r8

    # clearing rbx, r10 and rax	
	movq $0, %rbx
	movq $0, %r10
	movq $0, %rax

    # moving the value in Hello, to r10
    movq $Hello, %r10
	

# Loop
loop1:
    # increase iterator by 1
    addq $1, %r8

    # Load the next r8 bytes into lowest byte of rbx
    movb -1(%r10, %r8, 1), %bl
	
    # compare this byte to the value of 0
    # loop if not 0
    cmp $0, %bl
    jne loop1
    # break if 0 

    # move iterator into rax
    movq %r8, %rax


	call printNum          # print the RAX register
	
    
    movq $60, %rax            # rax: int syscall number
	movq $0, %rdi             # rdi: int error code
	syscall



