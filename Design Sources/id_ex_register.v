`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2025 14:35:02
// Design Name: 
// Module Name: id_ex_register
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


module id_ex_register(
    input clk,
    input reset,
    
    //input from decode stage
    input [6:0] in_alu_op,
    input in_alu_src,
    input in_mem_read,
    input in_mem_write,
    input in_mem_to_reg,
    input in_beq_control,
    input in_bneq_control,
    input in_blt_control,
    input in_bge_control,
    
    //Data
    
    input [31:0] in_read_data_1,
    input [31:0] in_read_data_2,
    input [31:0] in_imm,
    input [4:0]  in_rs1,
    input [4:0]  in_rs2,
    input [4:0]  in_rd,
    input [6:0]  in_funct7,
    input [2:0]  in_funct3,
    input [31:0] in_instruction,
    
    //Outputs to Execute Stage
    output reg [6:0] out_alu_op,
    output reg out_alu_src,
    output reg out_mem_read,
    output reg out_mem_write,
    output reg out_mem_to_reg,
    output reg out_beq_control,
    output reg out_bneq_control,
    output reg out_blt_control,
    output reg out_bge_control,
    
    //Data
    output reg [31:0] out_read_data_1,
    output reg [31:0] out_read_data_2,
    output reg [31:0] out_imm,
    output reg [4:0] out_rd,
    output reg [6:0] out_funct7,
    output reg [2:0] out_funct3
    );
 

    always @(posedge clk or posedge reset)
    begin
        if (reset) begin
            // On reset, clear all control signals and data to a known safe state (like a NOP)
            out_alu_op      <= 7'b0;
            out_alu_src     <= 1'b0;
            out_mem_read    <= 1'b0;
            out_mem_write   <= 1'b0;
            out_mem_to_reg  <= 1'b0;
            out_beq_control <= 1'b0;
            out_bneq_control<= 1'b0;
            out_blt_control <= 1'b0;
            out_bge_control <= 1'b0;
            
            out_read_data_1 <= 32'b0;
            out_read_data_2 <= 32'b0;
            out_imm         <= 32'b0;
            out_rd          <= 5'b0;
            out_funct7      <= 7'b0;
            out_funct3      <= 3'b0;
        end
        else begin
            // On a clock edge, capture all the inputs from the Decode stage
            out_alu_op      <= in_alu_op;
            out_alu_src     <= in_alu_src;
            out_mem_read    <= in_mem_read;
            out_mem_write   <= in_mem_write;
            out_mem_to_reg  <= in_mem_to_reg;
            out_beq_control <= in_beq_control;
            out_bneq_control<= in_bneq_control;
            out_blt_control <= in_blt_control;
            out_bge_control <= in_bge_control;

            out_read_data_1 <= in_read_data_1;
            out_read_data_2 <= in_read_data_2;
            out_imm         <= in_imm;
            out_rd          <= in_rd;
            out_funct7      <= in_funct7;
            out_funct3      <= in_funct3;
        end
    end   
endmodule
