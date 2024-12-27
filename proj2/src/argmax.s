.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    
    # Prologue
    li t0, 1
    bge a1, t0, no_err
    li a1, 77
    j exit2
no_err:
    mv t0, a0  # t0 is pointer
    mv t1, x0  # t1 is the current location
    li t2, 0xffffffff  # t2 is the max number
    mv t3, x0  # t3 is the max location
loop_start:
    bge t1, a1, loop_end
    lw t4, 0(t0)  # t4 is the value of the pointer
    bge t2, t4, loop_continue
    mv t2, t4
    mv t3, t1
loop_continue:
    addi t0, t0, 4
    addi t1, t1, 1
    j loop_start
loop_end:
    mv a0, t3
    # Epilogue
    ret
