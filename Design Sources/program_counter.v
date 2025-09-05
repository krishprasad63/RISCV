`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2025 13:10:26
// Design Name: 
// Module Name: program_counter
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


module program_counter(
    input clk,
    input reset,
    input enable,
    input beq,bneq,bge,blt,jump,
    input [31:0] imm_address, // for branch instruction
    input [31:0] imm_address_jump, 
    input [31:0]  base_address,
    output reg [31:0]  pc,
    output reg [31:0] current_pc
);
    always @(posedge clk ) begin
    
        if (reset)
            pc <= base_address;
        else if (enable) begin
            if(beq == 0 && bneq == 0 && bge == 0 && blt == 0)//jump==0 .. will be adding later
                    pc <= pc + 4;
                    
            else if(beq == 1 || bneq == 1 || bge == 1 || blt == 1)
                    pc <= pc + imm_address;
                    
            else if(jump)
                    pc <= pc + imm_address_jump;
        end
    end
    
    //logic for return address of program counter
    
     always@(posedge clk)
        begin
        if(reset)
            begin
                current_pc = 0;
             end
             
        else if(reset == 0 && jump == 0)
            current_pc <= pc + 4;
        else
            current_pc <= current_pc;
        end
endmodule

