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

logic [3:0] [3:0] [7:0] istate [0:Nr];
logic [3:0] [3:0] [7:0] is_row [0:Nr-1];
logic [3:0] [3:0] [7:0] is_box [0:Nr-1];
logic [3:0] [3:0] [7:0] ik_add [1:Nr-1];

always_comb pt = istate[0];

// first round
`DFFEN(istate[Nr], AddRoundKey(ct, rkey[4*Nr+:4]), valid[Nr], clk)

generate
    for (genvar gi = (Nr-1); gi > 0; gi--) begin: round
        always_comb is_row[gi] = InvShiftRows(istate[gi+1]);
        always_comb is_box[gi] = InvSubBytes(is_row[gi]);
        always_comb ik_add[gi] = AddRoundKey(is_box[gi], rkey[4*gi+:4]);
        `DFFEN(istate[gi], InvMixColumns(ik_add[gi]), valid[gi], clk)
    end: round
endgenerate

// final round
always_comb is_row[0] = InvShiftRows(istate[1]);
always_comb is_box[0] = InvSubBytes(is_row[0]);
`DFFEN(istate[0], AddRoundKey(is_box[0], rkey[0:3]), valid[0], clk)

endmodule: aes_inv_cipher
