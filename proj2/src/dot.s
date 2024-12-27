.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    # Prologue
    li t0, 1
    bge a2, t0, no_err1
    li a1, 75
    j exit2
no_err1:
    blt a3, t0, err2
    blt a4, t0, err2
    j no_err2
err2:
    li a1, 76
    j exit2
no_err2:
    mv t0, a0  # t0 is pointer of v0
    mv t1, a1  # t1 is pointer of v1
    mv t2, x0  # t2 is the location now
    slli t3, a3, 2  # t3 is the bytes that should be shifted on v0
    slli t4, a4, 2  # t4 is the bytes that should be shifted on v1
    mv t5, x0  # t5 is the sum
loop_start:
    bge t2, a2, loop_end
    lw a3, 0(t0)
    lw a4, 0(t1)
    mul a3, a3, a4
    add t5, t5, a3
    addi t2, t2, 1
    add t0, t0, t3
    add t1, t1, t4
    j loop_start
loop_end:
    mv a0, t5
    ret
