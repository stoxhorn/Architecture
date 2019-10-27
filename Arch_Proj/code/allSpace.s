# stores a file as a space, pointer, returned in rax
# along with length of content, in
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
