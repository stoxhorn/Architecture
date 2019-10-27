.section .data
    buff: .space 20
    char: .string "0" 
.section .text
.globl _start

# Reads all given arguments as a file and prints their output
_start:
    call printArgs

    movq $60, %rax            # rax: int syscall number
	movq $0, %rdi             # rdi: int error code
	syscall

.type printArgs, @function
.globl printArgs
printArgs:
    pop %rax
    pop %rax
    pop %rax        
loopArg:
    pop %rdi
        
    # prints the contents of a file specified in end Arg
    call printArg

    cmp $0, %r14
    je endArgs

    jmp loopArg

endArgs:
ret



.type printArg, @function
.globl printArg
printArg:
    # copying filename to r9, so it can be closed later
    movq $0, %r9
    addq %rdi, %r9
    
    # read a filename and return a filedescriptor in rax
    call getFile

    # move file descriptor to r10
    movq %rax, %r10

    # Read a filedescriptor --- saves contents of descriptor to buff, and prints buff
    call printFile

    ret

# reads rax for a filename, and returns a filedescriptor
.type getFile, @function
.globl getFile
getFile:

# returns the file descriptor in rax --- WORKS!!!
    movq $2, %rax # open a file
    movq $0, %rsi # flags        
    movq $0, %rdx # mode    
    syscall
    ret

# Reads the filedescriptor in r10, and prints it all
.type printFile, @function
.globl printFile
printFile:
    movq %r10, %rdi
loopChar3:

    # move descriptor to argument
    movq %r10, %rdi
    
    call saveDChar
    # saves the first char stored in rdi
    # saves amount of bytes saved in r8
    
    # Compare the bytes read with 0
    cmp $0, %r8
    je endFile3

    # move result to argument
    movq %rax, %rdi

    call printChar
    
    jmp loopChar3

endFile3:
    movq %r10, %rdi # file to close        
    movq $3, %rax # close a file
    movq $0, %rsi # flags        
    movq $0, %rdx # mode    
    syscall

    ret

# prints a single byte from a descriptor stored in rdi
# returns 0, when done
.type printDChar, @function
.globl printDChar
printDChar:
    
    # saves the first char stored in rdi
    # saves amount of bytes saved in r9
    call saveDChar

    # i need something that lets me compare outside func
    
    # Compare the bytes read with 0
    cmp $0, %r9
    je endFile2

    # move result to argument
    movq %rax, %rdi

    call printChar
# I have reached the end of the descriptor
endFile2:
    movq %r9, %rax
    ret

# Saves a character from a descriptor in rdi
# returns it in rax, and saves to r9 the amount of bytes saves
.type saveDChar, @function
.globl saveDChar
saveDChar:
    
    movq $0, %rax
    movq %r9, %rsi
    movq $1, %rdx
    syscall
    
    movq %rdi, %r10

    movq %rax, %r8
    movq %r9, %rax
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



# takes a single character in rdi
# and prints it
.type printChar, @function
.globl printChar
printChar:
# movq %rax, %rsi --- prints contents of buff
    movq %rdi, %rsi
    movq $1, %rax
    movq $1, %rdi
    movq $1, %rdx
    syscall
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
