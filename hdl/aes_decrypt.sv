// Filename: aes_decrypt.sv
//
// Copyright (c) 2013, Intel Corporation
// All rights reserved

`include "flops.svh"

module aes_decrypt
#(
    parameter Nk=4,
    parameter Nr=Nk+6
) (
    input logic clk,
    input logic rst_n,

    input logic [32*Nk-1:0] key,

    input logic load,
    input logic [127:0] ct,

    output logic [127:0] pt,
    output logic valid
);

logic [127:0] k_sch [0:Nr];

aes_key_expand #(Nk) key_expand(.*);
aes_inv_cipher #(Nk) inv_cipher(.*);

endmodule: aes_decrypt
