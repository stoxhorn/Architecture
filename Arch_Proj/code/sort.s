.section .data
    nl: .string "\n"
	tab: .string "\t"
.section .text
.globl _start

# Using r15 as a storage for Given file

_start:
    
    pop %rdi
    pop %rdi
    pop %rdi

    call storeArg

	# store length in r15
	movq %rdi, %r15
	# store space in r14
	movq %rax, %r14

	movq %r14, %rdi
	# call printString

	movq $nl, %rdi
	# call printString
	# move to arguments
	movq %r15, %rsi
	movq %r14, %rdi

	# method returning space for coord bytes in rax
	call getCoordSpace

	# move space to r13
	movq %rax, %r13
	
	
	# parseData moves all ascii chars, from r14, to space in r13, as numbers in bits
	movq %r14, %rdi
	movq %r15, %rsi
	movq %r13, %rdx
	call parseData

	# amount of lines has previously been saved as r12

	call insertionSort


	call printArray


	# Now i need to save content to a file. Fuck



# Closing program
    movq $60, %rax            # rax: int syscall number
	movq $0, %rdi             # rdi: int error code
	syscall
# -------- THE END ------------ #


# r12: denotes amount of coordinates
# r13: denotes a space of sets of coordinates, each number filling out 8 bytes, and one set thus 16 bytes. 
.globl insertionSort
.type insertionSort, @function
insertionSort:
# Once done, remember to check if 0-indexing is fucking you over, if not sorting the last number
# using r12 as comparatino for iterator
# iterator = r8, starting at 1, as i compare backwards
	movq $1, %r8
# I need a loop that ends when it has touched every index:
ArrayLoop:
	cmp %r8, %r12
	je doneArray

# Another loops, that loops until it has counted down to current index, to 0
# current iteration moved to r9, which is compared to 0, and decremented each time
	movq %r8, %r9
	addq %r8, %r9
	
	# adding two to iterator, so that i can subtract emmediately after,
	# and get correct number for loop arguments,
	# and to make sure it decrements each loop
	addq $2, %r9
# i need the double, as i cannot write every 16 bytes when extracting
sortLoop:
	subq $2, %r9
	cmp $0, %r9
	je doneSort

	call extract
	
	# jl = >, so if rsi is greater than rdi, do nothing, as rsi is current, and rdi is previous
	cmp %rsi, %rdi
	jl doneSort

	call insert

	# I need to subtract twice, as i cannot wrtie 16 in the extract thingy
	jmp sortLoop

doneSort:

	addq $1, %r8
	jmp ArrayLoop

doneArray:
	ret



# takes amount of coordinates in r12
# takes array to print in r13
# prints out contents
.globl printArray
.type printArray, @function
printArray:

	addq %r12, %r12

	movq $0, %r15
printLoop:
	cmp %r15, %r12
	je donePrint

	movq (%r13, %r15, 8), %rdi
	call printNum

	movq $tab, %rdi
	call printString

	movq 8(%r13, %r15, 8), %rdi
	call printNum

	movq $nl, %rdi
	call printString

	addq $2, %r15
	jmp printLoop

donePrint:
	ret




# inserts into a n index, accoridng to extract from
# r13: is the array to insert to
# r9: current index i'm comparing
# rsi: current index's 2nd number
# rbx: current index's 1st number
# rdi: prev index's 2nd number
# rbp: prev index's 1st number
.globl extract
.type extract, @function
extract:
	# I now have A looping function, and i now need to compare current index, with previous
	# extract current, and previous index
	# Moving 16 bytes each time, as it's a SET of two coords
	# and i'm starting 8 bytes later, for rsi, as it points to the front coord, otherwise
	
	movq 8(%r13, %r9, 8), %rsi
	movq -8(%r13, %r9, 8), %rdi
	
	# extracting the other half afterwards
	movq (%r13, %r9, 8), %rbx
	movq -16(%r13, %r9, 8), %rbp

	ret




# inserts into a n index, accoridng to insertionsort
# r13: is the array to insert to
# r9: current index i'm comparing
# rsi: current index's 2nd number
# rbx: current index's 1st number
# rdi: prev index's 2nd number
# rbp: prev index's 1st number
.globl insert
.type insert, @function
insert:
	# else the previous was highest and i need to swap
	movq %rsi, -8(%r13, %r9, 8)
	movq %rdi, 8(%r13, %r9, 8)
		
	movq %rbx, -16(%r13, %r9, 8) # inserting current into, previous
	movq %rbp, (%r13, %r9, 8) # inserting previous into current
	ret

# calculates needed bytes, by amount of lines in rdi
.globl calcBytes
.type calcBytes, @function
calcBytes:
	# calculate needed amount of bytes
	
	addq %rax, %rdi
	imulq $8, %rdi
	movq %rdi, %rax
	ret


# returns allocated space, to contain coordinates
# as bits, instead of strings
.globl getCoordSpace
.type getCoordSpace, @function
getCoordSpace:
# rsi: length of space
# rdi: space with coordinates inside
	call getLineCount
	# a in rax, = 10 in hex
	movq %rax, %rdi # move result to args
	movq %rax, %r12 # move result to r12, for later use
	call calcBytes # returns amount of bytes needed for allocate
	movq %rax, %rdi # move result to args
	call allocate # allocate anough space for coordinates
	# move space to r13
	movq %rax, %r13

	ret



.globl printNum			# void printNum(int n)
# Pre: n >= 0
.type printNum, @function
printNum:
	movq %rdi, %rax # arg

	movq $1, %r9 # we always print "\n"
	push $32 # '\n'
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



.globl placeholder
.type placeholder, @function
placeholder:

	ret


# ====================================================================UTILS.s===================================================================== #
# ====================================================================UTILS.s===================================================================== #
# ====================================================================UTILS.s===================================================================== #
# ====================================================================UTILS.s===================================================================== #
# ====================================================================UTILS.s===================================================================== #
# ====================================================================UTILS.s===================================================================== #
# ====================================================================UTILS.s===================================================================== #
# ====================================================================UTILS.s===================================================================== #
# ====================================================================UTILS.s===================================================================== #
# ====================================================================UTILS.s===================================================================== #

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

# prints a string stored in rdi
.globl getString
.type getString, @function
getString:
	# rdi: address of a string

	# i have the address of a string
	# i have a method for finding the length of a string
    movq $0, %r8
	call stringLength
	movq %rax, %r8

    # Now i need a way to move
    # the r8 amount of bytes from rdi to rax
	
    movq $1, %rax
	movq %rdi, %rsi
	movq %r8, %rdx
	movq $1, %rdi
	syscall
	ret




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

# reads rdi for a filename, and returns a filedescriptor
.type getDesc, @function
.globl getDesc
getDesc:

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




# ====================================================================fileHandling.s===================================================================== #
# ====================================================================fileHandling.s===================================================================== #
# ====================================================================fileHandling.s===================================================================== #
# ====================================================================fileHandling.s===================================================================== #
# ====================================================================fileHandling.s===================================================================== #
# ====================================================================fileHandling.s===================================================================== #
# ====================================================================fileHandling.s===================================================================== #
# ====================================================================fileHandling.s===================================================================== #
# ====================================================================fileHandling.s===================================================================== #
# ====================================================================fileHandling.s===================================================================== #
# int getFileSize(int fd)
#
# 	Returns the size (in bytes) of the file indicated by the file descriptor.
.section .data
.Lstat: .space 144 # size of the fstat struct
.section .text
.globl getFileSize
.type getFileSize, @function
getFileSize:
	movq $5, %rax # fstat
	# rdi already contains the fd
	movq $.Lstat, %rsi # buffer to write fstat data into
	syscall
	movq $.Lstat, %rax
	movq 48(%rax), %rax # position of size in the struct
	ret

# ====================================================================parsing.s===================================================================== #
# ====================================================================parsing.s===================================================================== #
# ====================================================================parsing.s===================================================================== #
# ====================================================================parsing.s===================================================================== #
# ====================================================================parsing.s===================================================================== #
# ====================================================================parsing.s===================================================================== #
# ====================================================================parsing.s===================================================================== #
# ====================================================================parsing.s===================================================================== #
# ====================================================================parsing.s===================================================================== #
# ====================================================================parsing.s===================================================================== #
# int getLineCount(const char *data, int size)
#
#	Returns the number of '\n' characters in the memory pointed to.
#	'data': the address of the first character to look at.
#	'size': the length of the memory area to scan through.
.globl getLineCount
.type getLinecount, @function
getLineCount:
	# rdi: 'data'
	# rsi: 'size'
	addq %rdi, %rsi         # make rsi the past-the-end pointer
	xorq %rax, %rax         # count = 0
.LgetLineCount_loop:
	cmpq %rdi, %rsi
	je .LgetLineCount_end   # if rdi == rsi: we are done
	movb (%rdi), %dl        # load the next byte
	addq $1, %rdi
	cmpb $0xA, %dl          # is it a newline char?
	jne .LgetLineCount_loop # if not, continue in the buffer
	addq $1, %rax           # completed a number
	jmp .LgetLineCount_loop
.LgetLineCount_end:
	ret


# void parseData(const char *data, int size, int *result)
#
#	Converts the ASCII representation of the coordinates into pairs of numbers.
#	'data': the address of the first character in the ASCII representation.
#	'size': the length of the ASCII representation.
#	'result': the address of a piece of memory big enough to hold the
#		coordinates. If there are n coordinates in the input, the 'result'
#		memory will be an array of 2n 8-byte integers, with alternating x and y
#		coordinates.
#
#	Note, this functions only expects unsigned ints in the input and does not
#	perform any validity checks at all.
.globl parseData
.type parseData, @function
parseData:
	addq %rdi, %rsi # make rsi the past-the-end pointer
	push %rsi       # and store it as the top element on the stack
.LparseData_coordinateLoop:
	cmpq (%rsp), %rdi
	je .LparseData_coordinateLoop_end
	movq $9, %rsi      # '\t'
	call parseNumber   # increases rdi to point past-the-end of the number
	movq %rax, (%rdx)  # store the number
	addq $8, %rdx      # point to the next place for a number
	movq $10, %rsi     # '\n'
	call parseNumber   # increases rdi to point past-the-end of the number
	movq %rax, (%rdx)  # store the number
	addq $8, %rdx      # point to the next place for a number
	jmp .LparseData_coordinateLoop
.LparseData_coordinateLoop_end:
	addq $8, %rsp
	ret

# int parseNumber(const char *&data, char end)
parseNumber:
	xorq %rax, %rax    # result
.LparseNumber_loop:
	xorq %r10, %r10    # the next digit
	movb (%rdi), %r10b # read character
	addq $1, %rdi      # ++data
	cmpq %rsi, %r10    # done with this number?
	je .LparseNumber_loop_end
	# here we assume that the character is actuall a digit
	# add this digit to the current number
	subq $48, %r10     # convert the ASCII code to the digit it represents
	imul $10, %rax     # 'make room' for the new digit
	addq %r10, %rax    # and add the new digit
	jmp .LparseNumber_loop
.LparseNumber_loop_end:
	# we now have a number in rax
	ret


# ====================================================================allocate.s===================================================================== #
# ====================================================================allocate.s===================================================================== #
# ====================================================================allocate.s===================================================================== #
# ====================================================================allocate.s===================================================================== #
# ====================================================================allocate.s===================================================================== #
# ====================================================================allocate.s===================================================================== #
# ====================================================================allocate.s===================================================================== #
# ====================================================================allocate.s===================================================================== #
# ====================================================================allocate.s===================================================================== #
# ====================================================================allocate.s===================================================================== #
# void *allocate(int n)
#
# 	A naive memory allocator that simply retrieves some new space from the OS.
# 	It is not possible to deallocate the memory again.
.globl allocate
.type allocate, @function
allocate:
	push %rdi
	# 1. Find the current end of the data segment.
	movq $12, %rax # brk
	xorq %rdi, %rdi # 0 means we retrieve the current end.
	syscall
	# 2. Add the amount of memory we want to allocate.
	pop %rdi # the argument
	push %rax # current end, which is where the allocated memory will start
	addq %rax, %rdi # compute the new end
	movq $12, %rax # brk
	syscall
	pop %rax # the old end, which is the address of our allocated memory
	ret



# ====================================================================allSpace.s===================================================================== #
# ====================================================================allSpace.s===================================================================== #
# ====================================================================allSpace.s===================================================================== #
# ====================================================================allSpace.s===================================================================== #
# ====================================================================allSpace.s===================================================================== #
# ====================================================================allSpace.s===================================================================== #
# ====================================================================allSpace.s===================================================================== #
# ====================================================================allSpace.s===================================================================== #
# ====================================================================allSpace.s===================================================================== #
# ====================================================================allSpace.s===================================================================== #

# stores a file as a space, pointer, returned in rax
# along with length of content, in rdi
.globl storeArg
.type storeArg, @function
storeArg:

    # read a filename and return a filedescriptor in rax
    call getDesc

    # move file descriptor to rdi
    movq %rax, %rdi

	call storeFile
	movq %r14, %rax
	movq %r15, %rdi
	ret

.globl storeFile
.type storeFile, @function
storeFile:
	# move descriptor to r10, for safekeeping
	movq %rdi, %r10

	
	# get the size of the file
	call getFileSize
	
	# move result to r15 for safekeeping
	movq %rax, %r15
	
	# move filesize to arg
	movq %rax, %rdi
	call allocate

	# move new space to r14
	movq %rax, %r14

# moving to arguments
    # move descriptor to argument
    movq %r10, %rdi
	# i save to space in r14
    movq %r14, %rsi
	# i save r15 amount of bytes
    movq %r15, %rdx
	# i now store the contents in r14
	call storeDesc

	# move descriptor to argument
	movq %r10, %rdi        
	call closeDesc

	ret



# rdi is descriptor, to store from
# rsi is buffer, to save to
# rdx is amount of bytes to save
.globl storeDesc
.type storeDesc, @function
storeDesc:
	# stores r15 amount of bytes in r14, from descriptor
    movq $0, %rax
    syscall    
	ret


# takes a descriptor in rdi as argument
.globl closeDesc
.type closeDesc, @function
closeDesc:
# closes file descriptor
    movq $3, %rax # close a file
    movq $0, %rsi # flags        
    movq $0, %rdx # mode    
    syscall
	ret


