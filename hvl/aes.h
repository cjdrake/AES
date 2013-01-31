// Filename: aes.h
//
// Copyright (c) 2013, Intel Corporation
// All rights reserved
//
// Reference: http://www.csrc.nist.gov/publications/fips/fips197/fips-197.pdf

#ifndef AES_H
#define AES_H

#include <stdint.h>

// Number of columns (32-bit words) comprising the state.
// For this standard, Nb = 4. (Sec 6.3)
#define Nb 4

#define BITS_PER_BYTE 8
#define BITS_PER_WORD 32
#define BYTES_PER_WORD 4

#define BIT_MASK 0x1
#define BYTE_MASK 0xFF

#define xtime(x) ( ((x) << 1) ^ ((((x) >> 7) & BIT_MASK) * 0x1b) )

#define Multiply(x, y) ( (((y)      & BIT_MASK) * (x)) \
                       ^ (((y) >> 1 & BIT_MASK) * xtime((x))) \
                       ^ (((y) >> 2 & BIT_MASK) * xtime(xtime((x)))) \
                       ^ (((y) >> 3 & BIT_MASK) * xtime(xtime(xtime((x))))) \
                       ^ (((y) >> 4 & BIT_MASK) * xtime(xtime(xtime(xtime((x)))))) )

typedef uint32_t word_t;
typedef uint8_t  byte_t;

void KeyExpansion(word_t *key, word_t *rkey, int Nk);
void Cipher(byte_t in[4*Nb], byte_t out[4*Nb], word_t * rkey, int Nk);
void InvCipher(byte_t in[4*Nb], byte_t out[4*Nb], word_t * rkey, int Nk);

#endif // AES_H
