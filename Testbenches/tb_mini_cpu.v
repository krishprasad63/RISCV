`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2025 16:42:40
// Design Name: 
// Module Name: tb_mini_cpu
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


module tb_mini_cpu();

    // Testbench signals
    reg clk;
    reg reset;
    reg load_enable;
    reg fetch_enable;
    reg reg_write_enable;
    reg [31:0] load_address;
    reg [31:0] load_data;
    reg [31:0] base_pc;

    wire [31:0] write_back_data;

    // Instantiate the Unit Under Test (UUT)
    mini_cpu uut (
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

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period, 100MHz clock
    end

    // Test sequence
    initial begin
        // 1. Initialize signals and apply reset
        $display("----------------------------------------------------");
        $display("Starting Testbench: Initializing and Resetting CPU");
        $display("----------------------------------------------------");
        base_pc = 32'h0000_0000; // Start program at address 0
        load_enable = 1'b0;
        fetch_enable = 1'b0;
        reg_write_enable = 1'b0;
        reset = 1'b1;
        #20; // Hold reset for 2 clock cycles
        reset = 1'b0;
        $display("Reset released. Starting to load program into memory.");

        // 2. Load the program into instruction memory
        // Instruction 1: ADDI x1, x0, 5 (0x00500093) at address 0x0
        load_enable = 1'b1;
        load_address = 32'h0000_0000;
        load_data = 32'h00500093;
        #10;

        // Instruction 2: ADDI x2, x0, 10 (0x00A00113) at address 0x4
        load_address = 32'h0000_0004;
        load_data = 32'h00A00113;
        #10;

        // Instruction 3: ADD x3, x1, x2 (0x002081B3) at address 0x8
        load_address = 32'h0000_0014;
        load_data = 32'h002081B3;
        #10;

        // 3. Start the CPU
        load_enable = 1'b0; // Stop loading
        fetch_enable = 1'b1; // Start fetching
        reg_write_enable = 1'b1; // Enable register writes
        $display("Program loaded. Enabling fetch and register writes.");
        $display("----------------------------------------------------");
        $display("Time(ns)\tPC\t\tInstruction\tWB_Data\t\tWB_Reg\tWB_Enable");
        $display("----------------------------------------------------");

        // 4. Run for enough cycles to see the result
        #100; // Run for 10 clock cycles

        // 5. End simulation
        $display("----------------------------------------------------");
        $display("Simulation finished.");
        $finish;
    end
    
    // Monitor to observe pipeline behavior
    // We monitor the signals coming out of the final pipeline register (MEM/WB)
    always @(posedge clk) begin
        if(fetch_enable) begin
             $display("%0t\t%h\t%h\t%h\t\tx%0d\t%b", 
                $time, 
                uut.pc,                          // Current Program Counter in Fetch Stage
                uut.fetched_instruction,         // Instruction being fetched
                uut.write_back_data,             // Data being written back
                uut.wb_rd,                       // Destination register for write back
                uut.reg_write_enable & (uut.wb_rd != 0) // Effective write enable
            );
        end
    end

endmodule