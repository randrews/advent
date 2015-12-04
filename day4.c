    #include <stdlib.h>
    #include <string.h>
    #include <stdio.h>
    #include <openssl/md5.h>
    
    int main(int argc, char** argv){
        if(argc < 2){
            printf("You forgot the stem.\n");
            return 1;
        }
    
        int prefix_len = strlen(argv[1]);
        char *prefix = malloc(prefix_len + 50);
    
        *prefix = 0;
        sprintf(prefix, "%s", argv[1]);
    
        unsigned long num = 0;
    
        unsigned char *sum = malloc(16);
        int part1 = 0;
    
        while(1){
            num++;
            sprintf(prefix + prefix_len, "%lu", num);
            MD5(prefix, strlen(prefix), sum);
    
            if(num % 1000000 == 0) printf("%lu\n", num);
    
            if(!sum[0] && !sum[1] && sum[2] < 0x10) {
                if(!part1) {
                    printf("Part 1 solution: %lu\n", num);
                    part1 = 1;
                }
    
                if(sum[2] == 0) {
                    printf("Part 2 solution: %lu\n", num);
                    if(part1) break;
                }
            }
        }
    
        return 0;
    }
