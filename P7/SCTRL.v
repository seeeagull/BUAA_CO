`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:44:18 11/27/2021 
// Design Name: 
// Module Name:    SCTRL 
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
module SCTRL(
    input Stall,
	 output PC_NE,
	 output REGD_S,
	 output REGE_R
    );
	wire sflag;
	assign sflag	=	Stall;
	
	assign PC_NE	=	sflag ? 1'b1 : 1'b0;
	assign REGD_S	=	sflag ? 1'b1 : 1'b0;
	assign REGE_R	=	sflag ? 1'b1 : 1'b0;

endmodule
