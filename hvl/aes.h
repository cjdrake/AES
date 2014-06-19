/*
** Filename: aes.h
**
** Reference: http://csrc.nist.gov/publications/fips/fips197/fips-197.pdf
*/

#ifndef AES_H
#define AES_H

#include <stdint.h>

/*
** Number of columns (32-bit words) comprising the state.
**
** See section 6.3
*/
#define Nb 4

#define xtime(x) (((x) << 1) ^ ((((x) >> 7) & 0x1) * 0x1b))

/*
** Matrix multiply operator
**
** See section 4.2.1
*/
#define Multiply(x, y) ( \
      (((y)      & 0x1) * (x)) \
    ^ (((y) >> 1 & 0x1) * xtime((x))) \
    ^ (((y) >> 2 & 0x1) * xtime(xtime((x)))) \
    ^ (((y) >> 3 & 0x1) * xtime(xtime(xtime((x))))) \
    ^ (((y) >> 4 & 0x1) * xtime(xtime(xtime(xtime((x)))))) \
)

typedef uint32_t word_t;
typedef uint8_t  byte_t;

void KeyExpansion(word_t *key, word_t *rkey, int Nk);
void Cipher(byte_t in[4*Nb], byte_t out[4*Nb], word_t * rkey, int Nk);
void InvCipher(byte_t in[4*Nb], byte_t out[4*Nb], word_t * rkey, int Nk);

#endif // AES_H
