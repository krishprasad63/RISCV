`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2025 11:15:32
// Design Name: 
// Module Name: decode_stage
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

/* currently i am assuming that we will only use I-Type and R-Type instruction.
later it'll be updated as per convenience*/
module decode_stage(
    input  clk,
    input  [31:0] instruction,
    output reg [6:0]  opcode,
    output reg [4:0]  rd,
    output reg [2:0]  funct3,
    output reg [4:0]  rs1,
    output reg [4:0]  rs2,
    output reg [6:0]  funct7,
    output reg [31:0] imm,
    output [6:0] alu_opcode,
    output alu_src,
    output wire mem_read,
    output wire mem_write,
    output wire mem_to_reg,
    output  beq_control,
    output  bneq_control,
    output  blt_control,
    output  bge_control,
    output reg [31:0] imm_address //for B-type
    );
    
    control_unit CU(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .alu_op(alu_opcode),
        .alu_src(alu_src),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .beq_control(beq_control),
        .bneq_control(bneq_control),
        .blt_control(blt_control),
        .bge_control(bge_control)
    );

    always@(posedge clk)
    begin
        opcode <= instruction[6:0];
        rd     <= instruction[11:7];
        funct3 <= instruction[14:12];
        rs1    <= instruction[19:15];
        rs2    <= instruction[24:20];
        funct7 <= instruction[31:25];
        imm    <= {{20{instruction[31]}}, instruction[31:20]} ;//for I-type instruction
        imm_address <= {{20{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
    end

endmodule