.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -24
    sw s0, 0(sp)  # file discriptor
    sw s1, 4(sp)  # pointer to the rows
    sw s2, 8(sp)  # pointer to the cols
    sw s3, 12(sp)  # length of the matrix on bytes scale
    sw s4, 16(sp)  # the pointer to the matrix
    sw ra, 20(sp)

    # main logic
    mv s1, a1
    mv s2, a2

    # call fopen to have a file discriptor
    mv a1, a0
    li a2, 0
    jal ra, fopen
    li t0, -1
    beq a0, t0, fopen_fail

    mv s0, a0

    # read rows and cols
    mv a1, s0
    mv a2, s1
    li a3, 4
    jal ra, fread
    li t0, 4
    bne a0, a0, fread_fail

    mv a1, s0
    mv a2, s2
    li a3, 4
    jal ra, fread
    li t0, 4
    bne a0, a0, fread_fail

    lw t1, 0(s1)
    lw t2, 0(s2)
    mul s3, t1, t2
    slli s3, s3, 2

    # use malloc to get a buffer to save matrix
    mv a0, s3
    jal ra, malloc
    beq a0, x0, malloc_fail
    mv s4, a0

    # read matrix
    mv a1, s0
    mv a2, s4
    mv a3, s3
    jal ra, fread
    bne a0, s3, fread_fail

    # close file
    mv a1, s0
    jal ra, fclose
    bne a0, x0, fclose_fail

    # set return value
    mv a0, s4

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24

    ret

malloc_fail:
    li a1, 88
    j exit2

fopen_fail:
    li a1, 90
    j exit2

fread_fail:
    li a1, 91
    j exit2

fclose_fail:
    li a1, 92
    j exit2
