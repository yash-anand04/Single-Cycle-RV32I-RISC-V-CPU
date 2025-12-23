# Single‑Cycle RV32I RISC‑V CPU

This project implements a **single‑cycle** RISC‑V RV32I CPU core in Verilog along with simple instruction and data memories and a top‑level test wrapper suitable for simulation or FPGA bring‑up.

## Features

- Implements the RV32I base integer ISA (R‑type, I‑type, S‑type, B‑type, U‑type and J‑type instructions). 
- Single‑cycle datapath: each instruction completes in one clock cycle (no pipeline).  
- Separate instruction and data memory modules (`instr_mem`, `data_mem`).
- Top‑level wrapper (`t1c_riscv_cpu`) that instantiates CPU and memories and adds an external write port for initializing/modifying data memory.
- Provided assembly and hex test programs to exercise almost all RV32I instructions.

## Repository Structure

- `riscv_cpu.v`  
  Single‑cycle RV32I CPU core containing controller and datapath instances and the main CPU interface (PC, instruction bus, data memory interface, result output).

- `t1c_riscv_cpu.v`  
  Top‑level module that connects `riscv_cpu` with `instr_mem` and `data_mem`, and exposes useful debug signals (PC, Result, memory interface). It also allows external writes to data memory during reset using `Ext_MemWrite`, `Ext_WriteData`, and `Ext_DataAdr`.

- `instr_mem.v`  
  Instruction memory ROM. Typically initialized from a `.hex` file (e.g. `rv32i_test.hex` or `rv32i_book.hex`) and addressed by the CPU program counter.

- `data_mem.v`  
  Data memory RAM used for load/store instructions; connected to the CPU’s `MemWrite`, address and write‑data signals.

- `rv32i_test.s`  
  RISC‑V assembly test program that exercises arithmetic, logic, shifts, loads/stores, branches, jumps, and upper‑immediate instructions with comments describing the expected result of each instruction.

- `rv32i_test.hex`, `rv32i_book.hex`  
  Machine‑code hex images for the instruction memory, generated from the assembly programs.

## Top‑Level Interface

### `t1c_riscv_cpu` Ports

module t1c_riscv_cpu (
input clk, reset,
input Ext_MemWrite,
input [31:0] Ext_WriteData, Ext_DataAdr,
output MemWrite,
output [31:0] WriteData, DataAdr, ReadData,
output [31:0] PC, Result
);

text

- `clk` / `reset`: Clock and synchronous reset.
- `Ext_MemWrite`: When asserted during reset, writes `Ext_WriteData` to address `Ext_DataAdr` in data memory instead of CPU writes (simple external initialization interface).
- `MemWrite`: Active when the CPU performs a store.
- `DataAdr`, `WriteData`: Address and data driven to `data_mem` by the CPU.
- `ReadData`: Data read from `data_mem` back to the CPU.
- `PC`: Current program counter, useful for debugging. 
- `Result`: Main ALU / write‑back result from the datapath, exposed for observation.

## Simulating in Quartus / ModelSim‑Intel

1. **Create a new Quartus project**  
   - Add all Verilog source files: `riscv_cpu.v`, `t1c_riscv_cpu.v`, `instr_mem.v`, `data_mem.v` and any submodules they reference. 

2. **Set up the instruction memory hex file**  
   - Place `rv32i_test.hex` (or `rv32i_book.hex`) in the project directory. 
   - Ensure the `$readmemh` call in `instr_mem.v` points to the correct hex filename and relative path.

3. **Write a simple testbench**  
   - Instantiate `t1c_riscv_cpu` as the DUT.
   - Generate a clock (e.g. 10–20 ns period) and assert `reset` for a few cycles at the start.  
   - Optionally, during reset, drive `Ext_MemWrite`, `Ext_WriteData`, and `Ext_DataAdr` to preload data memory locations.

4. **Run simulation and inspect waveforms**  
   - In ModelSim‑Intel, add signals like `PC`, `Result`, `MemWrite`, `DataAdr`, `WriteData`, and `ReadData` to the waveform window.
   - Compare register and memory values against the expected behavior commented in `rv32i_test.s` to validate the design.

## Notes and Limitations

- The design targets **functional simulation only** and has been validated in Quartus/ModelSim, not synthesized or tested on hardware in this repository.
- Only the RV32I base integer instructions used in the test program are guaranteed to be exercised; additional instructions would require new tests.

