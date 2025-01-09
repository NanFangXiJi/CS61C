.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    
    li t0, 5
    bne a0, t0, arg_num_error

    addi sp, sp, -60
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 52(sp)
    sw s5, 56(sp)

    sw a2, 20(sp)

    lw s0, 4(a1)
    lw s1, 8(a1)
    lw s2, 12(a1)
    lw s3, 16(a1)

	# =====================================
    # LOAD MATRICES
    # =====================================






    # Load pretrained m0

    mv a0, s0
    addi a1, sp, 24
    addi a2, sp, 28
    jal ra, read_matrix
    mv s0, a0


    # Load pretrained m1

    mv a0, s1
    addi a1, sp, 32
    addi a2, sp, 36
    jal ra, read_matrix
    mv s1, a0


    # Load input matrix

    mv a0, s2
    addi a1, sp, 40
    addi a2, sp, 44
    jal ra, read_matrix
    mv s2, a0


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    lw t0, 24(sp)
    lw t1, 44(sp)
    mul t0, t0, t1
    sw t0, 48(sp)  # length of 1's output
    slli a0, t0, 2
    jal ra, malloc
    beq a0, x0, malloc_fail
    mv s4, a0  # pointer to result of 1

    mv a0, s0
    lw a1, 24(sp)
    lw a2, 28(sp)
    mv a3, s2
    lw a4, 40(sp)
    lw a5, 44(sp)
    mv a6, s4
    jal ra, matmul

    mv a0, s4
    lw a1, 48(sp)
    jal ra, relu

    lw t0, 32(sp)
    lw t1, 44(sp)
    mul t0, t0, t1
    slli a0, t0, 2
    jal ra, malloc
    beq a0, x0, malloc_fail
    mv s5, a0  # pointer to result of 3

    mv a0, s1
    lw a1, 32(sp)
    lw a2, 36(sp)
    mv a3, s4
    lw a4, 24(sp)
    lw a5, 44(sp)
    mv a6, s5
    jal ra, matmul

    


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

    mv a0, s3
    mv a1, s5
    lw a2, 32(sp)
    lw a3, 44(sp)
    jal ra, write_matrix


    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax

    lw t0, 24(sp)
    lw t1, 44(sp)
    mul a1, t0, t1
    mv a0, s5
    jal ra, argmax
    mv s3, a0


    lw t0, 20(sp)
    bne t0, x0, function_end

    # Print classification
    
    mv a1, s3
    jal ra, print_int

    # Print newline afterwards for clarity

    li a1, '\n'
    jal ra, print_char

function_end:
    mv a0, s0
    jal ra, free
    mv a0, s1
    jal ra, free
    mv a0, s2
    jal ra, free
    mv a0, s4
    jal ra, free
    mv a0, s5
    jal ra, free

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 52(sp)
    lw s5, 56(sp)

    addi sp, sp, 60

    ret


arg_num_error:
    li a1, 89
    j exit2

malloc_fail:
    li a1, 88
    j exit2
