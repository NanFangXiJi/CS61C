#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "lfsr.h"

void lfsr_calculate(uint16_t *reg) {
    uint16_t a = *reg >> 2;
    uint16_t b = a >> 1;
    uint16_t c = b >> 2;
    uint16_t d = (*reg ^ a ^ b ^ c) & 1;
    uint16_t e = ~((d ^ 1) << 15);
    uint16_t f = d << 15;

    *reg = ((*reg >> 1) | f) & e;
}

