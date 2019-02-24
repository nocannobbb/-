`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 13:50:53
// Design Name: 
// Module Name: top
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


module top(
	input wire clk,rst,
	output wire[31:0] writedata,dataadr,
	output wire memwrite,
    output wire [39:0]ascall
    );

	wire[31:0] pc,instr,readdata;
    wire [5:0] opM;

	mips mips(
        .clk(clk),
        .rst(rst),
        .pcF(pc),
        .instrF(instr),
        .memwriteM(memwrite),
        .aluoutM(dataadr),
        .writedataM(writedata),
        .readdataM(readdata),
        .opM(opM));
	inst_mem imem(~clk,pc[9:2],instr);  //remember to change to RAM
	//data_mem dmem(~clk,{3'b000,memwrite},dataadr,writedata,readdata);
    data_memory dmem(
        .clk(clk),
        .memwrite(memwrite),
        .dataadr(dataadr),
        .writedata(writedata),
        .finaldata(readdata),
        .op(opM));
    instdec instdec(instr,ascall);
endmodule
