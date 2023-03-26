//316082791 nadav elgrabli
#include "ex1.h"
#include <stdbool.h>


//function check if machine is in little or big endian.
int is_big_endian() {
    long a = 1; // little=0x00000001, big=0x01000000
    // look at the byte at the lowest address
    char* x = (char*)&a;
    return *x == 0;
}



// function gets 8 bit number and returns sign magnitude value in int.
// example of run:
// i=0: currentBit=1, power_i_of_two=2^0, value=1, ret=1
// i=1: currentBit=0, power_i_of_two=2^1, value=0, ret=1
// i=2: currentBit=1, power_i_of_two=2^2, value=4, ret=5
int get_sign_magnitude(bool bitArray[8]) {
    int ret = 0;

    int i;
    for (i = 0; i < 7; i++) {
        bool currentBit = bitArray[i];
        // when we left-shift a number by 1 - we basically multiply by two
        // when we left-shift a number by i - we basically multiply by two i times - which means 2^i
        int power_i_of_two = 1 << i;
        int value = currentBit * power_i_of_two;
        ret += value;
    }

    if (bitArray[7]) {
        return -ret;
    }
    return ret;
}


// function gets bit array 8 size and returns the value of the bits in 2 complement
int get_two_comp(bool bitArray[8]) {
    int ret = 0;

    //go over all bits one by one and add 2^i if there is a 1
    int i;
    for (i = 0; i < 7; i++) {
        bool currentBit = bitArray[i];
        int power_i_of_two = 1 << i;
        int value = currentBit * power_i_of_two;
        ret += value;
    }

    // last bit determines if value is negative or positive (multiply by -1)
    int lastBitValue = -1 * (bitArray[7] << 7);
    return ret + lastBitValue;
}