`timescale 1ns / 1ps

module ALU_tb;

    reg clk;
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] op;
    wire [7:0] result;
    wire zero;
    wire carry;
    wire overflow;

    
    ALU uut (
        .clk(clk),
        .A(A),
        .B(B),
        .op(op),
        .result(result),
        .zero(zero),
        .carry(carry),
        .overflow(overflow)
    );

    
    always #5 clk = ~clk;

    initial begin
        
        clk = 0;
        A = 0;
        B = 0;
        op = 3'b000;

        $monitor("Time=%0t | A=%b B=%b | op=%b | result=%b | zero=%b | carry=%b | overflow = %b", 
                  $time, A, B, op, result, zero, carry, overflow);

        // Test ADD
        #10 A = 8'b00001111; B = 8'b00000001; op = 3'b000; // 15 + 1 = 16
        // Test AND
        #10 A = 8'b10101010; B = 8'b11001100; op = 3'b001; // AND
        // Test AND
        #10 A = 8'b01111000; B = 8'b00001000; op = 3'b000; // ADD
        // Test OR
        #10 A = 8'b10100000; B = 8'b00001111; op = 3'b010; // OR
        // Test SUB no borrow
        #10 A = 8'b00010000; B = 8'b00000100; op = 3'b011; // 16 - 4 = 12
        // Test SUB with borrow
        #10 A = 8'b00000100; B = 8'b00010000; op = 3'b011; // 4 - 16 = underflow
        // Test XOR
        #10 A = 8'b11110000; B = 8'b00101111; op = 3'b100; // XOR
        // Test SLT
        #10 A = 8'b01110010; B = 8'b10001111; op = 3'b101; // SLT
        // Test NOR
        #10 A = 8'b11010000; B = 8'b01001111; op = 3'b110; // NOR
        // Test zero flag
        #10 A = 8'b00000000; B = 8'b00000000; op = 3'b001; // AND: 0
        // Finish
        #20 $finish;
    end

endmodule

