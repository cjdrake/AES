// Filename: aes_key_expansion.sv
//
// Copyright (c) 2013, Intel Corporation
// All rights reserved

`include "flops.svh"

module aes_key_expansion
#(
    parameter int Nk=4,
    parameter int Nr=Nk+6
) (
    input logic clk,
    input logic load,

    input logic [32*Nk-1:0] key,
    output logic [31:0] rkey [4*(Nr+1)]
);

import aes_pkg::*;

logic [31:0] rkey_i [4*(Nr+1)];

generate
    for (genvar i = 0; i < Nk; i++) begin
        always_comb
            rkey_i[i] = key[32*i+:32];
    end

    for (genvar i = Nk; i < 4*(Nr+1); i++) begin
        if (i % Nk == 0)
            always_comb
                rkey_i[i] = rkey_i[i-Nk]
                           ^ SubWord(RotWord(rkey_i[i-1])) ^ RCON[i/Nk];
        else if (Nk > 6 && (i % Nk == 4))
            always_comb
                rkey_i[i] = rkey_i[i-Nk] ^ SubWord(rkey_i[i-1]);
        else
            always_comb
                rkey_i[i] = rkey_i[i-Nk] ^ rkey_i[i-1];
    end

    for (genvar i = 0; i < 4*(Nr+1); i++) begin
        `DFFEN(rkey[i], rkey_i[i], load, clk)
    end
endgenerate

endmodule: aes_key_expansion
