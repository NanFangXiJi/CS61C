1. `add t1, s0, x0      # load the address of the array of current node into t1`. Modified into `lw t1, 0(s0)        # load the address of the array of current node into t1`
2. ` add t1, t1, t0      # offset the array address by the count`
Modified into `    slli t3, t0, 2      # offset the array address by the count` `add t1, t1, t3`
3. `jalr s1             # call the function on that value.` Modified into `jalr ra, s1, 0      # call the function on that value.`
4. `la a0, 8(s0)        # load the address of the next node into a0` Modified into `lw a0, 8(s0)        # load the address of the next node into a0`. Also, `lw a1, 0(s1)` is modified into `mv a1, s1`
5. didn't save `t0`, `t1` which are to be used in the future. Modified to save them in the stack.

