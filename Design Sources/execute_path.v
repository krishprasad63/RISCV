`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2025 11:31:18
// Design Name: 
// Module Name: execute_path
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




module execute_path(
    input clk,
    input [31:0] A,
    input [31:0] B,
    input [6:0]  opcode,
    input [2:0]  funct3,
    input [6:0]  funct7,
    input  beq_control,
    input  bneq_control,
    input  blt_control,
    input  bge_control,
    output [31:0] alu_result,
    output zero,
    output carry,
    output overflow,
    output  beq,bneq,bge,blt
    );

    ALU_RISCV alu(
    .A(A),
    .B(B),
    .op(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .result(alu_result),
    .zero(zero),
    .carry(carry),
    .overflow(overflow)
    );


    assign beq = (alu_result == 1 && beq_control == 1) ? 1 : 0;
    assign bneq = (alu_result == 1 && bneq_control == 1) ? 1 : 0;
    assign blt = (alu_result == 1 && blt_control == 1) ? 1 : 0;
    assign bge = (alu_result == 1 && bge_control == 1) ? 1 : 0;


endmodule
