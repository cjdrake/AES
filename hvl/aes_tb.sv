// Filename: aes_tb.sv
//
// Copyright (c) 2013, Intel Corporation
// All rights reserved

module aes_tb();

parameter int NUM_TEST_VECS = 1000;

import aes_dpi_pkg::*;

bit clk;
bit rst_b = 1'b1;
bit load [3];

bit [255:0] key;

bit [127:0] pt;
bit [127:0] ct;

logic ct_valid [3];
logic pt_valid [3];

logic [127:0] ct_out [3];
logic [127:0] pt_out [3];

clk_gen clocks(.*);

initial begin: testbench

    // Reset DUT
    @(posedge clk) #1;
    rst_b = 1'b0;
    repeat(4) @(posedge clk) #1;
    rst_b = 1'b1;
    repeat(4) @(posedge clk) #1;

    // C.1 AES-128 example vector
    key = 128'h0f0e0d0c0b0a09080706050403020100;
    pt  = 128'hffeeddccbbaa99887766554433221100;
    ct  = 128'h5ac5b47080b7cdd830047b6ad8e0c469;

    @(posedge clk) #1 load[0] = 1'b1;
    @(posedge clk) #1 load[0] = 1'b0;

    wait (ct_valid[0]) #1;
    assert (ct_out[0] == ct);

    @(posedge clk) #1 load[0] = 1'b1;
    @(posedge clk) #1 load[0] = 1'b0;

    wait (pt_valid[0]) #1 assert (pt_out[0] == pt);

    // C.2 AES-192 example vector
    key = 192'h17161514131211100f0e0d0c0b0a09080706050403020100;
    pt  = 128'hffeeddccbbaa99887766554433221100;
    ct  = 128'h91710deca070af6ee0df4c86a47ca9dd;

    @(posedge clk) #1 load[1] = 1'b1;
    @(posedge clk) #1 load[1] = 1'b0;

    wait (ct_valid[1]) #1 assert (ct_out[1] == ct);

    @(posedge clk) #1 load[1] = 1'b1;
    @(posedge clk) #1 load[1] = 1'b0;

    wait (pt_valid[1]) #1 assert (pt_out[1] == pt);

    // C.3 AES-256 example vector
    key = 256'h1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100;
    pt  = 128'hffeeddccbbaa99887766554433221100;
    ct  = 128'h8960494b9049fceabf456751cab7a28e;

    @(posedge clk) #1 load[2] = 1'b1;
    @(posedge clk) #1 load[2] = 1'b0;

    wait (ct_valid[2]) #1 assert (ct_out[2] == ct);

    @(posedge clk) #1 load[2] = 1'b1;
    @(posedge clk) #1 load[2] = 1'b0;

    wait (pt_valid[2]) #1 assert (pt_out[2] == pt);

    for (int Nk = 4; Nk <= 8; Nk += 2) begin
        $display("testing AES-%0d", 32*Nk);
        for (int i = 0; i < NUM_TEST_VECS; i++) begin
            for (int j = 0; j < Nk; j++)
                key[32*j+:32] = $random();
            for (int j = 0; j < 4; j++)
                pt[32*j+:32] = $random();
            aes_encrypt_dpi(Nk, ct, pt, key);

            @(posedge clk) #1 load[Nk/2-2] = 1'b1;
            @(posedge clk) #1 load[Nk/2-2] = 1'b0;

            wait (ct_valid[Nk/2-2]) #1 assert (ct_out[Nk/2-2] == ct);

            @(posedge clk) #1 load[Nk/2-2] = 1'b1;
            @(posedge clk) #1 load[Nk/2-2] = 1'b0;

            wait (pt_valid[Nk/2-2]) #1 assert (pt_out[Nk/2-2] == pt);
        end
    end

    $finish();
end: testbench

aes_encrypt #(4) encrypt_128(.*, .load(load[0]), .key(key[127:0]), .pt(pt),
                            .ct_valid(ct_valid[0]), .ct(ct_out[0]));
aes_decrypt #(4) decrypt_128(.*, .load(load[0]), .key(key[127:0]), .ct(ct_out[0]),
                            .pt_valid(pt_valid[0]), .pt(pt_out[0]));

aes_encrypt #(6) encrypt_192(.*, .load(load[1]), .key(key[191:0]), .pt(pt),
                            .ct_valid(ct_valid[1]), .ct(ct_out[1]));
aes_decrypt #(6) decrypt_192(.*, .load(load[1]), .key(key[191:0]), .ct(ct_out[1]),
                            .pt_valid(pt_valid[1]), .pt(pt_out[1]));

aes_encrypt #(8) encrypt_256(.*, .load(load[2]), .key(key[255:0]), .pt(pt),
                            .ct_valid(ct_valid[2]), .ct(ct_out[2]));
aes_decrypt #(8) decrypt_256(.*, .load(load[2]), .key(key[255:0]), .ct(ct_out[2]),
                            .pt_valid(pt_valid[2]), .pt(pt_out[2]));

endmodule: aes_tb
