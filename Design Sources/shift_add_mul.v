`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.07.2025 17:29:39
// Design Name: 
// Module Name:shift_add_mul
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


module shift_add_mul(
        input  wire [7:0] A,      // 8-bit multiplicand
        input  wire [7:0] B,      // 8-bit multiplier
        output reg  [15:0] product
    );
    reg [15:0] multiplicand;
    reg [7:0]  multiplier;
    integer    i;
    
    always @(*) begin
        multiplicand = {8'b0, A};  // zero-extend A to 16 bits
        multiplier   = B;
        product  = 16'b0;
        
        for (i = 0; i < 8; i = i + 1) begin
            if (multiplier[0])
                product = product + multiplicand;
            multiplicand = multiplicand << 1;
            multiplier   = multiplier   >> 1;
        end
    end
endmodule