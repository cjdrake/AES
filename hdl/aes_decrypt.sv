// Filename: aes_decrypt.sv
//
// Copyright (c) 2013, Intel Corporation
// All rights reserved

`include "flops.svh"

module aes_decrypt
#(
    parameter int Nk=4,
    parameter int Nr=Nk+6
) (
    input logic clk,
    input logic rst_b,
    input logic load,

    input logic [32*Nk-1:0] key,

    input logic [127:0] ct,

    output logic pt_valid,
    output logic [127:0] pt
);

logic valid [0:Nr];
logic [31:0] rkey [4*(Nr+1)];

`DFF_ARN(valid[Nr], load, clk, rst_b, 1'b0)

generate
    for (genvar i = Nr-1; i >= 0; i--) begin
        `DFF_ARN(valid[i], valid[i+1], clk, rst_b, 1'b0)
    end
endgenerate

`DFF_ARN(pt_valid, valid[0], clk, rst_b, 1'b0)

aes_key_expansion #(Nk) key_expansion(.*);
aes_inv_cipher #(Nk) inv_cipher(.*);

endmodule: aes_decrypt
