`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/23 15:21:30
// Design Name: 
// Module Name: controller
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


module controller(
	input wire clk,rst,

	//decode stage
	input wire[5:0] opD,functD,
	input wire[4:0] rtD,
	output wire pcsrcD,branchD,
	input wire equalD,
	output wire jumpD,
	output wire[4:0] alucontrolD,
	output wire jrD,balD,jalD,

	//execute stage
	input wire flushE,stallE,
	output wire memtoregE,alusrcE,
	output wire regdstE,regwriteE,
	output wire [1:0] hilowriteE,
	output wire hiloreadE,hilotoregE,
	output wire jalE,jumpE,

	//mem stage
	output wire memtoregM,memwriteM,
				regwriteM,
	output wire [1:0] hilowriteM,
	output wire hiloreadM,hilotoregM,
	//write back stage
	output wire memtoregW,regwriteW,
	output wire [1:0] hilowriteW,
	output wire hiloreadW,hilotoregW
    );
	
	//decode stage
	//wire[1:0] aluopD;
	wire memtoregD,memwriteD,alusrcD,
		regdstD,regwriteD;
	wire [1:0] hilowriteD;
	//wire jalD;
	wire hiloreadD,hilotoregD;

	//execute stage
	wire memwriteE;

	maindec md(
		.op 		(opD),
		.funct 		(functD),
		.rt 		(rtD),
		.memtoreg 	(memtoregD),
		.memwrite 	(memwriteD),
		.branch 	(branchD),
		.alusrc 	(alusrcD),
		.regdst 	(regdstD),
		.regwrite 	(regwriteD),
		.jump 		(jumpD),
		.jal		(jalD),
		.jr			(jrD),
		.bal		(balD),
		.hilowrite 	(hilowriteD),
		.hiloread   (hiloreadD),
		.hilotoreg 	(hilotoregD)

		//.aluop 		(aluopD)
		);
	aludec ad(.funct(functD),.op(opD),.alucontrol(alucontrolD));

	assign pcsrcD = branchD & equalD;

	//pipeline registers
	flopenrc #(11) regE(
		clk,
		rst,
		~stallE,
		flushE,
		{memtoregD,memwriteD,alusrcD,regdstD,regwriteD,hilowriteD,hiloreadD,hilotoregD,jalD,jumpD},
		{memtoregE,memwriteE,alusrcE,regdstE,regwriteE,hilowriteE,hiloreadE,hilotoregE,jalE,jumpE}
		);
	flopr #(7) regM(
		clk,rst,
		{memtoregE,memwriteE,regwriteE,hilowriteE,hiloreadE,hilotoregE},
		{memtoregM,memwriteM,regwriteM,hilowriteM,hiloreadM,hilotoregM}
		);
	flopr #(6) regW(
		clk,rst,
		{memtoregM,regwriteM,hilowriteM,hiloreadM,hilotoregM},
		{memtoregW,regwriteW,hilowriteW,hiloreadW,hilotoregW}
		);
endmodule
