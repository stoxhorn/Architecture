.section .data
    buff: .space 20
    # Str: .string "text.txt"
.section .text
.globl _start

_start:

    pop %rax
    pop %rax
    pop %rax

    # Counts the amount of letter in the first argument, contained in rax
    # returns the amount in r11, and the argument + extra in rax
    call CountLet    

    # copying file descriptor to r9, so it can be closed later
    movq $0, %r9
    addq %rax, %r9
    
    # Read a file descriptor --- saves contents of descriptor to buff, and prints buff
    call printFile
    
    movq %r9, %rdi # file to close        
    movq $3, %rax # close a file
    movq $0, %rsi # flags        
    movq $0, %rdx # mode    
    syscall

    movq $60, %rax            # rax: int syscall number
	movq $0, %rdi             # rdi: int error code
	syscall

# Reads the filedescriptor in rax, and saves the contents to buff
.type printFile, @function
.globl printFile
printFile:
# move file descriptor to rdi
    addq %rax, %rdi
# returns the file descriptor in rax --- WORKS!!!
    movq $2, %rax # open a file
    movq $0, %rsi # flags        
    movq $0, %rdx # mode    
    syscall

# move file descriptor to rdi
    movq %rax, %rdi

# Read a file descriptor --- saves contents of descriptor to buff
      movq $0, %rax
      movq $buff, %rsi
      movq $20, %rdx
      syscall

    movq $0, %rsi
# movq %rax, %rsi --- prints contents of buff
    addq $buff, %rsi
    movq $1, %rax
    movq $1, %rdi
    movq $20, %rdx
    syscall
    ret

# counts the string in rax
# length is stored in r11
.type CountLet @function
.globl CountLet
CountLet:
# my iterator is reset to 0
    movq $0, %r11
# I iterate through the argument to know how long it is
loopLet:
    # need to empty rbx to properly compare
    movq $0, %rbx

    # Load the next r8 bytes into lowest byte of rbx
    addb (%rax, %r11, 1), %bl
	
    # increase iterator by 1
    addq $1, %r11

    # compare this byte to the value of 0
    # loop if not 0
    cmp $0, %rbx
    jne loopLet

    # lessen iterator by one, as it increments one too much
    # don't want to start with neg to be easier to predict
    subq $1, %r11
    ret
