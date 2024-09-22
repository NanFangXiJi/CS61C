#include <stdio.h>
#include "bit_ops.h"

// Return the nth bit of x.
// Assume 0 <= n <= 31
unsigned get_bit(unsigned x,
                 unsigned n) {
    unsigned a = 1 << n;
    unsigned b = x & a;
    return (b >> n) & 1;
}
// Set the nth bit of the value of x to v.
// Assume 0 <= n <= 31, and v is 0 or 1
void set_bit(unsigned * x,
             unsigned n,
             unsigned v) {
    unsigned a = v << n;
    unsigned b = ~((v ^ 1) << n);
    *x = (*x | a) & b;
}
// Flip the nth bit of the value of x.
// Assume 0 <= n <= 31
void flip_bit(unsigned * x,
              unsigned n) {
    *x = *x ^ (1 << n);
}

