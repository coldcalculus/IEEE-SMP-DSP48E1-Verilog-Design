# IEEE-SMP-DSP48E1-Verilog-Design
A structural Verilog implementation of a simplified DSP48E1-style slice.

## Overview
This repository contains a structural Verilog implementation of a simplified DSP48E1-style slice, modeling the dedicated digital signal processing hard blocks found in Xilinx 7-series FPGAs. The design features a fully pipelined 3-stage architecture separating the data path (computation) from the control path (operation timing).

## Architecture Details
The slice implements the following 3-stage pipeline:
1. **Input Stage:** Captures four independent operands (`A`, `B`, `C`, `D`) with independent clock enables, and features a pre-adder for symmetric filter optimization.
2. **Multiply Stage:** Computes the product of the pre-adder result and operand `B`.
3. **Output/ALU Stage:** A flexible ALU that performs addition, subtraction, or pass-through operations fed by configurable `X`, `Y`, and `Z` multiplexers. It includes feedback paths for multiply-accumulate (MACC) chaining.

## Module Hierarchy
* `dsp_slice_top.v`: Top-level structural integration.
* `slice_ctrl_fsm.v`: Moore-style FSM managing the control pipeline and clock enables.
* `input_reg_bank.v`: Stage 1 input registers.
* `pre_adder.v`: Combinational pre-adder and register.
* `multiplier.v`: Stage 2 multiplier and register.
* `operand_mux.v`: Combinational routing muxes (X, Y, Z).
* `alu_unit.v`: Combinational arithmetic logic unit.
* `output_reg.v`: Stage 3 output and accumulator register.
* `dsp_slice_params.vh`: Shared parameters for mux and ALU selection.
