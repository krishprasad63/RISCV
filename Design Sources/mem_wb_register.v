`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2025 16:01:21
// Design Name: 
// Module Name: mem_wb_register
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


module mem_wb_register(
    input clk,
    input reset,

    // --- Inputs from Memory Stage ---
    input in_mem_to_reg,      // Control signal for final MUX
    input [31:0] in_read_data,   // Data from Data Memory
    input [31:0] in_alu_result,  // Result from ALU (passed through MEM)
    input [4:0]  in_rd,          // Destination register index

    // --- Outputs to Write Back Logic ---
    output reg out_mem_to_reg,
    output reg [31:0] out_read_data,
    output reg [31:0] out_alu_result,
    output reg [4:0]  out_rd
);

    always @(posedge clk or posedge reset)
    begin
        if (reset) begin
            // On reset, clear control signals and data
            out_mem_to_reg <= 1'b0;
            out_read_data  <= 32'b0;
            out_alu_result <= 32'b0;
            out_rd         <= 5'b0;
        end
        else begin
            // On a clock edge, capture all the inputs
            out_mem_to_reg <= in_mem_to_reg;
            out_read_data  <= in_read_data;
            out_alu_result <= in_alu_result;
            out_rd         <= in_rd;
        end
    end

endmodule