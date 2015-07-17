// Filename: aes_dpi.c
//
// Copyright (c) 2013, Intel Corporation
// All rights reserved

#include <svdpi.h>

#include "aes.h"

void
aes_encrypt_dpi(
    int Nk, // {4, 6, 8}
    svBitVecVal * bv_ct, // output bit [127:0] ct
    svBitVecVal * bv_pt, // input  bit [127:0] pt
    svBitVecVal * bv_key // input  bit [255:0] key
    )
{
    int i;

    word_t key[8]; // Nk
    word_t rkey[Nb*(8+6+1)]; // Nb*(Nk+6+1)
    byte_t pt[16], ct[16];

    byte_t * bp;
    word_t * wp;

    wp = (word_t *) bv_key;
    for (i = 0; i < Nk; ++i) key[i] = *wp++;

    bp = (byte_t *) bv_pt;
    for (i = 0; i < 16; ++i) pt[i] = *bp++;

    KeyExpansion(Nk, rkey, key);
    Cipher(Nk, ct, pt, rkey);

    wp = (word_t *) ct;
    for (i = 0; i < 4; ++i) bv_ct[i] = *wp++;
}

void
aes_decrypt_dpi(
    int Nk, // {4, 6, 8}
    svBitVecVal * bv_pt, // output bit [127:0] pt
    svBitVecVal * bv_ct, // input  bit [127:0] ct
    svBitVecVal * bv_key // input  bit [255:0] key
    )
{
    int i;

    word_t key[8]; // Nk
    word_t rkey[Nb*(8+6+1)]; // Nb*(Nk+6+1)
    byte_t pt[16], ct[16];

    byte_t * bp;
    word_t * wp;

    wp = (word_t *) bv_key;
    for (i = 0; i < Nk; ++i) key[i] = *wp++;

    bp = (byte_t *) bv_ct;
    for (i = 0; i < 16; ++i) ct[i] = *bp++;

    KeyExpansion(Nk, rkey, key);
    InvCipher(Nk, pt, ct, rkey);

    wp = (word_t *) pt;
    for (i = 0; i < 4; ++i) bv_pt[i] = *wp++;
}
