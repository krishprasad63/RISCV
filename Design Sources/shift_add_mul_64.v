`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2025 14:29:09
// Design Name: 
// Module Name: shift_add_mul_64
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


module shift_add_mul_64(

        input  wire [31:0] A,      // 8-bit multiplicand
        input  wire [31:0] B,      // 8-bit multiplier
        output reg  [63:0] product
    );
    reg [63:0] multiplicand;
    reg [31:0]  multiplier;
    integer    i;
    
    always @(*) begin
        multiplicand = {32'b0, A};  // zero-extend A to 64 bits
        multiplier   = B;
        product  = 64'b0;
        
        for (i = 0; i < 32; i = i + 1) begin
            if (multiplier[0])
                product = product + multiplicand;
            multiplicand = multiplicand << 1;
            multiplier   = multiplier   >> 1;
        end
    end
endmodule