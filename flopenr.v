`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/06 17:22:32
// Design Name: 
// Module Name: flopenr
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
//flopenr #(32) r1D(clk,rst,~stallD,pcplus4F,pcplus4D);

module flopenr #(parameter WIDTH = 8)(
	input wire clk,rst,en,
	input wire [WIDTH-1:0] d,
	output reg [WIDTH-1:0] q
    );
	
	always @(posedge clk or posedge rst) begin

		if(rst) begin
			q <= 0;

		end else if(en) begin
			q <= d;
		end
		
	end
endmodule
