// Filename: clk_gen.sv
//
// Copyright (c) 2013, Intel Corporation
// All rights reserved

module clk_gen
#(
    int period = 2500,
    int phase_shift = 20
)(
    output bit clk
);

// tbx clkgen
initial begin
    clk = 0;
    #(phase_shift);
    forever begin
        #(period / 2) clk = 1;
        #(period / 2) clk = 0;
    end
end

endmodule: clk_gen
