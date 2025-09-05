`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.07.2025 16:56:47
// Design Name: 
// Module Name: ALU_3
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

//INTEGRATE SIGNED/UNSIGNED MULTIPLICATION USING SHIFT ADD 
module ALU_3(
    input clk,
    input [7:0] A,
    input [7:0] B,
    input [5:0] op,
    input [2:0] shift_control,
    output reg [7:0] result,
    output reg [7:0] barrel_a_result,
    output reg [7:0] barrel_b_result,
    output reg [15:0] unsigned_mul_result,
    output reg [15:0] signed_mul_result,
    output reg zero,
    output reg carry,
    output reg overflow
    );

    // op codes:
    // 000000 - ADD
    // 000001 - AND
    // 000010 - OR
    // 000011 - SUB
    // 000100 - XOR
    // 000101 - SLT
    // 000110 - NOR
    // 000111 - BARREL SHIFTER
    // 001000 - UnsignMUL
   
    reg [8:0] temp;
    
  
    wire signed  [7:0] A_signed = A;
    wire signed [7:0] B_signed = B;
    wire signed [7:0] result_signed = result;
    
    //for unsigned multiplication
    wire [15:0] mul16;
    
    shift_add_mul u_mul (
    .A(A),
    .B(B),
    .product(mul16)
);
    //for signed multiplication
    wire [15:0] mul16_s;
    // let us consider input for signed multiplication is given in 2's complement form 
    shift_add_mul s_mul (
    .A(A),
    .B(B),
    .product(mul16_s)
);

    always @(posedge clk)
    begin

        case(op)

            // ADD
            6'b000000: begin
                temp = A_signed + B_signed;
                result <= temp[7:0];
                carry <= temp[8];
                overflow <= ((A_signed > 0 && B_signed > 0 && result_signed < 0) ||
                             (A_signed < 0 && B_signed < 0 && result_signed > 0));
            end

            // AND
            6'b000001: begin
                result <= A & B;
                carry <= 0;
                overflow <= 0;
            end

            // OR
            6'b000010: begin
                result <= A | B;
                carry <= 0;
                overflow <= 0;
            end

            // SUB
            6'b000011: begin
                result <= A_signed - B_signed;
                carry <= (A < B) ? 1 : 0;
                overflow <= ((A_signed > 0 && B_signed < 0 && result_signed < 0) ||
                             (A_signed < 0 && B_signed > 0 && result_signed > 0));
            end

            // XOR
            6'b000100: begin
                result <= A ^ B;
                carry <= 0;
                overflow <= 0;
            end

            // SLT
            6'b000101: begin
                result <= (A_signed < B_signed) ? 8'b00000001 : 8'b00000000;
                carry <= 0;
                overflow <= 0;
            end

            // NOR
            6'b000110: begin
                result <= ~(A | B);
                carry <= 0;
                overflow <= 0;
            end
            
            // BARREL SHIFTER
            6'b000111: begin
                result <=0;
                barrel_a_result <= A<<shift_control;
                barrel_b_result <= B<<shift_control;
            end
            //UNSIGNED MULTIPLICATION
            6'b001000: begin
                unsigned_mul_result <= mul16; // full 16-bit result
                result              <= mul16[7:0]; // lower 8 bits for compatibility
                carry               <= 0;
                overflow            <= 0;
            end 
            
            //SIGNED MULTIPLICATION
            6'b001001: begin
                signed_mul_result <= mul16_s; // full 16-bit result
                result              <= mul16_s[7:0]; // lower 8 bits for compatibility
                carry               <= 0;
                overflow            <= 0;
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
