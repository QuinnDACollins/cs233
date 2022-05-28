/**
 * @file
 * Contains an implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include <assert.h>
#include "extractMessage.h"

using namespace std;

unsigned char *extractMessage(const unsigned char *message_in, int length) {
    // length must be a multiple of 8
    assert((length % 8) == 0);
    // allocate an array for the output
    unsigned char *message_out = new unsigned char[length];
    /*
    If you want access bit N:

    Get: (INPUT >> N) & 1;

    Set: INPUT |= 1 << N;

    Unset: INPUT &= ~(1 << N);

    Toggle: INPUT ^= 1 << N;
    */
    //for each character in out string, we need to iterate, grabbing the 
    unsigned char mask = 1;
    /*message_out[0] |= ((message_in[0] >> 0) & mask) << 0;
    message_out[0] |= ((message_in[1] >> 0) & mask) << 1;
    message_out[0] |= ((message_in[2] >> 0) & mask) << 2;
    //all teh way to 8
    message_out[1] |= ((message_in[0] >> 1) & mask) << 0;*/
    for(int l = 0; l < length/8; l++){
        for(int i = 8 * l; i < (l+1)*8; i++){
            for(int y = 8 * l; y < (l+1)*8; y++){
                message_out[i] |= ((message_in[y] >> i % 8) & mask) << y % 8;
            }
        }
    }
    return message_out;
}
