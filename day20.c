/*
  gcc -o day20 day20.c -lm --std gnu99 -O
  It will take a few minutes to run
 */
#include <stdio.h>
#include <math.h>

long present_count(long house_num);
long present_count2(long house_num);

int main(int argc, char **argv){
    long goal = 29000000;
    long n = 1;

    while(1){
        long t = present_count(n);
        if(t >= goal){
            printf("\nPart 1: %ld\n", n);
            break;
        }
        if(n%1000 == 0) printf(".");
        if(n%10000 == 0) printf("\n");
        n++;
    }

    while(1){
        long t = present_count2(n);
        if(t >= goal){
            printf("\nPart 2: %ld\n", n);
            break;
        }
        if(n % 1000 == 0) printf(".");
        if(n % 10000 == 0) printf("\n");
        n++;
    }
}

long present_count(long house_num){
    long curr = 1;
    long total = house_num;
    long half = house_num/2;

    while(curr <= half){
        if(house_num % curr == 0){
            total += curr;
        }
        curr++;
    }

    return total * 10;
}

long present_count2(long house_num){
    long curr = (house_num/50 == 0 ? 1 : house_num/50);
    long total = house_num;
    long stop = house_num/2;

    while(curr <= stop){
        if(house_num % curr == 0 && house_num <= curr*50){
            total += curr;
        }
        curr++;
    }

    return total * 11;
}
