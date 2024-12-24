1. The register representing the variable k.

> `t0` is the very register.

2. The register representing the variable sum.

> `s0` is the very register.

3. The registers acting as pointers to the source and dest arrays.

> `s1` -> source, `s2` -> dest.

4. The assembly code for the loop found in the C code.

>   ```
>   loop:
>   slli s3, t0, 2
>   add t1, s1, s3
>   lw t2, 0(t1)
>   beq t2, x0, exit
>   add a0, x0, t2
>   addi sp, sp, -8
>   sw t0, 0(sp)
>   sw t2, 4(sp)
>   jal fun
>   lw t0, 0(sp)
>   lw t2, 4(sp)
>   addi sp, sp, 8
>   add t2, x0, a0
>   add t3, s2, s3
>   sw t2, 0(t3)
>   add s0, s0, t2
>   addi t0, t0, 1
>   jal x0, loop
>   ```

5. How the pointers are manipulated in the assembly code.

> The `k` or `t0` will left shift for 2 to act as multiply 4. Then, use the result of that calculation stored in register `s3` as  an offset. Each address of an array adds this offset and get the actual address of the location that of the k.th digit of the array.
