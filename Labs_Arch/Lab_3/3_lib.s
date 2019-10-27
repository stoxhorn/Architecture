.globl fib
.type fib, @function
fib:
    # for recursion, i need 3 arguments
    # 1. rsi: iterator, to check against rdi
        # 1a. i check if iterator is equal to rdi and return if true
        cmp %rsi, %rdi
        je return1
    # 2. r8: previous sum
    # 3. rax: current sum
    
    # clear a tmp register, to contain current sum
    # for use as previous sum on next call
    movq $0, %rdx
    
    # copy current sum to tmp register
    addq %rax, %rdx

    # add previous sum to current sum:
    addq %r8, %rax

    # set arguments:
    # 1. add one to the iterator
    addq $1, %rsi
    # 2. current sum is now previous sum
    movq %rdx, %r8
    # 3. no need to
    call fib

return1:
    ret
