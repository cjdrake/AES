// Filename: aes_inv_cipher.sv
//
// Copyright (c) 2013, Intel Corporation
// All rights reserved

`include "flops.svh"

module aes_inv_cipher
#(
    parameter int Nk=4,
    parameter int Nr=Nk+6
) (
    input logic clk,
    input logic valid [0:Nr],

    input logic [31:0] rkey [4*(Nr+1)],

    input logic [127:0] ct,
    output logic [127:0] pt
);

import aes_pkg::*;

logic [127:0] prkey [0:Nr];

logic [127:0] istate [0:Nr];
logic [127:0] is_row [0:Nr-1];
logic [127:0] is_box [0:Nr-1];
logic [127:0] ik_add [1:Nr-1];

always_comb pt = istate[0];

// pack round keys
generate
    for (genvar i = 0; i <= Nr; ++i) begin
        always_comb
            prkey[i] = {rkey[4*i+3], rkey[4*i+2], rkey[4*i+1], rkey[4*i+0]};
    end
endgenerate

// zeroth round
`DFFEN(istate[Nr], AddRoundKey(ct, prkey[Nr]), valid[Nr], clk)

generate
    for (genvar i = (Nr-1); i > 0; i--) begin: round
        always_comb is_row[i] = InvShiftRows(istate[i+1]);
        always_comb is_box[i] = InvSubBytes(is_row[i]);
        always_comb ik_add[i] = AddRoundKey(is_box[i], prkey[i]);
        `DFFEN(istate[i], InvMixColumns(ik_add[i]), valid[i], clk)
    end: round
endgenerate

// final round
always_comb is_row[0] = InvShiftRows(istate[1]);
always_comb is_box[0] = InvSubBytes(is_row[0]);
`DFFEN(istate[0], AddRoundKey(is_box[0], prkey[0]), valid[0], clk)

endmodule: aes_inv_cipher
