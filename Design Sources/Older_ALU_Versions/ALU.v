`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2025 16:52:04
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

module ALU(
    input clk,
    input [7:0] A,
    input [7:0] B,
    input [2:0] op,
    output reg [7:0] result,
    output reg zero,
    output reg carry,
    output reg overflow
    );

    // op codes:
    // 000 - ADD
    // 001 - AND
    // 010 - OR
    // 011 - SUB
    // 100 - XOR
    // 101 - SLT
    // 110 - NOR

    reg [8:0] temp;

    wire signed  [7:0] A_signed = A;
    wire signed [7:0] B_signed = B;
    wire signed [7:0] result_signed = result;

    always @(posedge clk)
    begin

        case(op)

            // ADD
            3'b000: begin
                temp = A_signed + B_signed;
                result <= temp[7:0];
                carry <= temp[8];
                overflow <= ((A_signed > 0 && B_signed > 0 && result_signed < 0) ||
                             (A_signed < 0 && B_signed < 0 && result_signed > 0));
            end

            // AND
            3'b001: begin
                result <= A & B;
                carry <= 0;
                overflow <= 0;
            end

            // OR
            3'b010: begin
                result <= A | B;
                carry <= 0;
                overflow <= 0;
            end

            // SUB
            3'b011: begin
                result <= A_signed - B_signed;
                carry <= (A < B) ? 1 : 0;
                overflow <= ((A_signed > 0 && B_signed < 0 && result_signed < 0) ||
                             (A_signed < 0 && B_signed > 0 && result_signed > 0));
            end

            // XOR
            3'b100: begin
                result <= A ^ B;
                carry <= 0;
                overflow <= 0;
            end

            // SLT
            3'b101: begin
                result <= (A_signed < B_signed) ? 8'b00000001 : 8'b00000000;
                carry <= 0;
                overflow <= 0;
            end

            // NOR
            3'b110: begin
                result <= ~(A | B);
                carry <= 0;
                overflow <= 0;
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



