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
    for (genvar gi = 0; gi < Nk; gi++) begin
        always_comb
            rkey_i[gi] = key[32*gi+:32];
    end

    for (genvar gi = Nk; gi < 4*(Nr+1); gi++) begin
        if (gi % Nk == 0)
            always_comb
                rkey_i[gi] = rkey_i[gi-Nk]
                           ^ SubWord(RotWord(rkey_i[gi-1])) ^ RCON[gi/Nk];
        else if (Nk > 6 && (gi % Nk == 4))
            always_comb
                rkey_i[gi] = rkey_i[gi-Nk] ^ SubWord(rkey_i[gi-1]);
        else
            always_comb
                rkey_i[gi] = rkey_i[gi-Nk] ^ rkey_i[gi-1];
    end

    for (genvar gi = 0; gi < 4*(Nr+1); gi++) begin
        `DFFEN(rkey[gi], rkey_i[gi], load, clk)
    end
endgenerate

endmodule: aes_key_expansion
