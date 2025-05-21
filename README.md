# SLC-3 Processor
An implementation of the SLC-3 processor architecture using SystemVerilog.

## Overview
This project provides a hardware description of the SLC-3 processor, a simplified educational CPU architecture. The design is modular, facilitating understanding and potential extensions.

## Features
- Modular design with separate components for control, memory, and I/O.
- Implemented in SystemVerilog for synthesis and simulation.
- Includes testbenches for verification.

## Directory Structure
- control.sv – Control unit logic.
- cpu.sv – Top-level CPU integration.
- cpu_to_io.sv – Interface between CPU and I/O devices.
- hex_driver.sv – Seven-segment display driver.
- instantiate_ram.sv – RAM instantiation module.
- load_reg.sv – Load register logic.
- memory.sv – Memory module.
- mux.sv – Multiplexer module.
- processor_top.sv – Top-level processor module.
- slc3.sv – Main SLC-3 processor implementation.
- sync.sv – Synchronization logic.
- top.xdc – Xilinx Design Constraints file.
- types.sv – Type definitions.

## Getting Started
### Prerequisites
- SystemVerilog-compatible simulator (e.g., ModelSim, Vivado).
- Xilinx Vivado for synthesis and implementation.

### Simulation
1. Clone the repository:<br>*git clone https://github.com/shailee2/SLC-3_Processor.git <br>cd SLC-3_Processor*
2. Compile the SystemVerilog files using your simulator.
3. Run simulations to verify functionality.

### Synthesis
1. Open Xilinx Vivado.
2. Create a new project and add the .sv files.
3. Include the top.xdc constraints file.
4. Run synthesis and implementation.
5. Generate the bitstream for your target FPGA.

## Author
Shailee Patel <br>
Email: shaileepatel05@gmail.com <br>
LinkedIn: linkedin.com/in/shailee-patel-04481b285<br>
GitHub: github.com/shailee2

