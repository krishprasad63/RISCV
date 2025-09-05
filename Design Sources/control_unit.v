`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2025 10:29:54
// Design Name: 
// Module Name: control_unit
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



module control_unit(
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [6:0] alu_op,
    output reg alu_src, //for deciding R-type and I-type in ALU
    output reg mem_read,
    output reg mem_write,
    output reg mem_to_reg,
    output reg beq_control,
    output reg bneq_control,
    output reg blt_control,
    output reg bge_control
    );
    parameter ALU_ADD  = 7'b0000000, ALU_AND  = 7'b0000001, ALU_OR   = 7'b0000010, ALU_SUB   = 7'b0000011,
              ALU_XOR  = 7'b0000100, ALU_SLT  = 7'b0000101, ALU_NOR  = 7'b0000110, ALU_SHIFT = 7'b0000111,
              ALU_UMUL = 7'b0001000, ALU_SMUL = 7'b0001001, ALU_BEQ  = 7'b0100000, ALU_BNEQ  = 7'b0100001,
              ALU_BLT  = 7'b0100010, ALU_BGE  = 7'b0100011;

    always @(opcode, funct3, funct7)
        begin
        // Default values to avoid latches
        alu_op       = ALU_ADD;
        alu_src      = 0;
        mem_read     = 0;
        mem_write    = 0;
        mem_to_reg   = 0;
        beq_control = 0;
        bneq_control = 0;
        blt_control = 0;
        bge_control = 0;
            case(opcode)
                //R-type: opcode 0110011
                7'b0110011:begin
                    alu_src = 0;
                    case(funct3)
                        3'b000: alu_op = (funct7 == 7'b0000000) ? ALU_ADD :
                                         (funct7 == 7'b0100000) ? ALU_SUB : 7'b1111111;
                        3'b111: alu_op = ALU_AND;
                        3'b110: alu_op = ALU_OR;
                        3'b100: alu_op = ALU_XOR;
                        3'b010: alu_op = ALU_SLT;
                        3'b001: alu_op = ALU_SHIFT;  // SLL
                        3'b101: alu_op = ALU_SHIFT;  // SRL/SRA (handled in ALU with funct7)
                        default: alu_op = 7'b1111111;
                    endcase
                end

                // I-type ALU: opcode 0010011
                7'b0010011: begin
                alu_src = 1;
                    case (funct3)
                        3'b000: alu_op = ALU_ADD;   // ADDI
                        3'b111: alu_op = ALU_AND;   // ANDI
                        3'b110: alu_op = ALU_OR;    // ORI
                        3'b100: alu_op = ALU_XOR;   // XORI
                        3'b010: alu_op = ALU_SLT;   // SLTI
                        3'b001: alu_op = ALU_SHIFT; // SLLI
                        3'b101: alu_op = ALU_SHIFT; // SRLI/SRAI (funct7 used in ALU)
                        default: alu_op = 7'b1111111;
                    endcase
                end

                //B-type ALU: OPCODE 1100011
                7'b1100011: begin
                    alu_src = 0;
                    mem_read = 0;
                    mem_write = 0;
                    mem_to_reg = 0;
                                // This is a branch instruction
                    case(funct3)
                        3'b000: begin
                            alu_op = ALU_BEQ;
                            beq_control = 1;
                        end
                        3'b001: begin
                            alu_op = ALU_BNEQ;
                            bneq_control = 1;
                        end
                        3'b010: begin 
                            alu_op = ALU_BLT;
                            blt_control = 1;
                        end
                        3'b011: begin 
                            alu_op = ALU_BGE;
                            bge_control = 1;
                        end
                        default: alu_op = 7'b1111111;  // Invalid branch type
                    endcase
                end
                // Custom opcodes for MUL (if used)
                7'b0001000: alu_op = ALU_UMUL;  // Unsigned Multiply
                7'b0001001: alu_op = ALU_SMUL;  // Signed Multiply

                //LW
                7'b0000011: begin
                        alu_op    = ALU_ADD;
                        alu_src   =1;
                        mem_read  =1;
                        mem_write = 0;
                        mem_to_reg = 1;
                end
                //SW
                7'b0100011: begin
                        alu_op    = ALU_ADD;
                        alu_src   =1;
                        mem_read=0;
                        mem_write = 1;
                        mem_to_reg = 0;
                end

                default:begin
                    alu_op = 7'b1111111;  // Invalid
                    alu_src = 0;
                    mem_read = 0;
                    mem_write = 0;
                    mem_to_reg = 0;
                end
            endcase

        end
endmodule