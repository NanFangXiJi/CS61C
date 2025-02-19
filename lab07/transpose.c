#include "transpose.h"

/* The naive transpose function as a reference. */
void transpose_naive(int n, int blocksize, int *dst, int *src) {
    for (int x = 0; x < n; x++) {
        for (int y = 0; y < n; y++) {
            dst[y + x * n] = src[x + y * n];
        }
    }
}

/* Implement cache blocking below. You should NOT assume that n is a
 * multiple of the block size. */
void transpose_blocking(int n, int blocksize, int *dst, int *src) {
    // YOUR CODE HERE
    for (int br = 0; br * blocksize < n; br++) {
        for (int bc = 0; bc * blocksize < n; bc++) {
            for (int x = 0; x < blocksize; x++) {
                for (int y = 0; y < blocksize; y++) {
                    int p1 = x + br * blocksize;
                    int p2 = y + bc * blocksize;
                    if (p1 >= n || p2 >= n) {
                        continue;
                    }
                    dst[p2 + p1 * n] = src[p1 + p2 * n];
                }
            }
        }
    }
}
