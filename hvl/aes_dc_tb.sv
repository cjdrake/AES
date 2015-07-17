// Filename: aes_dc_tb.sv
//
// Copyright (c) 2013, Intel Corporation
// All rights reserved

module aes_dc_tb #(parameter Nk=4)
(
    output bit done
);

import aes_dpi_pkg::*;

int NUM_VECS = 1000;
int r;

bit clk;
bit rst_n = 1'b1;

bit key_ready = 1'b0;
bit producer_done = 1'b0;
bit consumer_done = 1'b0;

logic [32*Nk-1:0] key;

logic load = 0;
logic [127:0] ct;

logic [127:0] pt;
logic valid;

bit [127:0] vecs [$];
bit [127:0] pt_gold;

initial r = $value$plusargs("NUM_VECS=%d", NUM_VECS);

// Reset the DUT and assign a random key
initial begin: setup

    rst_n = 1'b0;
    repeat(4) @(posedge clk) #1;

    rst_n = 1'b1;
    repeat(4) @(posedge clk) #1;

    for (int i = 0; i < Nk; ++i)
        key[32*i+:32] = $urandom();
    repeat(4) @(posedge clk) #1;

    key_ready = 1'b1;

end: setup

// Produce random vectors for the DUT.
initial begin: producer

    wait (key_ready);

    for (int i = 0; i < NUM_VECS; ++i) begin
        load = 1'b1;
        for (int i = 0; i < 4; ++i)
            ct[32*i+:32] = $urandom();
        vecs.push_front(ct);

        @(posedge clk) #1;
        load = 1'b0;
    end

    producer_done = 1'b1;

end: producer

// Consume and check outputs from the DUT.
initial begin: consumer

    int count;

    wait (key_ready);

    count = 0;
    while (count < NUM_VECS) begin
        @(posedge clk) #1;

        if (valid) begin
            aes_decrypt_dpi(Nk, pt_gold, vecs.pop_back(), key);
            assert(pt == pt_gold);
            count += 1;
        end
    end

    consumer_done = 1'b1;

end: consumer

clk_gen clocks(.*);
aes_decrypt #(Nk) dut(.*);

always_comb done = producer_done & consumer_done;

endmodule: aes_dc_tb
