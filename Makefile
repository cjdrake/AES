# Filename: Makefile
#
# Copyright (c) 2013, Intel Corporation
# All rights reserved

VPATH := include:hdl:hvl

VLOG_INC_FILES := flops.svh

VLOG_HDL_FILES := \
    aes_pkg.sv \
    aes_key_expansion.sv \
    aes_cipher.sv \
    aes_inv_cipher.sv \
    aes_encrypt.sv \
    aes_decrypt.sv

VLOG_HVL_FILES := \
    aes_dpi_pkg.sv \
    clk_gen.sv \
    aes_tb.sv

C_FILES := aes.c aes_dpi.c
C_INC_FILES := aes.h

SRC := \
    $(VLOG_INC_FILES) \
    $(VLOG_HDL_FILES) \
    $(VLOG_HVL_FILES) \
    $(C_INC_FILES) \
    $(C_FILES)

VCS := vcs
VCS_FLAGS := -sverilog +incdir+../include -cflags "-I../hvl"

sim/:
	@mkdir -p $@

sim/simv: $(SRC) | sim/
	@cd $(dir $@) && $(VCS) $(VCS_FLAGS) $(filter %.sv %.c,$(addprefix ../,$^))

.PHONY: test
test: sim/simv
	@cd sim && ./simv

.PHONY: clean
clean:
	@rm -rf sim/
