`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/11 19:04:27
// Design Name: 
// Module Name: alu
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
`include "defines.vh"

module alu( 
    // input wire [7:0] num1,
    // input wire [2:0] op,
    // output [31:0] result
    input wire clk,rst,
    input wire [31:0]srca,
    input wire [31:0]srcb,
    input wire [4:0]sa,
    input wire [4:0]alucontrol,
    output wire [31:0]aluresult,
    output wire overflow,
    //output wire [31:0]hiresult,loresult  //输出一个64位的或者32位的数据，先不看除法
    output wire[63:0]hiloresult,
    output reg stall_div
);

      assign overflow =  
                    ((alucontrol == `ADD_CONTROL) && (srca[31]==srcb[31]) && (aluresult[31]!=srca[31]))? 1 :
                    ((alucontrol == `SUB_CONTROL) && (srca[31]!=srcb[31]) && (aluresult[31]==srcb[31]))? 1 : 0;
      wire [31:0]mult_a,mult_b;
      wire [63:0]hilo_mult,hilo_div;
      reg [31:0]div_a,div_b;
      reg start_div, signed_div_i;
      wire ready_o;

      always @(posedge start_div) begin 
            div_a <= srca;
            div_b <= srcb;
      end

      div div(
              .clk(clk),
              .rst(rst),
              .signed_div_i(signed_div_i),
              .opdata1_i(div_a),
              .opdata2_i(div_b),
              .start_i(start_div),
              .annul_i(1'b0),
              .result_o(hilo_div),
              .ready_o(ready_o));

//div module
    initial begin
        start_div <= 1'b0;
        signed_div_i <= 1'b0;
        stall_div <= 1'b0; 
    end
    
    always @(*) begin
            if((alucontrol == `DIV_CONTROL) || (alucontrol == `DIVU_CONTROL)) begin
                    if(ready_o == 1'b0) begin
                        start_div <= 1'b1;
                        signed_div_i <= (alucontrol == `DIV_CONTROL) ? 1'b1 : 1'b0;
                        stall_div <= 1'b1;
                    end
                     else if(ready_o == 1'b1) begin
                        start_div <= 1'b0;
                        signed_div_i <= (alucontrol == `DIV_CONTROL) ? 1'b1 : 1'b0;
                        stall_div <= 1'b0;
                    end
                    else begin
                        start_div <= 1'b0;
                        signed_div_i <= 1'b0;
                        stall_div <= 1'b0;   
                    end
            end
            // else begin
            //          start_div <= 1'b0;
            //          signed_div_i <= 1'b0;
            //          stall_div <= 1'b0;   
            //       end
    end

      //simple result
      assign aluresult = 
                    (alucontrol == `ADD_CONTROL)? srca + srcb :
                    (alucontrol == `ADDU_CONTROL)? srca + srcb :
                    (alucontrol == `SUB_CONTROL)? srca - srcb :
                    (alucontrol == `SUBU_CONTROL)? srca - srcb :

                    (alucontrol == `AND_CONTROL)? srca & srcb :
                    (alucontrol == `OR_CONTROL)? srca | srcb :
                    (alucontrol == `XOR_CONTROL)? srca ^ srcb :
                    (alucontrol == `NOR_CONTROL)? ~(srca | srcb) :
                    (alucontrol == `LUI_CONTROL)? {srcb[15:0],16'b00000000} :
                    ((alucontrol == `SLT_CONTROL) && (srca[31]!=srcb[31]))? ((srca > srcb)? 1 : 0) : //负数小于正数，大小关系相反
                    ((alucontrol == `SLT_CONTROL) && (srca[31]==srcb[31]))? ((srca < srcb)? 1 : 0) : //符号相同，大小关系不变
                    ((alucontrol == `SLTU_CONTROL))? ((srca < srcb)? 1 : 0) :

                    //shift instructions
                    (alucontrol == `SLL_CONTROL)? srcb << sa :
                    (alucontrol == `SRL_CONTROL)? srcb >> sa :
                    (alucontrol == `SRA_CONTROL)? ({32{srcb[31]}} << (6'd32-{1'b0,sa})) | srcb >> sa:
                    (alucontrol == `SLLV_CONTROL)? srcb << srca[4:0] :
                    (alucontrol == `SRLV_CONTROL)? srcb >> srca[4:0] :
                    (alucontrol == `SRAV_CONTROL)? ({32{srcb[31]}} << (6'd32-{1'b0,srca[4:0]})) | srcb >> srca[4:0] :

                    //(alucontrol == 3'b101)? srca | ~srcb:
                    //(alucontrol == 3'b100)? srca & ~srcb:
                    
                    //(alucontrol == 3'b011)? ~srca: 
                    32'h00000000;

      assign mult_a = ((alucontrol == `MULT_CONTROL) && (srca[31]==1'b1)) ? (~srca + 1): srca;
      assign mult_b = ((alucontrol == `MULT_CONTROL) && (srcb[31]==1'b1)) ? (~srcb + 1): srcb;
      assign hilo_mult = ((alucontrol == `MULT_CONTROL) && (srca[31] ^ srcb[31] == 1'b1))? 
              ~(mult_a * mult_b) + 1 : mult_a * mult_b;

      assign hiloresult = 
                    (alucontrol == `MTHI_CONTROL)? {(srca+srcb), 32'b0} :
                    (alucontrol == `MTLO_CONTROL)? {32'b0, (srca+srcb)} :
                    (alucontrol == `MULT_CONTROL)? hilo_mult :
                    (alucontrol == `MULTU_CONTROL)? hilo_mult :
                    (alucontrol == `DIV_CONTROL)?   hilo_div :
                    (alucontrol == `DIVU_CONTROL)?   hilo_div :
                    64'b0;
    //assign zero = (alucontrol == 3'b110)?((srca == srcb)?1:0):0;
    
endmodule
