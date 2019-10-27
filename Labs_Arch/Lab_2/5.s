.section .data
    nl: .string "\n"
    Str: .string "string"
    nul: .string "\0"
    buff: .space 20
.section .text
.globl _start


_start:
# How to understand the Read System call:
    movq $buff, %rsi # read to buffer
    movq $0, %rax # read a file
    movq $0, %rdi # read from stdin
    movq $20, %rdx           
    syscall

    call printLn
    call printStr
    call printLn

    movq $buff, %rsi
    movq $1, %rax
    movq $1, %rdi      
    movq $20, %rdx           
    syscall

    
    call printLn

    movq $60, %rax            # rax: int syscall number
	movq $0, %rdi             # rdi: int error code
	syscall

.type printStr @function
.globl printStr
printStr:

    movq $Str, %rsi
    movq $1, %rax
    movq $1, %rdi      
    movq $6, %rdx           
    syscall
    ret

.type printLn @function
.globl printLn
printLn:

    movq $nl, %rsi
    movq $1, %rax
    movq $1, %rdi      
    movq $1, %rdx           
    syscall
    ret
