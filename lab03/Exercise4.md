1. What caused the errors in simple_fn, naive_pow, and inc_arr that were reported by the Venus CC checker?

> For simple_fn: `mv a0, t0` use the t0 that was not set by this function.
>
> For naive_pow: This function modified register `s0` but it didn't keep its value before or restore its value.
>
> For inc_arr: This function modified `s0` and `s1` without reservation, and it calls function without save the register `t0` that is still to be used.

2. In RISC-V, we call functions by jumping to them and storing the return address in the ra register. Does calling convention apply to the jumps to the naive_pow_loop or naive_pow_end labels?

> No, they are just the labels in a function. It should not be called by other function.

3. Why do we need to store ra in the prologue for inc_arr, but not in any other function?

> Because the function `inc_arr` called other function. They will modify the `ra` to store their own return address.

4. Why wasn’t the calling convention error in helper_fn reported by the CC checker? (Hint: it’s mentioned above in the exercise instructions.)

> I don't know, it is actually reported in my machine.
