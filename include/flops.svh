// Filename: flops.svh
//
// Copyright (c) 2013, Intel Corporation
// All rights reserved

`ifndef FLOPS_SVH
`define FLOPS_SVH

// D flip-flop
`define DFF(q, d, clk) \
always_ff @(posedge clk) begin \
    q <= (d); \
end

// D flip-flop w/ async reset_n
`define DFF_ARN(q, d, clk, ar, arval) \
always_ff @(posedge clk, negedge ar) begin \
    if (!ar) q <= (arval); \
    else     q <= (d); \
end

// D flip-flop w/ sync reset
`define DFF_SR(q, d, clk, sr, srval) \
always_ff @(posedge clk) begin \
    q <= (sr)?(srval):(d); \
end

// D flip-flop w/ async reset_n, sync reset
`define DFF_ARN_SR(q, d, clk, ar, arval, sr, srval) \
always_ff @(posedge clk, negedge ar) begin \
    if (!ar) q <= (arval); \
    else     q <= (sr)?(srval):(d); \
end

// enabled D flip-flop
`define DFFEN(q, d, en, clk) \
`DFF(q, (en)?(d):q, clk)

// enabled D flip-flop w/ async reset_n
`define DFFEN_ARN(q, d, en, clk, ar, arval) \
`DFF_ARN(q, (en)?(d):q, clk, ar, arval)

// enabled D flip-flop w/ sync reset
`define DFFEN_SR(q, d, en, clk, sr, srval) \
`DFF_SR(q, (en)?(d):q, clk, sr, srval)

// enabled flop w/ async reset_n, sync reset
`define DFFEN_ARN_SR(q, d, en, clk, ar, arval, sr, srval) \
`DFF_ARN_SR(q, (en)?(d):q, clk, ar, arval, sr, srval)

// SR flip-flop
`define SRFF(q, s, r, clk) \
`DFF(q, q?~(r):(s), clk)

// SR flip-flop w/ async reset_n
`define SRFF_ARN(q, s, r, clk, ar, arval) \
`DFF_ARN(q, q?~(r):(s), clk, ar, arval)

// SR flip-flop w/ sync reset
`define SRFF_SR(q, s, r, clk, sr, srval) \
`DFF_SR(q, q?~(r):(s), clk, sr, srval)

// SR flip-flop w/ async reset_n, sync reset
`define SRFF_ARN_SR(q, s, r, clk, ar, arval, sr, srval) \
`DFF_ARN_SR(q, q?~(r):(s), clk, ar, arval, sr, srval)

`endif // FLOPS_SVH
