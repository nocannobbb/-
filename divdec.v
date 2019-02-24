`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/13 12:50:47
// Design Name: 
// Module Name: divdec
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
    //divdec dd(.funct(functD),.op(opD),.ready_o(ready_oE),.start_div(start_divD),
                    //.signed_div_i(signed_div_iD),.stall_div(stall_divD))
`include "defines.vh"                    

module divdec(
    input wire [5:0] funct,
    input wire [5:0] op,
    input wire ready_o,
    output reg start_div,
    output reg signed_div_i,
    output reg stall_div
    );
    
    initial begin
        start_div <= 1'b0;
        signed_div_i <= 1'b0;
        stall_div <= 1'b0; 
    end
    
    always @(*) begin
            if((op == `R_TYPE) && ((funct == `DIV) || (funct == `DIVU)) ) begin
                    if(ready_o == 1'b0) begin
                        start_div <= 1'b1;
                        signed_div_i <= (funct == `DIV) ? 1'b1 : 1'b0;
                        stall_div <= 1'b1;
                    end
                     else if(ready_o == 1'b1) begin
                        start_div <= 1'b0;
                        signed_div_i <= (funct == `DIV) ? 1'b1 : 1'b0;
                        stall_div <= 1'b0;
                    end
                    else begin
                        start_div <= 1'b0;
                        signed_div_i <= 1'b0;
                        stall_div <= 1'b0;   
                    end
            end
    end
endmodule
