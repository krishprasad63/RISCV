`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.07.2025 14:41:17
// Design Name: 
// Module Name: memory_stage
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


module memory_stage(
    input clk,
    input mem_write,
    input [31:0] alu_result, //address for load/store
    input [31:0] rs2_data,    // value to store
    output[31:0] read_data_out
    );
    reg [31:0] DataMemory [0:1023];  // 1K memory words
    
    assign read_data_out = DataMemory[alu_result[11:2]]; // Corrected for 32-bit word addressing
    always @(posedge clk) begin
        if (mem_write) begin
            DataMemory[alu_result[11:2]] <= rs2_data;
        end
    end

endmodule

