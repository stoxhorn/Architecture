.section .data
.section .text
.globl _start

_start:
	# Write your solution code here
    movq $42, %rdi

	call printNum            # print the RAX register
	# Syscall exit
	movq $60, %rax            # rax: int syscall number
	movq $0, %rdi             # rdi: int error code
	syscall
