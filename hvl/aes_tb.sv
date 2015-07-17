// Filename: aes_tb.sv

module aes_tb;

`include "params.sv"

bit ec_done4 [NUM_BLOCKS];
bit ec_done6 [NUM_BLOCKS];
bit ec_done8 [NUM_BLOCKS];

bit dc_done4 [NUM_BLOCKS];
bit dc_done6 [NUM_BLOCKS];
bit dc_done8 [NUM_BLOCKS];

bit done;

initial wait(done) $finish();

always_comb
    done = ec_done4.and() & ec_done6.and() & ec_done8.and()
         & dc_done4.and() & dc_done6.and() & dc_done8.and();

generate
    for (genvar i = 0; i < NUM_BLOCKS; ++i) begin
        // Encrypt blocks
        aes_ec_tb #(4) ec4 (ec_done4[i]);
        aes_ec_tb #(6) ec6 (ec_done6[i]);
        aes_ec_tb #(8) ec8 (ec_done8[i]);

        // Decrypt blocks
        aes_dc_tb #(4) dc4 (dc_done4[i]);
        aes_dc_tb #(6) dc6 (dc_done6[i]);
        aes_dc_tb #(8) dc8 (dc_done8[i]);
    end
endgenerate

endmodule: aes_tb
