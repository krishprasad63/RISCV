`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.07.2025 09:34:19
// Design Name: 
// Module Name: testbench_ADD_SUB
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


module testbench_ADD_SUB;
    reg clk;
    reg reset;
    reg load_enable;
    reg fetch_enable;
    reg reg_write_enable;
    reg [31:0] load_address;
    reg [31:0] load_data;
    reg [31:0] base_pc;
    wire [31:0] write_back_data;
    
    mini_cpu cpu(
    .clk(clk),
    .reset(reset),
    .load_enable(load_enable),
    .fetch_enable(fetch_enable),
    .reg_write_enable(reg_write_enable),
    .load_address(load_address),
    .load_data(load_data),
    .base_pc(base_pc),
    .write_back_data(write_back_data)
    );
    
        
    initial begin
      clk = 0;
      forever #5 clk = ~clk;
    end
    
    initial begin
    base_pc = 32'h0000;
    load_enable = 0;
    fetch_enable=0;
    reg_write_enable = 0;
    load_address = 32'h0000;
 
        #20 reset = 1;
        
        #11 reset = 0;
        #10 load_enable = 1;
        //#10 load_enable =0;
        
        #10 load_address = 32'h0000; load_data = 32'h00A00213;
       
        #10 load_address = 32'h0004;load_data = 32'h00B00293;
        #2 reg_write_enable =1;
        //#2fetch_enable = 1;
        #10 load_address = 32'h0010; load_data = 32'h00428433;
        #14 load_enable =0;
        #2fetch_enable = 1;
        
        #600 fetch_enable=0;
        
        #100 $finish;
    end
endmodule
