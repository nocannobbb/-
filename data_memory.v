`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/14 22:01:28
// Design Name: 
// Module Name: data_memory
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

module data_memory(
    input wire clk,
    input wire memwrite,
    input wire [31:0] dataadr,writedata,
    output reg [31:0] finaldata,
    input wire [5:0] op
    );

    reg [31:0]writedata2;
    wire [31:0]readdata;
    reg [3:0]sel;

    always @(*) begin
        case(op)
            `LW: begin
                sel <= 4'b0000;
                finaldata <= readdata;
            end
            `LH: begin
                    sel <= 4'b0000;
                    case(dataadr[1:0])
                        2'b00: finaldata <= {{16{readdata[31]}},readdata[31:16]};
                        2'b10: finaldata <= {{16{readdata[15]}},readdata[15:0]};
                    endcase
                end
            `LHU: begin
                    sel <= 4'b0000;
                    case(dataadr[1:0])
                        2'b00: finaldata <= {16'b0,readdata[31:16]};
                        2'b10: finaldata <= {16'b0,readdata[15:0]};
                    endcase
            end

            `LB: begin
                    sel <= 4'b0000;
                    case(dataadr[1:0])
                        2'b00: finaldata <= {{24{readdata[7]}},readdata[7:0]};
                        2'b01: finaldata <= {{24{readdata[15]}},readdata[15:8]};
                        2'b10: finaldata <= {{24{readdata[23]}},readdata[23:16]};
                        2'b11: finaldata <= {{24{readdata[31]}},readdata[31:24]};
                    endcase
                end

            `LBU: begin
                    sel <= 4'b0000;
                    case(dataadr[1:0])
                        2'b00: finaldata <= {24'b0,readdata[7:0]};
                        2'b01: finaldata <= {24'b0,readdata[15:8]};
                        2'b10: finaldata <= {24'b0,readdata[23:16]};
                        2'b11: finaldata <= {24'b0,readdata[31:24]};
                    endcase
                end

            `SW: begin
                    writedata2 <= writedata;
                    sel <= 4'b1111;
                end
            `SH: begin
                    writedata2 <= {writedata[15:0],writedata[15:0]};
                    case(dataadr[1:0])
                        2'b00: sel <= 4'b1100;
                        2'b10: sel <= 4'b0011;
                        default:sel <= 4'b0000;
                    endcase
                end
            `SB: begin
                    writedata2 <= {writedata[7:0],writedata[7:0],writedata[7:0],writedata[7:0]};
                    case(dataadr[1:0])
                        2'b00: sel <= 4'b0001;
                        2'b01: sel <= 4'b0010;
                        2'b10: sel <= 4'b0100;
                        2'b11: sel <= 4'b1000;
                        default: sel <= 4'b0000;
                    endcase
                end


        endcase // op

    end


// data_mem dmem(.clka(~clk),.ena(memwrite),.wea(sel),.addra(dataadr),.dina(writedata2),.douta(readdata));
data_ram data_ram
(
    .clka  (~clk             ),   
    .ena   (memwrite        ),
    .wea   (sel       ),   //3:0
    .addra (dataadr[17:2]),   //15:0
    .dina  (writedata2     ),   //31:0
    .douta (readdata     )    //31:0
);
endmodule
