.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    li t0, 1
    blt a1, t0, err1
    blt a2, t0, err1
    j no_err1
err1:
    li a1, 72
    j exit2
no_err1:
    blt a4, t0, err2
    blt a5, t0, err2
    j no_err2
err2:
    li a1, 73
    j exit2
no_err2:
    bne a2, a4, err3
    j no_err3
err3:
    li a1, 74
    j exit2
no_err3:
    # Prologue
    addi sp, sp, -44
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw ra, 40(sp)
    
    mv s0, a0  # m0 pointer
    mv s1, a3  # m1 pointer
    mv s2, a6  # d pointer
    mv s3, a2  # the scale of dot mul
    mv s4, a1  # # of result's row
    mv s5, a5  # # of result's column
    mv s6, x0  # loc of row now
    mv s7, x0  # loc of column now
    slli s8, s3, 2  # bytes that should be shift for next row on m0
    slli s9, s5, 2  # bytes that should be shift for next row on m1


outer_loop_start:
    bge s6, s4, outer_loop_end

inner_loop_start:
    bge s7, s5, inner_loop_end
    
    mv a0, s0
    mv a1, s1
    mv a2, s3
    li a3, 1
    mv a4, s3
    
    jal ra, dot
    sw a0, 0(s2)

    # next iteration
    addi s7, s7, 1
    addi s2, s2, 4  # d pointer move
    addi s1, s1, 4
    j inner_loop_start
inner_loop_end:
    mv s7, x0
    addi s6, s6, 1
    add s0, s0, s8
    sub s1, s1, s9
    j outer_loop_start

outer_loop_end:
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw ra, 40(sp)
    addi sp, sp, 44
    
    
    ret
