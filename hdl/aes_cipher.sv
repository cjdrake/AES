// Filename: aes_cipher.sv
//
// Copyright (c) 2013, Intel Corporation
// All rights reserved

`include "flops.svh"

module aes_cipher
#(
    parameter int Nk=4,
    parameter int Nr=Nk+6
) (
    input logic clk,
    input logic valid [0:Nr],

    input logic [31:0] rkey [4*(Nr+1)],

    input logic [127:0] pt,
    output logic [127:0] ct
);

import aes_pkg::*;

logic [3:0] [3:0] [7:0] state [0:Nr];
logic [3:0] [3:0] [7:0] s_box [1:Nr];
logic [3:0] [3:0] [7:0] s_row [1:Nr];
logic [3:0] [3:0] [7:0] m_col [1:Nr-1];

always_comb ct = state[Nr];

// first round
`DFFEN(state[0], AddRoundKey(pt, rkey[0:3]), valid[0], clk)

generate
    for (genvar i = 1; i < Nr; i++) begin: round
        always_comb s_box[i] = SubBytes(state[i-1]);
        always_comb s_row[i] = ShiftRows(s_box[i]);
        always_comb m_col[i] = MixColumns(s_row[i]);
        `DFFEN(state[i], AddRoundKey(m_col[i], rkey[4*i+:4]), valid[i], clk)
    end: round
endgenerate

// final round
always_comb s_box[Nr] = SubBytes(state[Nr-1]);
always_comb s_row[Nr] = ShiftRows(s_box[Nr]);
`DFFEN(state[Nr], AddRoundKey(s_row[Nr], rkey[4*Nr+:4]), valid[Nr], clk)

endmodule: aes_cipher
