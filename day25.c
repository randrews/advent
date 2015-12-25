/* gcc day25.c -o day25 */
#include <stdio.h>

/* Something tells me this is going to involve some huge numbers... */
typedef unsigned long long ulong;

/*
  Okay, let's try to be clever about this.
  If we can figure out what order the cell (3029, 2947) is in, then
  we can just repeat the function that many times and get the answer.
  For each cell in a given diagonal, the sum of x and y coordinates
  will be the same. We know that this sum for (3029, 2947) is 5976.
  Therefore, the row number of column 1 of that diagonal is 5975.
  Column 1 is a fairly simple sequence:
*/

ulong col1(ulong n){
    return (n * (n-1)) / 2 + 1;
}

/*
  So, we know that the cell we're looking for is in column 3029,
  therefore it's col1(5975) + 3028.
*/

ulong cell_val(ulong x, ulong y){
    return col1(x+y-1) + x - 1;
}

/*
  Now for the computationally-heavy part of this. We need to,
  starting with 20151125, do this a bunch of times, a little
  over 17 million:
*/

ulong next_key(ulong key){
    return (key * 252533) % 33554393;
}

int main(int argc, char** argv) {
    ulong key = 20151125;
    ulong num = cell_val(3029, 2947);
    ulong n;

    for(n = 2; n <= num; n++){
        key = next_key(key);
    }

    printf("%llu\n", key); /* And there we go! */
}
