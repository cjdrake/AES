// Filename: aes_inv_cipher.sv
//
// Copyright (c) 2013, Intel Corporation
// All rights reserved

`include "flops.svh"
`include "aes.svh"

module aes_inv_cipher
#(
    parameter Nk=4,
    parameter Nr=Nk+6
) (
    input logic clk,
    input logic rst_n,

    input logic [127:0] k_sch [0:Nr],

    input logic load,
    input logic [127:0] ct,

    output logic [127:0] pt,
    output logic valid
);

logic [127:0] istate [0:Nr];
logic [127:0] is_row [0:Nr-1];
logic [127:0] is_box [0:Nr-1];
logic [127:0] ik_add [1:Nr-1];

logic valids [0:Nr];

always_comb pt = istate[0];
always_comb valid = valids[0];

// InvCipher (5.3)
`DFFEN(istate[Nr], AddRoundKey(ct, k_sch[Nr]), load, clk)
`DFF_ARN(valids[Nr], load, clk, rst_n, 1'b0)

generate
    for (genvar i = (Nr-1); i > 0; --i) begin: round
        always_comb is_row[i] = InvShiftRows(istate[i+1]);
        always_comb is_box[i] = InvSubBytes(is_row[i]);
        always_comb ik_add[i] = AddRoundKey(is_box[i], k_sch[i]);
        `DFFEN(istate[i], InvMixColumns(ik_add[i]), valids[i+1], clk)
        `DFF_ARN(valids[i], valids[i+1], clk, rst_n, 1'b0)
    end: round
endgenerate

always_comb is_row[0] = InvShiftRows(istate[1]);
always_comb is_box[0] = InvSubBytes(is_row[0]);
`DFFEN(istate[0], AddRoundKey(is_box[0], k_sch[0]), valids[1], clk)
`DFF_ARN(valids[0], valids[1], clk, rst_n, 1'b0)

endmodule: aes_inv_cipher
