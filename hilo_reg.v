`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/11 21:01:02
// Design Name: 
// Module Name: hilo_reg
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


module hilo_reg(
    input wire clk,rst,
    input wire [1:0]we,
    input wire [63:0]data,
    input wire addr,
    output wire [31:0] result
    );
    
    reg [31:0]hi_o, lo_o;

    always @(negedge clk) begin
        if(rst) begin
            hi_o <= 0;
            lo_o <= 0;
        end else begin
            if(we[1] == 1'b1) begin
                hi_o <= data[63:32];
            end
            if(we[0] == 1'b1) begin
                lo_o <= data[31:0];
            end
        end
    end

    assign result = (addr==1'b1) ? hi_o : lo_o;

    //assign rd = (ra != 0)? 

endmodule
