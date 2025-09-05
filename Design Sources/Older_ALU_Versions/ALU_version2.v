`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.07.2025 18:13:07
// Design Name: 
// Module Name: ALU
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

//Barrel Shifter is Added
module ALU_2(
    input clk,
    input [7:0] A,
    input [7:0] B,
    input [2:0] op,
    input [2:0] shift_control,
    output reg [7:0] result,
    output reg [7:0] barrel_a_result,
    output reg [7:0] barrel_b_result,
    output reg zero,
    output reg carry,
    output reg overflow
    );

    // op codes:
    // 0000 - ADD
    // 0001 - AND
    // 0010 - OR
    // 0011 - SUB
    // 0100 - XOR
    // 0101 - SLT
    // 0110 - NOR
    // 0111 - BARREL SHIFTER
    // 1000 - MUL
   
    reg [8:0] temp;

    wire signed  [7:0] A_signed = A;
    wire signed [7:0] B_signed = B;
    wire signed [7:0] result_signed = result;

    always @(posedge clk)
    begin

        case(op)

            // ADD
            4'b0000: begin
                temp = A_signed + B_signed;
                result <= temp[7:0];
                carry <= temp[8];
                overflow <= ((A_signed > 0 && B_signed > 0 && result_signed < 0) ||
                             (A_signed < 0 && B_signed < 0 && result_signed > 0));
            end

            // AND
            4'b0001: begin
                result <= A & B;
                carry <= 0;
                overflow <= 0;
            end

            // OR
            4'b0010: begin
                result <= A | B;
                carry <= 0;
                overflow <= 0;
            end

            // SUB
            4'b0011: begin
                result <= A_signed - B_signed;
                carry <= (A < B) ? 1 : 0;
                overflow <= ((A_signed > 0 && B_signed < 0 && result_signed < 0) ||
                             (A_signed < 0 && B_signed > 0 && result_signed > 0));
            end

            // XOR
            4'b0100: begin
                result <= A ^ B;
                carry <= 0;
                overflow <= 0;
            end

            // SLT
            4'b0101: begin
                result <= (A_signed < B_signed) ? 8'b00000001 : 8'b00000000;
                carry <= 0;
                overflow <= 0;
            end

            // NOR
            4'b0110: begin
                result <= ~(A | B);
                carry <= 0;
                overflow <= 0;
            end
            
            // BARREL SHIFTER
            4'b0111: begin
                result <=0;
                barrel_a_result <= A<<shift_control;
                barrel_b_result <= B<<shift_control;
            end

            // default
            default: begin
                result <= 8'b00000000;
                carry <= 0;
                overflow <= 0;
            end

        endcase

        zero <= (result == 8'b00000000) ? 1 : 0;
    end

endmodule