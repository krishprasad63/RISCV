`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2025 10:39:22
// Design Name: 
// Module Name: fetch_stage
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



module fetch_stage(
    input clk,
    input reset,
    input load_enable,
    input fetch_enable,
    input [31:0] load_address,
    input [31:0] load_data,
    input [31:0] base_pc,
    input [31:0] imm_address,
    input [31:0] imm_address_jump,
    input beq,bneq,bge,blt,jump,
    output [31:0] pc,
    output [31:0] current_pc,
    output [31:0] fetched_instruction
    );


    program_counter m1(
    .clk(clk),
    .reset(reset),
    .enable(fetch_enable),
    .beq(beq),
    .bneq(bneq),
    .blt(blt),
    .bge(bge),
    .jump(jump),
    .imm_address(imm_address),
    .imm_address_jump(imm_address_jump),
    .base_address(base_pc),
    .pc(pc),
    .current_pc(current_pc)
    );

    instruction_memory_hex_input m2(
    .clk(clk),
    .write_en(load_enable),
    .pc(pc),
    .address(load_address),
    .data_in(load_data),
    .instruction(fetched_instruction)
    );


endmodule

