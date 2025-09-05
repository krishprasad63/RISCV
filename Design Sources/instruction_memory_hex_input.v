`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2025 13:36:13
// Design Name: 
// Module Name: instruction_memory_hex_input
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


module instruction_memory_hex_input(
    input clk,
    input write_en,
    input [31:0] pc,
    input  wire [31:0] address,     // Byte address
    input  wire [31:0] data_in,
    output [31:0] instruction
);

    // each index holds a 32-bit instruction
    reg [7:0] mem [0:1023];
    
    assign instruction = {mem[pc+3],mem[pc+2],mem[pc+1],mem[pc]}; 
    
    always @(posedge clk) begin
        if (write_en)
        begin
            mem[address] <= data_in[7:0];  // Store at word index
            mem[address+1] <= data_in[15:8];
            mem[address+2] <= data_in[23:16];
            mem[address+3] <= data_in[31:24];
        end
    end

endmodule