`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/23 22:57:01
// Design Name: 
// Module Name: eqcmp
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


module eqcmp(
	input wire [31:0] a,b,
    input wire [5:0]op,
    input wire [4:0] rtD,
	output reg y
    );

	//assign y = (a == b) ? 1 : 0;
    always @(*) begin
        case(op) 
            `BNE: y = (a != b)? 1'b1 : 1'b0;
            `BEQ: y = (a == b)? 1'b1 : 1'b0;
            `BGTZ: y = ((a[31]==1'b0) && (a!=31'b0))? 1'b1 : 1'b0;
            `BLEZ: y = ((a[31]==1'b1) || (a==31'b0))? 1'b1 : 1'b0;
            `REGIMM_INST:
                case(rtD) 
                    `BGEZ: y = (a[31] == 1'b0)? 1'b1 : 1'b0;
                    `BLTZ:  y = (a[31] == 1'b1)? 1'b1 : 1'b0;
                    `BGEZAL: y = (a[31] == 1'b0)? 1'b1 : 1'b0;
                    `BLTZAL: y = (a[31] == 1'b1)? 1'b1 : 1'b0;
                endcase // b
            endcase // bss
        end
endmodule


// `define J  6'b000010
// `define JAL  6'b000011
// `define JALR  6'b001001
// `define JR  6'b001000
// `define BEQ  6'b000100
// `define BGEZ  5'b00001
// `define BGEZAL  5'b10001  REGIMM_INST
// `define BGTZ  6'b000111
// `define BLEZ  6'b000110
// `define BLTZ  5'b00000
// `define BLTZAL  5'b10000
// `define BNE  6'b000101