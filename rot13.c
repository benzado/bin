#include <stdio.h>

/* cc -o rot13 rot13.c */

int main(int argc, char *argv[])
{
    int c = 0;

    while ((c = getchar()) != -1) {
        if (('a' <= c) && (c <= 'z')) {
            c = (((c - 'a') + 13) % 26) + 'a';
        }
        else if (('A' <= c) && (c <= 'Z')) {
            c = (((c - 'A') + 13) % 26) + 'A';
        }
        putchar(c);
    }

    return 0;
}
