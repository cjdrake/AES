// Filename: aes_cipher.sv
//
// Copyright (c) 2013, Intel Corporation
// All rights reserved

`include "flops.svh"
`include "aes.svh"

module aes_cipher
#(
    parameter Nk=4,
    parameter Nr=Nk+6
) (
    input logic clk,
    input logic rst_n,

    input logic [127:0] k_sch [0:Nr],

    input logic load,
    input logic [127:0] pt,

    output logic [127:0] ct,
    output logic valid
);

logic [127:0] state [0:Nr];
logic [127:0] s_box [1:Nr];
logic [127:0] s_row [1:Nr];
logic [127:0] m_col [1:Nr-1];

logic valids [0:Nr];

always_comb ct = state[Nr];
always_comb valid = valids[Nr];

`DFFEN(state[0], AddRoundKey(pt, k_sch[0]), load, clk)
`DFF_ARN(valids[0], load, clk, rst_n, 1'b0)

generate
    for (genvar i = 1; i < Nr; ++i) begin: round
        always_comb s_box[i] = SubBytes(state[i-1]);
        always_comb s_row[i] = ShiftRows(s_box[i]);
        always_comb m_col[i] = MixColumns(s_row[i]);
        `DFFEN(state[i], AddRoundKey(m_col[i], k_sch[i]), valids[i-1], clk)
        `DFF_ARN(valids[i], valids[i-1], clk, rst_n, 1'b0)
    end: round
endgenerate

always_comb s_box[Nr] = SubBytes(state[Nr-1]);
always_comb s_row[Nr] = ShiftRows(s_box[Nr]);
`DFFEN(state[Nr], AddRoundKey(s_row[Nr], k_sch[Nr]), valids[Nr-1], clk)
`DFF_ARN(valids[Nr], valids[Nr-1], clk, rst_n, 1'b0)

endmodule: aes_cipher
