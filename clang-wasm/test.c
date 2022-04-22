// copy.c
#include <string.h>

int copy(char *input, char *output)
{
    const int length = strlen(input);

    strncpy(output, input, length);

    return length;
}
