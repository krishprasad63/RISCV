`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2025 14:04:43
// Design Name: 
// Module Name: ALU_4
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

// 32 bit operations will be done now
module ALU_RISCV(
    input [31:0] A,
    input [31:0] B,
    input [6:0] op,
    input [2:0] funct3, //shift type
    input [6:0] funct7,
    output reg [31:0] result,
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



    wire signed  [31:0] A_signed = A;
    wire signed [31:0] B_signed = B;
    wire signed [31:0] result_signed = result;

    //for unsigned multiplication
    wire [63:0] mul_product;
    shift_add_mul_64 u_mul (
        .A(A),
        .B(B),
        .product(mul_product)
    );



    always @(*)
    begin

        case(op)

            // ADD
            7'b0000000: begin
                {carry, result} = A + B;
                overflow = ((A[31] == B[31]) && (result[31] != A[31]));
            end

            // AND
            7'b0000001: begin
                result = A & B;
                carry = 0;
                overflow = 0;
            end

            // OR
            7'b0000010: begin
                result = A | B;
                carry = 0;
                overflow = 0;
            end

            // SUB
            7'b0000011: begin

                result = A - B;
                carry = (A < B) ? 1 : 0;
                overflow = ((A[31] != B[31]) && (result[31] != A[31]));

            end

            // XOR
            7'b0000100: begin
                result = A ^ B;
                carry = 0;
                overflow = 0;
            end

            // SLT
            7'b0000101: begin
                result = (A_signed < B_signed) ? 32'd1 : 32'd0;
                carry = 0;
                overflow = 0;
            end

            // NOR
            7'b0000110: begin
                result = ~(A | B);
                carry = 0;
                overflow = 0;
            end

            // BARREL SHIFTER
            7'b0000111:begin // R-type operations
                case (funct3)
                    3'b001: begin // SLL
                        result = A << B[4:0];
                    end
                    3'b101: begin
                        if (funct7 == 7'b0000000) begin // SRL
                            result = A >> B[4:0];
                        end
                        else if (funct7 == 7'b0100000) begin // SRA
                            result = $signed(A) >>> B[4:0];
                        end
                    end
                    default: result = 0; // fallback
                endcase
            end

            //UNSIGNED MULTIPLICATION
            7'b0001000: begin
                result   = mul_product[31:0]; // full 16-bit result
                carry    = 0;
                overflow = 0;
            end

            //SIGNED MULTIPLICATION
            7'b0001001: begin
                result = mul_product[31:0]; // full 16-bit result//incorrect for time being
                carry = 0;
                overflow = 0;
            end

            // BRANCH COMPARISONS

            //BEQ
            7'b0100000: begin
                result = (A==B)?1:0;
            end

            //BNEQ
            7'b0100001: begin 
                result = (A!=B)?1:0;
            end

            //BLT
            7'b0100010: begin 
                result = (A_signed<B_signed)?1:0;
            end

            //BGE
            7'b0100011: begin 
                result = (A_signed>=B_signed)?1:0;
            end


            // default
            default: begin
                result = 32'b00000000;
                carry = 0;
                overflow = 0;
            end

        endcase

        //zero <= (result == 32'b00000000) ? 1 : 0;
        zero = (result == 0);
    end

endmodule
