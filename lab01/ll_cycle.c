#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    if (head == NULL) {
        return 0;
    }

    node *tortoise, *hare;
    tortoise = head;
    hare = head;

    do {
        hare = hare->next;
        if (hare == NULL) {
            return 0;
        }
        hare = hare->next;
        if (hare == NULL) {
            return 0;
        }
        tortoise = tortoise->next;
    } while (hare != tortoise);

    return 1;
}