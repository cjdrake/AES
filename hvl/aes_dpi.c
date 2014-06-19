// Filename: aes_dpi.c
//
// Copyright (c) 2013, Intel Corporation
// All rights reserved

#include <svdpi.h>
#include <svdpi_src.h>

#include "aes.h"

void
aes_encrypt_dpi(int Nk, svBitVecVal * bv_ct, svBitVecVal * bv_pt, svBitVecVal * bv_key)
{
    int i;

    byte_t key[32];
    byte_t rkey[240];
    byte_t pt[16], ct[16];

    byte_t * bp;
    word_t * wp;

    // Number of 32-bit words comprising the Cipher Key.
    // For this standard, Nk = 4, 6, or 8. (Sec 6.3)
    bp = (byte_t *) bv_key;
    for (i = 0; i < 4*Nk; i++) key[i] = *bp++;

    bp = (byte_t *) bv_pt;
    for (i = 0; i < 16; i++) pt[i] = *bp++;

    KeyExpansion(Nk, rkey, key);
    Cipher(Nk, ct, pt, rkey);

    wp = (word_t *) ct;
    for (i = 0; i < 4; i++) bv_ct[i] = *wp++;
}

void
aes_decrypt_dpi(int Nk, svBitVecVal * bv_pt, svBitVecVal * bv_ct, svBitVecVal * bv_key)
{
    int i;

    byte_t key[32];
    byte_t rkey[240];
    byte_t pt[16], ct[16];

    byte_t * bp;
    word_t * wp;

    // Number of 32-bit words comprising the Cipher Key.
    // For this standard, Nk = 4, 6, or 8. (Sec 6.3)
    bp = (byte_t *) bv_key;
    for (i = 0; i < 4*Nk; i++) key[i] = *bp++;

    bp = (byte_t *) bv_ct;
    for (i = 0; i < 16; i++) ct[i] = *bp++;

    KeyExpansion(Nk, rkey, key);
    InvCipher(Nk, pt, ct, rkey);

    wp = (word_t *) pt;
    for (i = 0; i < 4; i++) bv_pt[i] = *wp++;
}
