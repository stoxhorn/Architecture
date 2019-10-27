
    movq (%r13), %rsi
	movq 8(%r13), %rsi
	movq 16(%r13), %rsi
	movq 24(%r13), %rsi
	movq 32(%r13), %rsi
	movq 40(%r13), %rsi
	movq 48(%r13), %rsi
	movq 56(%r13), %rsi
	movq 64(%r13), %rsi
	movq 72(%r13), %rsi
	movq 80(%r13), %rsi
	movq 88(%r13), %rsi
	movq 96(%r13), %rsi
	movq 104(%r13), %rsi
	movq 112(%r13), %rsi
	movq 120(%r13), %rsi
	movq 128(%r13), %rsi
	movq 136(%r13), %rsi
	movq 144(%r13), %rsi
	movq 152(%r13), %rsi
	movq 160(%r13), %rsi


# ========================================================================
# ========================================================================
	addq %rdi, %rsi # make rsi the past-the-end pointer
	push %rsi       # and store it as the top element on the stack
.LparseData_coordinateLoop1:
	cmpq (%rsp), %rdi
	je .LparseData_coordinateLoop_end1
	movq $32, %rsi      # '\t'
	jmp parseNumber1   # increases rdi to point past-the-end of the number
numret1:
	movq %rax, (%rdx)  # store the number
	addq $8, %rdx      # point to the next place for a number
	movq $10, %rsi     # '\n'
	jmp parseNumber2   # increases rdi to point past-the-end of the number
numret2:	
	movq %rax, (%rdx)  # store the number
	addq $8, %rdx      # point to the next place for a number
	jmp .LparseData_coordinateLoop1
.LparseData_coordinateLoop_end1:
	addq $8, %rsp
	jmp doneso


# ========================================================================
# ========================================================================



parseNumber1:
	xorq %rax, %rax    # result
.LparseNumber_loop1:
	xorq %r10, %r10    # the next digit
	movb (%rdi), %r10b # read character
	addq $1, %rdi      # ++data
	cmpq %rsi, %r10    # done with this number?
	je .LparseNumber_loop_end1
	# here we assume that the character is actuall a digit
	# add this digit to the current number
	subq $48, %r10     # convert the ASCII code to the digit it represents
	imul $10, %rax     # 'make room' for the new digit
	addq %r10, %rax    # and add the new digit
	jmp .LparseNumber_loop1
.LparseNumber_loop_end1:
	# we now have a number in rax
	jmp numret1

parseNumber2:
	xorq %rax, %rax    # result
.LparseNumber_loop2:
	xorq %r10, %r10    # the next digit
	movb (%rdi), %r10b # read character
	addq $1, %rdi      # ++data
	cmpq %rsi, %r10    # done with this number?
	je .LparseNumber_loop_end2
	# here we assume that the character is actuall a digit
	# add this digit to the current number
	subq $48, %r10     # convert the ASCII code to the digit it represents
	imul $10, %rax     # 'make room' for the new digit
	addq %r10, %rax    # and add the new digit
	jmp .LparseNumber_loop2
.LparseNumber_loop_end2:
	# we now have a number in rax
	jmp numret2

doneso:
# ========================================================================
# ========================================================================


# ========================================================================
# ========================================================================





# ----------------------- Print the contents of a file
# ------------------------------------------------------------
# ------------------------------------------------------------
# ------------------------------------------------------------
# ------------------------------------------------------------
# ------------------------------------------------------------
# ------------------------------------------------------------
# ------------------------------------------------------------
# ------------------------------------------------------------
# ------------------------------------------------------------
# ------------------------------------------------------------
# ------------------------------------------------------------

.type printArg, @function
.globl printArg
printArg:
    # copying filename to r9, so it can be closed later
    movq $0, %r9
    addq %rdi, %r9
    
    # read a filename and return a filedescriptor in rax
    call getDesc

    # move file descriptor to rdi
    movq %rax, %rdi

    # Read a filedescriptor --- saves contents of descriptor to buff, and prints buff
    call printFile

    ret


# Reads the filedescriptor in r10, and prints it all
.type printFile, @function
.globl printFile
printFile:
     movq %rdi, %r10
loopChar3:

    # move descriptor to argument
    movq %r10, %rdi
    
    call printDChar
    
    cmp $0, %r8
    je endFile3

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
    cmp $0, %r8
    je endFile2

    # move result to argument
    movq %rax, %rdi

    call printChar
# I have reached the end of the descriptor
endFile2:
    movq %r8, %rax
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


