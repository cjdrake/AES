// Filename: aes_dpi.c
//
// Copyright (c) 2013, Intel Corporation
// All rights reserved

#include <svdpi.h>
#include <svdpi_src.h>

#include "aes.h"

void aes_encrypt_dpi(svBitVecVal * ct, svBitVecVal * key, int Nk, svBitVecVal * pt)
{
    int i;

    byte_t KEY[32];
    byte_t RKEY[240];
    byte_t PT[16], CT[16];

    byte_t * bp;
    word_t * wp;

    // Number of 32-bit words comprising the Cipher Key.
    // For this standard, Nk = 4, 6, or 8. (Sec 6.3)
    bp = (byte_t *) key;
    for (i = 0; i < 4*Nk; i++) KEY[i] = *bp++;

    bp = (byte_t *) pt;
    for (i = 0; i < 16; i++) PT[i] = *bp++;

    KeyExpansion(KEY, RKEY, Nk);
    Cipher(PT, CT, RKEY, Nk);

    wp = (word_t *) CT;
    for (i = 0; i < 4; i++) ct[i] = *wp++;
}

void aes_decrypt_dpi(svBitVecVal * pt, svBitVecVal * key, int Nk, svBitVecVal * ct)
{
    int i;

    byte_t KEY[32];
    byte_t RKEY[240];
    byte_t PT[16], CT[16];

    byte_t * bp;
    word_t * wp;

    // Number of 32-bit words comprising the Cipher Key.
    // For this standard, Nk = 4, 6, or 8. (Sec 6.3)
    bp = (byte_t *) key;
    for (i = 0; i < 4*Nk; i++) KEY[i] = *bp++;

    bp = (byte_t *) ct;
    for (i = 0; i < 16; i++) CT[i] = *bp++;

    KeyExpansion(KEY, RKEY, Nk);
    InvCipher(CT, PT, RKEY, Nk);

    wp = (word_t *) PT;
    for (i = 0; i < 4; i++) pt[i] = *wp++;
}
