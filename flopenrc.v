`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/07 00:34:45
// Design Name: 
// Module Name: flopenrc
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
///////////////////////////////////////////////////////////////////////////////////
//flopenrc #(32) r2D(clk,rst,~stallD,flushD,instrF,instrD);

module flopenrc #(parameter WIDTH = 8)(
	input wire clk,rst,en,flush,
	input wire [WIDTH-1:0] d,
	output reg [WIDTH-1:0] q
    );
	
	always @(posedge clk or posedge rst) begin

		if(rst) begin
			q <= 0;

		end else if(flush) begin
			q <= 0;

		end else if(en) begin
			q <= d;
		end
		
	end
endmodule
