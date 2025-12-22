# 🧠 5-Stage Pipelined RISC-V Processor (Verilog)

## 📌 Project Overview

This repository contains the Verilog HDL implementation of a **5-stage pipelined RISC-V processor**, developed as a **self-learning academic project**.

The processor demonstrates how a RISC-V instruction flows through a classic pipeline (**IF → ID → EX → MEM → WB**) using modular Verilog design and pipeline registers. Behavioral verification is performed using **Xilinx Vivado simulation**.

---

## 🎯 Motivation

As a **sophomore Electronics and Communication Engineering (ECE) student**, I built this project to:

* Understand **RISC-V ISA implementation at RTL level**
* Learn **pipelined processor architecture**
* Gain hands-on experience with **Verilog HDL**
* Analyze **pipeline behavior using simulation waveforms**
* Build a strong **core hardware design project** for my portfolio

---

## 🏗️ Processor Architecture

The processor follows a **5-stage pipelined architecture**:

| Stage | Description                                                |
| ----- | ---------------------------------------------------------- |
| IF    | Instruction Fetch from instruction memory                  |
| ID    | Instruction Decode, register file read, control generation |
| EX    | ALU execution and branch condition evaluation              |
| MEM   | Data memory access                                         |
| WB    | Write back result to register file                         |

Pipeline registers implemented:

* ID/EX
* EX/MEM
* MEM/WB

---

## ⚙️ Key Features

* 5-stage pipelined datapath
* Modular Verilog design
* 32-register register file
* ALU supporting R-type and I-type instructions
* Branch control signals (BEQ, BNE, BLT, BGE)
* Separate pipeline registers between stages
* Behavioral simulation verified using Vivado
* Custom testbench for instruction loading and execution

Note: Hazard detection and forwarding are **not implemented** and are planned as future improvements.

---

## 🧩 Project Structure

RISCV/
├── 🏗️ Design Sources/
│   └── riscv_implementation/
│       ├── mini_cpu.v           # Top-level module (System Integration)
│       ├── fetch_stage.v        # Instruction Fetch (IF) logic
│       ├── decode_stage.v       # Instruction Decode (ID) & Register File
│       ├── execute_path.v       # Execution stage (ALU & Branching)
│       ├── memory_stage.v       # Data Memory Access (MEM)
│       ├── id_ex_register.v     # IF/ID to ID/EX Pipeline Buffer
│       ├── ex_mem_register.v    # ID/EX to EX/MEM Pipeline Buffer
│       └── mem_wb_register.v    # EX/MEM to MEM/WB Pipeline Buffer
├── 🧪 Testbenches/
│   └── tb_mini_cpu.v           # Comprehensive system testbench
├── 🖼️ riscv_processor.png        # Datapath Block Diagram
├── 🖼️ riscv_processor_other_signals.png
└── 📝 README.md                 # Project Documentation
---

## 🧠 Top-Level Module: mini_cpu

The `mini_cpu` module integrates:

* Instruction fetch logic with PC update
* Decode stage with control signal generation
* Register file with 32 general-purpose registers
* Execute stage with ALU and branch evaluation
* Memory access stage
* Write-back stage with result selection

Write-back selection logic:
assign write_back_data = (wb_mem_to_reg) ? wb_read_data : wb_alu_result;

Register write operation:
always @(posedge clk) begin
  if (reg_write_enable && wb_rd != 5'b0)
   Register[wb_rd] <= write_back_data;
end

---

## 🧪 Testbench Overview (tb_mini_cpu)

The testbench performs:

* 100 MHz clock generation
* Processor reset and initialization
* Manual instruction loading into instruction memory
* Enabling fetch and register write
* Monitoring pipeline behavior and write-back data

### Program Executed

ADDI x1, x0, 5
ADDI x2, x0, 10
ADD  x3, x1, x2

### Machine Code Used

0x00500093
0x00A00113
0x002081B3

---

## 📊 Simulation & Verification

* Tool: **Xilinx Vivado Behavioral Simulation**
* Verified aspects:

  * Instruction propagation across pipeline stages
  * ALU inputs and outputs
  * Branch control signals
  * Correct register write-back

Waveform screenshots included in the repository:

* riscv_processor.png
* riscv_processor_other_signals.png

---

## 🛠️ Tools & Technologies

* Language: Verilog HDL
* Simulator: Xilinx Vivado
* Architecture: RISC-V (basic subset)
* Design Style: Modular pipelined RTL

---

## 📚 Learning Outcomes

This project helped me understand:

* RISC-V datapath and control flow
* Pipeline register design
* RTL-level debugging using waveforms
* Instruction-level execution in a CPU
* Writing clean and modular Verilog code

---

## 🔮 Future Improvements

* Hazard detection and forwarding unit
* Pipeline stall and flush logic
* Support for more RISC-V instructions
* Performance comparison with single-cycle CPU
* FPGA synthesis and hardware testing

---

## 👤 Author

**Krish Prasad**
Sophomore | Electronics and Communication Engineering
Interests: VLSI, Computer Architecture, Digital Design

---

## ⭐ Project Significance

This project demonstrates strong fundamentals in **processor design**, **RTL coding**, and **simulation-based verification**, forming a solid foundation for advanced VLSI and CPU architecture work.

---

