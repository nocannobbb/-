`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/14 20:15:32
// Design Name: 
// Module Name: mux2
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


module mux2(
    input_0,input_1,choose_bit,next
    );
    parameter width = 32;
    input wire[width-1:0] input_0;
    input wire[width-1:0] input_1;
    input wire choose_bit;
    output reg[width-1:0] next;
 always @(*) begin 
    if(choose_bit == 1)
    begin
         next = input_1;
    end
    else 
    begin
         next = input_0;
    end   
end

endmodule
