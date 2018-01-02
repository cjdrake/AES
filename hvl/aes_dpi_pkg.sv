// Filename: aes_dpi_pkg.sv
//
// Copyright (c) 2013, Intel Corporation
// All rights reserved

package aes_dpi_pkg;

    import "DPI-C" function void
    aes_encrypt_dpi(
        input int Nk,
        output bit [127:0] ct,
        input bit [127:0] pt,
        input bit [255:0] key
    );

    import "DPI-C" function void
    aes_decrypt_dpi(
        input int Nk,
        output bit [127:0] pt,
        input bit [127:0] ct,
        input bit [255:0] key
    );

endpackage: aes_dpi_pkg
