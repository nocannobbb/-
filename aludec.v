`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/28 15:08:57
// Design Name: 
// Module Name: alu_decode
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
`include "defines.vh"

module aludec(
    input wire [5:0] funct,
    input wire [5:0] op,
    output reg [4:0] alucontrol
    //zero
    );


       always @(*) begin
        case(op)
            `LB:    alucontrol = `ADDU_CONTROL;
            `LBU:   alucontrol = `ADDU_CONTROL;
            `LH:    alucontrol = `ADDU_CONTROL;
            `LHU:   alucontrol = `ADDU_CONTROL;
            `LW:    alucontrol = `ADDU_CONTROL;
            `SB:    alucontrol = `ADDU_CONTROL;
            `SH:    alucontrol = `ADDU_CONTROL;
            `SW:    alucontrol = `ADDU_CONTROL;

            //branch
            `REGIMM_INST: alucontrol = `ADDU_CONTROL;
            `JAL:         alucontrol = `ADDU_CONTROL;
            //`ADDI:  alucontrol = `ADD_CONTROL;

            `ANDI:  alucontrol = `AND_CONTROL;
            `XORI:  alucontrol = `XOR_CONTROL;
            `LUI:   alucontrol = `LUI_CONTROL;
            `ORI:   alucontrol = `OR_CONTROL;
            `ADDI:   alucontrol = `ADD_CONTROL;
            `ADDIU:  alucontrol = `ADDU_CONTROL;
            `SLTI:   alucontrol = `SLT_CONTROL;
            `SLTIU:  alucontrol = `SLTU_CONTROL;

            `R_TYPE:case(funct)
                        `ADD:   alucontrol = `ADD_CONTROL;
                        `ADDU:  alucontrol = `ADDU_CONTROL;
                        `SUB:   alucontrol = `SUB_CONTROL;
                        `SUBU:   alucontrol = `SUBU_CONTROL;
                        `MULT:   alucontrol = `MULT_CONTROL;
                        `MULTU:   alucontrol = `MULTU_CONTROL;
                        `DIV:   alucontrol = `DIV_CONTROL;
                        `DIVU:   alucontrol = `DIVU_CONTROL;
                        `AND:   alucontrol = `AND_CONTROL;
                        `OR:    alucontrol = `OR_CONTROL;
                        `XOR:   alucontrol = `XOR_CONTROL;
                        `NOR:   alucontrol = `NOR_CONTROL;
                        `SLT:   alucontrol = `SLT_CONTROL;
                        `SLTU:   alucontrol = `SLTU_CONTROL;

                        //shift instructions
                        `SLL:   alucontrol = `SLL_CONTROL;
                        `SRL:   alucontrol = `SRL_CONTROL;
                        `SRA:   alucontrol = `SRA_CONTROL;
                        `SLLV:   alucontrol = `SLLV_CONTROL;
                        `SRLV:   alucontrol = `SRLV_CONTROL;
                        `SRAV:   alucontrol = `SRAV_CONTROL;

                        //data move instructions
                        `MFHI:  alucontrol = `MFHI_CONTROL;
                        `MFLO:  alucontrol = `MFLO_CONTROL;
                        `MTHI:  alucontrol = `MTHI_CONTROL;
                        `MTLO:  alucontrol = `MTLO_CONTROL;

                        //jr instructions
                        `JR:    alucontrol = `ADDU_CONTROL;
                        `JALR:  alucontrol = `ADDU_CONTROL;
                    endcase

        endcase
    end
endmodule
