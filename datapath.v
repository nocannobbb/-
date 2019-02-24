`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 15:12:22
// Design Name: 
// Module Name: datapath
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


module datapath(
	input wire clk,rst,
	//fetch stage
	output wire[31:0] pcF,
	input wire[31:0] instrF,
	//decode stage
	input wire pcsrcD,branchD,
	input wire jumpD,
	output wire equalD,
	output wire[5:0] opD,functD,
	output wire [4:0] rtD,
	input wire[4:0] alucontrolD,
	input wire jrD,balD,jalD,
	
	//execute stage
	input wire memtoregE,
	input wire alusrcE,regdstE,
	input wire regwriteE,
	input wire [1:0] hilowriteE,
	input wire hiloreadE,
	input wire hilotoregE,
	output wire flushE,stallE,
	input wire jalE,jumpE,

	//mem stage
	input wire memtoregM,
	input wire regwriteM,
	input wire [1:0] hilowriteM,
	input wire hiloreadM,
	input wire hilotoregM,
	output wire[31:0] aluoutM,writedataM,
	input wire[31:0] readdataM,
	output wire [5:0] opM,
	//writeback stage
	input wire memtoregW,
	input wire regwriteW,
	input wire [1:0]hilowriteW,
	input wire hiloreadW,
	input wire hilotoregW,
	output wire [31:0]pcW,
	output wire [4:0]writeregW,
	output wire [31:0]resultW
    );
	
	//fetch stage
	wire stallF;
	//FD
	wire [31:0] pcnextFD,pcnextbrFD,pcplus4F,pcbranchD,pcnextjrFD;
	//decode stage
	wire [31:0] pcplus4D,instrD,pcD;
	wire forwardaD,forwardbD;
	wire [4:0] rsD,rdD;
	wire flushD,stallD; 
	wire [31:0] signimmD,signimmshD;
	wire [31:0] srcaD,srca2D,srcbD,srcb2D;
	//execute stage
	//wire stallE;
	wire [31:0] pcplus8E;
	wire [1:0] forwardaE,forwardbE;
	wire [5:0] opE;
	wire [4:0] rsE,rtE,rdE,rdEbr;
	wire [4:0] writeregE;
	wire [31:0] signimmE;
	wire [31:0] srcaE,srca2E,srcbE,srcb2E,srcb3E;
	wire [31:0] aluoutE,aluoutbrE,pcE;
	wire [4:0] alucontrolE;
	wire stall_divE;
	wire jrE,balE;
	//mem stage
	wire rtM;
	wire [4:0] writeregM;
	//writeback stage
	// wire [4:0] writeregW;
	wire [31:0] aluoutW,readdataW,memresultW; // memresult = mux(aluoutW, readdataW)
	// wire [31:0]resultW;
	wire [31:0] pcM;
	wire [4:0] saD,saE;
	wire overflow;
	wire [63:0]hiloresultE,hiloresultM,hiloresultW; // hilo input data
	wire [31:0]hilowriteback; // write back output
	// resultW = mux(memresultW, hilowriteback)

	//hazard detection
	hazard h(
		//fetch stage
		.stallF(stallF),
		//decode stage
		.rsD(rsD),.rtD(rtD),
		.branchD(branchD),
		.forwardaD(forwardaD),.forwardbD(forwardbD),
		.stallD(stallD),
		.jumpD(jumpD),
		.jrD(jrD),
		.balD(balD),
		//execute stage
		.stallE(stallE),
		.rsE(rsE),.rtE(rtE),
		.writeregE(writeregE),
		.regwriteE(regwriteE),
		.memtoregE(memtoregE),
		.forwardaE(forwardaE),
		.forwardbE(forwardbE),
		.flushE(flushE),
		.stall_divE(stall_divE),
		//mem stage
		.rtM(rtM),
		.writeregM(writeregM),
		.regwriteM(regwriteM),
		.memtoregM(memtoregM),
		//write back stage
		.writeregW(writeregW),
		.regwriteW(regwriteW)
		);

	//next PC logic (operates in fetch an decode)
	mux2 #(32) pcbrmux(pcplus4F,pcbranchD,pcsrcD,pcnextbrFD);
	mux2 #(32) pcjrmux(pcnextbrFD,srca2D,jrD,pcnextjrFD);   //mux jr signal
	mux2 #(32) pcmux(pcnextjrFD,
		{pcplus4D[31:28],instrD[25:0],2'b00},
		jumpD|jalD,pcnextFD);
	

	//regfile (operates in decode and writeback)
	regfile rf(clk,regwriteW,rsD,rtD,writeregW,resultW,srcaD,srcbD);

	//fetch stage logic
	flopenr #(32) pcreg(clk,rst,~stallF,pcnextFD,pcF);
	adder pcadd1(pcF,32'b100,pcplus4F);
	//decode stage
	flopenr #(32) r1D(clk,rst,~stallD,pcplus4F,pcplus4D);
	flopenrc #(32) r2D(clk,rst,~stallD,flushD,instrF,instrD);
	flopenr #(32) r3D(clk,rst,~stallD,pcF,pcD);


	

	signext se(instrD[15:0],instrD[29:28],signimmD);
	sl2 immsh(signimmD,signimmshD);
	adder pcadd2(pcplus4D,signimmshD,pcbranchD);
	mux2 #(32) forwardamux(srcaD,aluoutM,forwardaD,srca2D);
	mux2 #(32) forwardbmux(srcbD,aluoutM,forwardbD,srcb2D);
	eqcmp comp(srca2D,srcb2D,opD,rtD,equalD);
	// mux2 #(32) srcabrmux(srca2D,pcplus4D + 31'd4,jalD|balD|jrD,srcabrD);
	// mux2 #(32) srcbbrmux(srcb2D,32'b0,jalD|balD|jrD,srcbbrD);

	assign opD = instrD[31:26];
	assign rsD = instrD[25:21];
	assign rtD = instrD[20:16];
	assign rdD = instrD[15:11];
	assign saD = instrD[10:6];
	assign functD = instrD[5:0];


	//execute stage
	flopenrc #(32) r1E(clk,rst,~stallE,flushE,srca2D,srcaE);
	flopenrc #(32) r2E(clk,rst,~stallE,flushE,srcb2D,srcbE);
	flopenrc #(32) r3E(clk,rst,~stallE,flushE,signimmD,signimmE);
	flopenrc #(5)  r4E(clk,rst,~stallE,flushE,rsD,rsE);
	flopenrc #(5)  r5E(clk,rst,~stallE,flushE,rtD,rtE);
	flopenrc #(5)  r6E(clk,rst,~stallE,flushE,rdD,rdE);
	flopenrc #(5)  r7E(clk,rst,~stallE,flushE,saD,saE);
	flopenrc #(1)  r8E(clk,rst,~stallE,flushE,jrD,jrE);
	flopenrc #(1)  r9E(clk,rst,~stallE,flushE,balD,balE);
	flopenrc #(5)  r10E(clk,rst,~stallE,flushE,alucontrolD,alucontrolE);
	flopenrc #(32) r11E(clk,rst,~stallE,flushE,pcplus4D+4,pcplus8E);
	flopenrc #(6)  r12E(clk,rst,~stallE,flushE,opD,opE);
	flopenrc #(32)  r13E(clk,rst,~stallE,flushE,pcD,pcE);
	

	mux3 #(32) forwardaemux(srcaE,resultW,aluoutM,forwardaE,srca2E);
	mux3 #(32) forwardbemux(srcbE,resultW,aluoutM,forwardbE,srcb2E);
	mux2 #(32) srcbmux(srcb2E,signimmE,alusrcE,srcb3E);
	mux2 #(5) dstmux(rdE,5'd31,jalE|balE,rdEbr);
	mux2 #(5) wrmux(rtE,rdEbr,regdstE,writeregE);
	

	alu alu(
        .clk(clk),
        .rst(rst),
        .srca(srca2E),
		.srcb(srcb3E),
		.sa(saE),
		.alucontrol(alucontrolE),
		.aluresult(aluoutE),
		.overflow(overflow),
		.hiloresult(hiloresultE),
		.stall_div (stall_divE)
		);
	
	//mem stage
	flopr #(32) r1M(clk,rst,srcb2E,writedataM);
	mux2  #(32) brpcmux(aluoutE,pcplus8E,jalE|balE|(jrE&~jumpE),aluoutbrE);   //jrE&~jumpE 用来筛选jalr信号
	flopr #(32) r2M(clk,rst,aluoutbrE,aluoutM);
	flopr #(5)  r3M(clk,rst,writeregE,writeregM);
	flopr #(64)	r4M(clk,rst,hiloresultE,hiloresultM); //hilo 触发器
	flopr #(6)  r5M(clk,rst,opE,opM);
	flopr #(32) r6M(clk,rst,rtE,rtM);
	flopr #(32) r7M(clk,rst,pcE,pcM);

	//writeback stage
	flopr #(32) r1W(clk,rst,aluoutM,aluoutW);
	flopr #(32) r2W(clk,rst,readdataM,readdataW);
	flopr #(5) r3W(clk,rst,writeregM,writeregW);
	flopr #(64)	r4W(clk,rst,hiloresultM,hiloresultW);	//hilo触发器
	flopr #(32) r5W(clk,rst,pcM,pcW);

	mux2 #(32) resmux(aluoutW,readdataW,memtoregW,memresultW);
	mux2 #(32) hilomux(memresultW,hilowriteback,hilotoregW,resultW);  //hilo多选器

	hilo_reg hilo(.clk(clk),
			.rst(rst),
			.we(hilowriteW),
			.data(hiloresultW),
			.addr(hiloreadW),
			.result(hilowriteback)
			);
endmodule
