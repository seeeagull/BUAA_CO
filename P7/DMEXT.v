`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:20:40 12/04/2021 
// Design Name: 
// Module Name:    DMEXT 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module DMEXT(
    input [1:0] A,
    input [31:0] Din,
    input [2:0] Op,
    output [31:0] Dout
    );
	
	wire [7:0] DB3, DB2, DB1, DB0, DB;
	wire [15:0] DH1, DH0, DH;
	
	assign {DB3, DB2, DB1, DB0} = Din;
	assign {DH1, DH0} = Din;
	assign DB	=	(A == 2'b11) ? DB3 :
						(A == 2'b10) ? DB2 :
						(A == 2'B01) ? DB1 :
						DB0;
	assign DH	=	(A[1] == 1'b1) ? DH1 : DH0;

	assign Dout	=	(Op == 3'b100) ? {{16{DH[15]}}, DH}	: 
						(Op == 3'b011) ? {{16{1'b0}}, DH}	: 
						(Op == 3'b010) ? {{24{DB[7]}}, DB}	: 
						(Op == 3'b001) ? {{24{1'b0}}, DB}	: 
						Din;
endmodule
