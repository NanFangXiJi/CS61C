1. What do the .data, .word, .text directives mean (i.e. what do you use them for)? Hint: think about the 4 sections of memory.

> The .data means that the program would list some data that should be saved in the `Data Segment` of the memory. The .word means that the program below are pure code which should be saved in the `Text Segment`. The .word means that the length of data after which are one word.

2. Run the program to completion. What number did the program output? What does this number represent?

> It outputs 34. It represents the n.th number of fib array.

3. At what address is n stored in memory? Hint: Look at the contents of the registers.

> `0x10000010` is the address that stores the `n`.

4. Without actually editing the code (i.e. without going into the “Editor” tab), have the program calculate the 13th fib number (0-indexed) by manually modifying the value of a register. You may find it helpful to first step through the code. If you prefer to look at decimal values, change the “Display Settings” option at the bottom.

> `233` is the result.
