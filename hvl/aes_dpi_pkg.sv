// Filename: aes_dpi_pkg.sv
//
// Copyright (c) 2013, Intel Corporation
// All rights reserved

package aes_dpi_pkg;

    import "DPI" function void
    aes_encrypt_dpi(
        output bit [127:0] ct,
        input bit [255:0] key,
        int Nk,
        bit [127:0] pt
    );

    import "DPI" function void
    aes_decrypt_dpi(
        output bit [127:0] pt,
        input bit [255:0] key,
        int Nk,
        bit [127:0] ct
    );

endpackage: aes_dpi_pkg
