#include "declarations.h"

void
t2(float *A, float *B) {
    for (int nl = 0; nl < 10000000; nl ++) {
        for (int i = 0; i < LEN2 - 4; i += 5) {
            A[i] = B[i] * A[i];
            A[i + 1] = B[i + 1] * A[i + 1];
            A[i + 2] = B[i + 2] * A[i + 2];
            A[i + 3] = B[i + 3] * A[i + 3];
            A[i + 4] = B[i + 4] * A[i + 4];
        }
        A[0] ++;
    }
}
