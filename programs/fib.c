#include <stdio.h>
#include <stdlib.h>

int main() {
    int x = 0;    
    int y = 1;
    while (x < 255) {
        printf("%d %02x\n", x, x);
        int z = y;
        y = x + y;
        x = z;
    }
    return 0;
}
