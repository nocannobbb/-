`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/28 15:08:26
// Design Name: 
// Module Name: main_decde
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

module maindec(
    input wire [5:0] op,
    input wire [5:0] funct,
    input wire [4:0] rt,
    output memtoreg,memwrite,branch,alusrc,regdst,regwrite,jump,jal,jr,bal,
    output wire [1:0] hilowrite,
    output wire hiloread,
    output wire hilotoreg,
    output wire start_div,signed_div_i,stall_div
    //output [1:0] aluop
    );
    //wire pcsrc;
    //reg branch;

   reg [13:0]commands;
   assign {memtoreg,memwrite,
            branch,alusrc,
            regdst,regwrite,jump,  //7 bits
            hilowrite,
            hiloread,hilotoreg,     //11 bits
            jal,jr,bal
            } = commands; 

      always @(*) begin
        case(op) 
            `R_TYPE:
                case(funct) 
                    `MULT:  commands <= 14'b00_00_100_11_00_000;
                    `MULTU: commands <= 14'b00_00_100_11_00_000;
                    `MFHI:  commands <= 14'b00_00_110_00_11_000;
                    `MFLO:  commands <= 14'b00_00_110_00_01_000;
                    `MTHI:  commands <= 14'b00_00_100_10_00_000;
                    `MTLO:  commands <= 14'b00_00_100_01_00_000;
                    `DIV:   commands <= 14'b00_00_100_11_00_000;
                    `DIVU:  commands <= 14'b00_00_100_11_00_000;
                    `JR:commands <=     14'b00_00_000_00_00_010;
                    `JALR:commands <=   14'b00_00_110_00_00_010;
                    default:commands <= 14'b00_00_110_00_00_000;
                endcase // funct

            
            
            
            `LB:commands <= 14'b10_01_010_00_00_000;
            `LBU:commands <= 14'b10_01_010_00_00_000;
            `LH:commands <= 14'b10_01_010_00_00_000;
            `LHU:commands <= 14'b10_01_010_00_00_000;
            `LW:commands <= 14'b10_01_010_00_00_000;
            `SB:commands <= 14'b01_01_000_00_00_000;
            `SH:commands <= 14'b01_01_000_00_00_000;
            `SW:commands <= 14'b01_01_000_00_00_000;


            //   assign {memtoreg,memwrite,
            // branch,alusrc,
            // regdst,regwrite,jump,  //7 bits
            // hilowrite,
            // hiloread,hilotoreg,     //11 bits
            // jal,jr,bal
            // } = commands; 

            `ADDI:commands <= 14'b00_01_010_00_00_000;
            `ADDIU:commands <= 14'b00_01_010_00_00_000;
            `ANDI:commands <= 14'b00_01_010_00_00_000;
            `XORI:commands <= 14'b00_01_010_00_00_000;
            `LUI: commands <= 14'b00_01_010_00_00_000;
            `ORI: commands <= 14'b00_01_010_00_00_000;
            `SLTI:commands <= 14'b00_01_010_00_00_000;
            `SLTIU:commands <= 14'b00_01_010_00_00_000;
            
            `J:commands <=   14'b00_00_001_00_00_000;
            `JAL:commands <= 14'b00_00_110_00_00_100;
            `BEQ:commands <= 14'b00_10_000_00_00_000;
            `BNE:commands <= 14'b00_10_000_00_00_000;
            `BGTZ:commands <= 14'b00_10_000_00_00_000;
            `BLEZ:commands <=   14'b00_10_000_00_00_000;
            `REGIMM_INST:
                case(rt)
                    `BGEZ:commands <=   14'b00_10_000_00_00_000;
                    `BLTZ:commands <=   14'b00_10_000_00_00_000;
                    `BGEZAL:commands <= 14'b00_10_110_00_00_001;
                    `BLTZAL:commands <= 14'b00_10_110_00_00_001;
                endcase
            
   // assign {memtoreg,memwrite,
   //          branch,alusrc,
   //          regdst,regwrite,jump,  //7 bits
   //          hilowrite,
   //          hiloread,hilotoreg,     //11 bits
   //          jal,jr,bal
   //          } = commands; 



            default: commands <= 14'b00_00_000_00_00_000;
        endcase // op
    end
    //assign pcsrc=branch&zero;

endmodule
