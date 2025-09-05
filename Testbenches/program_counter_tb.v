`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2025 13:11:21
// Design Name: 
// Module Name: program_counter_tb
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


module program_counter_tb;

    reg clk;
    reg reset;
    reg enable;
    reg [15:0] base_address;
    wire [15:0] pc;

    program_counter uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .base_address(base_address),
        .pc(pc)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("file_vcd.vcd");
        $dumpvars(0, program_counter_tb);
        $monitor("Time: %0t | reset=%b enable=%b base_address=%d | pc=%d", 
                  $time, reset, enable, base_address, pc);

        reset = 0;
        enable = 0;
        base_address = 16'd10;

        #10 reset = 1;
        #10 reset = 0;
        #10 enable = 1;
        #100 enable = 0;
        #10 enable = 1;
        #30 $finish;
    end

endmodule