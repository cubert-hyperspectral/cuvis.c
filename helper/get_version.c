#include <stdio.h>
#include "cuvis.h"

int main() {
    CUVIS_CHAR version[CUVIS_MAXBUF];
    cuvis_version(version);
    printf("%s", version);
    return 0;
}