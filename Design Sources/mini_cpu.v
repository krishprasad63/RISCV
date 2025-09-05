`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2025 12:04:56
// Design Name: 
// Module Name: mini_cpu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mini_cpu(
    input clk,
    input reset,
    input load_enable, //for instruction memory in fetch
    input fetch_enable, //
    input reg_write_enable,
    input [31:0] load_address,
    input [31:0] load_data,
    input [31:0] base_pc,
    output [31:0] write_back_data
    //output zero,
    //output carry,
    //output overflow
    );
    reg [31:0] Register [0:31];// register_file

    //FETCH STAGE
    
    wire [31:0]  fetched_instruction;
    wire [31:0] current_pc;
    wire [31:0] pc;

    wire branch_beq, branch_bneq, branch_bge, branch_blt, branch_jump;// Will be updated from execute stage
    wire [31:0] branch_imm_address, branch_imm_address_jump;

    fetch_stage fetch(
        .clk(clk),
        .reset(reset),
        .load_enable(load_enable),
        .fetch_enable(fetch_enable),
        .load_address(load_address),
        .load_data(load_data),
        .base_pc(base_pc),
        .beq(branch_beq),
        .bneq(branch_bneq),
        .blt(branch_blt),
        .bge(branch_bge),
        .jump(branch_jump),
        .imm_address(branch_imm_address),
        .imm_address_jump(branch_imm_address_jump),
        .pc(pc),
        .current_pc(current_pc),
        .fetched_instruction(fetched_instruction)
    );

    //DECODE STAGE
    wire [6:0]  decode_opcode;
    wire [4:0]  decode_rd;
    wire [2:0]  decode_funct3;
    wire [4:0]  decode_rs1;
    wire [4:0]  decode_rs2;
    wire [6:0]  decode_funct7;
    wire [31:0] decode_imm;
    wire [6:0] decode_alu_opcode;
    wire decode_alu_src;
    wire decode_mem_read;
    wire decode_mem_write;
    wire decode_mem_to_reg;
    wire decode_beq_control;
    wire decode_bneq_control;
    wire decode_blt_control;
    wire decode_bge_control;

    decode_stage decode(
        .clk(clk),
        .instruction(fetched_instruction),
        .opcode(decode_opcode),
        .rd(decode_rd),
        .funct3(decode_funct3),
        .rs1(decode_rs1),
        .rs2(decode_rs2),
        .funct7(decode_funct7),
        .imm(decode_imm),
        .alu_opcode(decode_alu_opcode),
        .alu_src(decode_alu_src),
        .mem_read(decode_mem_read),
        .mem_write(decode_mem_write),
        .mem_to_reg(decode_mem_to_reg),
        .beq_control(decode_beq_control),
        .bneq_control(decode_bneq_control),
        .blt_control(decode_blt_control),
        .bge_control(decode_bge_control),
        .imm_address(branch_imm_address)
    );
    
    
    // Register file read logic - happens in Decode stage
    wire [31:0] read_data_1 = Register[decode_rs1];
    wire [31:0] read_data_2 = Register[decode_rs2];


    // --- ID/EX PIPELINE REGISTER ---
    // Wires coming out of the ID/EX register (inputs to the Execute stage)
    wire [6:0]  ex_alu_op;
    wire        ex_alu_src;
    wire        ex_mem_read;
    wire        ex_mem_write;
    wire        ex_mem_to_reg;
    wire        ex_beq_control;
    wire        ex_bneq_control;
    wire        ex_blt_control;
    wire        ex_bge_control;
    wire [31:0] ex_read_data_1;
    wire [31:0] ex_read_data_2;
    wire [31:0] ex_imm;
    wire [4:0]  ex_rd;
    wire [6:0]  ex_funct7;
    wire [2:0]  ex_funct3;
    
    id_ex_register id_ex_reg (
        .clk(clk),
        .reset(reset),

        // Inputs from Decode
        .in_alu_op(decode_alu_opcode),
        .in_alu_src(decode_alu_src),
        .in_mem_read(decode_mem_read),
        .in_mem_write(decode_mem_write),
        .in_mem_to_reg(decode_mem_to_reg),
        .in_beq_control(decode_beq_control),
        .in_bneq_control(decode_bneq_control),
        .in_blt_control(decode_blt_control),
        .in_bge_control(decode_bge_control),
        .in_read_data_1(read_data_1),
        .in_read_data_2(read_data_2),
        .in_imm(decode_imm),
        .in_rs1(decode_rs1),
        .in_rs2(decode_rs2),
        .in_rd(decode_rd),
        .in_funct7(decode_funct7),
        .in_funct3(decode_funct3),
        .in_instruction(fetched_instruction),

        // Outputs to Execute
        .out_alu_op(ex_alu_op),
        .out_alu_src(ex_alu_src),
        .out_mem_read(ex_mem_read),
        .out_mem_write(ex_mem_write),
        .out_mem_to_reg(ex_mem_to_reg),
        .out_beq_control(ex_beq_control),
        .out_bneq_control(ex_bneq_control),
        .out_blt_control(ex_blt_control),
        .out_bge_control(ex_bge_control),
        .out_read_data_1(ex_read_data_1),
        .out_read_data_2(ex_read_data_2),
        .out_imm(ex_imm),
        .out_rd(ex_rd),
        .out_funct7(ex_funct7),
        .out_funct3(ex_funct3)
    );
    
    // --- EXECUTE STAGE ---
    wire [31:0] ex_alu_result;
    wire ex_zero, ex_carry, ex_overflow;
    
    
    // ALU inputs are now selected based on the registered alu_src signal
    wire [31:0] alu_input_A = (ex_alu_src) ? 32'd0:ex_read_data_1;
    wire [31:0] alu_input_B = (ex_alu_src) ? ex_imm : ex_read_data_2;


    execute_path execute(
        .clk(clk),
        .A(alu_input_A),
        .B(alu_input_B),
        .opcode(ex_alu_op),
        .funct3(ex_funct3),
        .funct7(ex_funct7),
        .beq_control(ex_beq_control),
        .bneq_control(ex_bneq_control),
        .blt_control(ex_blt_control),
        .bge_control(ex_bge_control),
        .alu_result(ex_alu_result),
        .zero(ex_zero),
        .carry(ex_carry),
        .overflow(ex_overflow),
        .beq(branch_beq),
        .bneq(branch_bneq),
        .blt(branch_blt),
        .bge(branch_bge)
    );
    
    // --- EX/MEM PIPELINE REGISTER ---
    // Wires coming out of the EX/MEM register (inputs to Memory stage)
    wire        mem_mem_read;
    wire        mem_mem_write;
    wire        mem_mem_to_reg;
    wire [31:0] mem_alu_result;
    wire [31:0] mem_store_data;
    wire [4:0]  mem_rd;

    
    ex_mem_register ex_mem_reg (
        .clk(clk),
        .reset(reset),

        // Inputs from Execute
        .in_mem_read(ex_mem_read),
        .in_mem_write(ex_mem_write),
        .in_mem_to_reg(ex_mem_to_reg),
        .in_alu_result(ex_alu_result),
        .in_store_data(ex_read_data_2), // Pass the data for SW instructions
        .in_rd(ex_rd),

        // Outputs to Memory
        .out_mem_read(mem_mem_read),
        .out_mem_write(mem_mem_write),
        .out_mem_to_reg(mem_mem_to_reg),
        .out_alu_result(mem_alu_result),
        .out_store_data(mem_store_data),
        .out_rd(mem_rd)
    );
    
    
    //MEMORY STAGE

    wire [31:0] mem_read_data_out;
    
    memory_stage mem_stage (
        .clk(clk),
        .mem_write(mem_mem_write),
        .alu_result(mem_alu_result),    // result from EX stage
        .rs2_data(mem_store_data), // value to store (from rs2)
        .read_data_out(mem_read_data_out)
    );


    //MEM/WB PIPELINE REGISTER
    
    wire        wb_mem_to_reg;
    wire [31:0] wb_read_data, wb_alu_result;
    wire [4:0]  wb_rd;
    
    mem_wb_register mem_wb_reg (
        .clk(clk), .reset(reset),
        .in_mem_to_reg(mem_mem_to_reg), .in_read_data(mem_read_data_out),
        .in_alu_result(mem_alu_result), .in_rd(mem_rd),
        .out_mem_to_reg(wb_mem_to_reg), .out_read_data(wb_read_data),
        .out_alu_result(wb_alu_result), .out_rd(wb_rd)
    );
    
    // WRITE BACK DATA
    
    assign write_back_data = (wb_mem_to_reg) ? wb_read_data : wb_alu_result;
    
    always @(posedge clk) begin
        if (reg_write_enable && wb_rd != 5'b0) begin
            Register[wb_rd] <= write_back_data;
        end
    end

endmodule
