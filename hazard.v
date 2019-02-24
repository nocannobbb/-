`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/07 15:39:26
// Design Name: 
// Module Name: hazard
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

module hazard(
	//fetch stage
	output wire stallF,
	//decode stage
	input wire [4:0] rsD,rtD,
	input wire branchD,
	input wire jumpD,jrD,balD,
	output wire [1:0]forwardaD,
	output wire [1:0]forwardbD,
	output wire stallD,
	//execute stage
	input wire stallE,
	input wire [4:0] rsE,rtE,
	input wire [4:0] writeregE,
	input wire regwriteE,
	input wire memtoregE,
	output wire [1:0]forwardaE,
	output wire [1:0]forwardbE,
	output wire flushE,
	input wire stall_divE,
	//mem stage
	input wire [4:0]rtM,
	input wire [4:0] writeregM,
	input wire regwriteM,
	input wire memtoregM,
	//write back stage 
	input wire [4:0] writeregW,
	input wire regwriteW
    );
	
	wire lwstall;
	wire branchstall; 



	assign forwardaE = ((rsE != 0) && (rsE == writeregM) && regwriteM) ? 2'b10 :
						((rsE != 0) && (rsE == writeregW) && regwriteW) ? 2'b01 : 2'b00 ;
	assign forwardbE = ((rtE != 0) && (rtE == writeregM) && regwriteM) ? 2'b10 :
						((rtE != 0) && (rtE == writeregW) && regwriteW) ? 2'b01 : 2'b00 ;

	assign lwstall = (((rsD==rtE) || (rtD==rtE)) && memtoregE) ||
						(((rsD==rtM) || (rtD==rtM)) && memtoregM);
	// assign hilostall = ((rsD==rtE) || (rtD==rtE)) && hilotoregE;




	assign forwardaD = (rsD !=0) && (rsD == writeregM) && regwriteM;
	assign forwardbD = (rtD !=0) && (rtD == writeregM) && regwriteM;

	assign branchstall = (branchD && regwriteE && 
                   (writeregE == rsD || writeregE == rtD));
					// ||(branchD && memtoregM && (writeregM == rsD || writeregM == rtD));

						// branchstall = BranchD AND RegWriteE AND 
      //              (WriteRegE == rsD OR WriteRegE == rtD) 
      //            OR BranchD AND MemtoRegM AND 
      //              (WriteRegM == rsD OR WriteRegM == rtD)


	

    assign  flushE = (lwstall || branchstall) || jumpD || (~balD&branchD);
    assign  stallD = lwstall || branchstall || stall_divE;
    assign  stallF = lwstall || branchstall || stall_divE;
    assign  stallE = stall_divE;





endmodule
