`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 10:58:03
// Design Name: 
// Module Name: mips
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


// module mips(
// 	input wire clk,rst,
// 	output wire[31:0] pcF,
// 	input wire[31:0] instrF,
// 	output wire memwriteM,
// 	output wire[31:0] aluoutM,writedataM,
// 	input wire[31:0] readdataM,
// 	output wire [5:0]opM
//     );
module mycpu (
	input wire clk,    // Clock
	input wire resetn, // Clock Enable
	//input wire inta,  // Asynchronous reset active low

	output wire inst_sram_en,
	output wire [3:0] inst_sram_wen,
	input wire [31:0] inst_sram_addr,
	output wire [31:0] inst_sram_wdata,
	output wire[31:0] inst_sram_rdata,

	input wire data_sram_en,
	// input wire [3:0]data_sram_wen,
	input wire [31:0]data_sram_addr,
	input wire [31:0]data_sram_wdata,
	output wire [31:0]data_sram_rdata,
	output wire [5:0] opM,

	output wire [31:0]debug_wb_pc, //pcW
	output wire [3:0]debug_wb_rf_wen,//wea
	output wire [4:0]debug_wb_rf_wnum,//wa3
	output wire [31:0]debug_wb_rf_wdata//wd3
);

	wire rst;
	wire [31:0] pcF;
	wire [31:0] instrF;
	wire [31:0] aluoutM,writedataM;
	wire [31:0] readdataM,resultW;
	wire [4:0] writeregW;
	wire regwriteW,memwriteM;

	assign rst = ~resetn;
	assign inst_sram_en = 1'b1;
	assign inst_sram_wen = 4'b0000;
	assign inst_sram_wdata = 32'b0;
	assign instrF = inst_sram_rdata;

	assign data_sram_en = memwriteM;
	assign data_sram_addr = aluoutM;
	assign data_sram_wdata = writedataM;
	assign data_sram_rdata = readdataM;

	assign debug_wb_pc = pcW;
	assign debug_wb_rf_wen[0] = regwriteW; //4 bits
	assign debug_wb_rf_wnum = writeregW;
	assign debug_wb_rf_wdata = resultW;


	
	wire pcsrcD;
	wire [5:0] opD,functD;
	wire [4:0] rtD;
	wire equalD,jrD,jalD,balD,jumpD,branchD;
	wire [4:0] alucontrolD;

	wire regdstE,alusrcE,memtoregE,regwriteE,flushE,stallE;
	wire jalE,jumpE;
    wire [1:0] hilowriteE;
    wire hiloreadE,hilotoregE;
	
	wire memtoregM,regwriteM;
	wire [1:0] hilowriteM;
	wire hiloreadM,hilotoregM;

	wire memtoregW;
	// wire regwriteW;
	wire [1:0] hilowriteW;
	wire hiloreadW,hilotoregW;



	controller c(
		.clk(clk),.rst(rst),

		//decode stage
		.opD(opD),.functD(functD),.rtD(rtD),
		.pcsrcD(pcsrcD),
		.branchD(branchD),
		.equalD(equalD),
		.jumpD(jumpD),
		.jrD(jrD),
		.balD(balD),
		.jalD(jalD),
		.alucontrolD(alucontrolD),

		//execute stage
		.flushE(flushE),
		.stallE(stallE),
		.memtoregE(memtoregE),
		.alusrcE(alusrcE),
		.regdstE(regdstE),
		.regwriteE(regwriteE),
		.hilowriteE(hilowriteE),
        .hiloreadE (hiloreadE),
        .hilotoregE(hilotoregE),
        .jalE(jalE),
		.jumpE(jumpE),

		//mem stage
		.memtoregM(memtoregM),
		.memwriteM(memwriteM),
		.regwriteM(regwriteM),
		.hilowriteM(hilowriteM),
        .hiloreadM(hiloreadM),
        .hilotoregM(hilotoregM),

		//write back stage
		.memtoregW(memtoregW),
		.regwriteW(regwriteW),
		.hilowriteW(hilowriteW),
        .hiloreadW(hiloreadW),
        .hilotoregW(hilotoregW)
		);
	datapath dp(
		.clk		(clk),
		.rst 		(rst),
		//fetch stage
		.pcF 		(pcF),
		.instrF 	(instrF),
		//decode stage
		.pcsrcD 	(pcsrcD),
		.branchD	(branchD),
		.jumpD		(jumpD),
		.equalD		(equalD),
		.opD		(opD),
		.functD		(functD),
		.rtD		(rtD),
		.alucontrolD(alucontrolD),
		.jrD		(jrD),
		.balD		(balD),
		.jalD		(jalD),

		//execute stage
		.memtoregE	(memtoregE),
		.alusrcE	(alusrcE),
		.regdstE	(regdstE),
		.regwriteE	(regwriteE),
		.hilowriteE	(hilowriteE),
        .hiloreadE (hiloreadE),
        .hilotoregE(hilotoregE),
		.flushE		(flushE),
		.stallE		(stallE),
		.jalE		(jalE),
		.jumpE		(jumpE),
		//mem stage
		.memtoregM	(memtoregM),
		.regwriteM	(regwriteM),
		.hilowriteM	(hilowriteM),
        .hiloreadM(hiloreadM),
        .hilotoregM(hilotoregM),
		.aluoutM	(aluoutM),
		.writedataM	(writedataM),
		.readdataM	(readdataM),
		.opM		(opM),

		//writeback stage
		.memtoregW	(memtoregW),
		.regwriteW	(regwriteW),
		.hilowriteW	(hilowriteW),
        .hiloreadW(hiloreadW),
        .hilotoregW(hilotoregW),
        .pcW(pcW),
        .writeregW(writeregW),
        .resultW(resultW)
	    );
	
endmodule
