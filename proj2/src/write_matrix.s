.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)  # pointer to matrix
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw ra, 16(sp)

    # main logic
    mv s1, a1

    # open file
    mv a1, a0
    li a2, 1
    jal ra, fopen
    li t0, -1
    beq a0, t0, fopen_fail

    mv s0, a0

    # write rows and cols
    mv a1, s0
    addi a2, sp, 8
    li a3, 2
    li a4, 4
    jal ra, fwrite
    li t0, 2
    blt a0, t0, fwrite_fail

    # write matrix
    mv a1, s0
    mv a2, s1
    lw t0, 8(sp)
    lw t1, 12(sp)
    mul a3, t0, t1
    li a4, 4
    jal ra, fwrite
    lw t0, 8(sp)
    lw t1, 12(sp)
    mul t0, t0, t1
    blt a0, t0, fwrite_fail

    # close file
    mv a1, s0
    jal ra, fclose
    bne a0, x0, fclose_fail

    # Epilogue

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw ra, 16(sp)
    addi sp, sp, 20

    ret

fopen_fail:
    li a1, 93
    j exit2

fwrite_fail:
    li a1, 94
    j exit2

fclose_fail:
    li a1, 95
    j exit2
