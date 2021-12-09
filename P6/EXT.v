`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:56:01 11/25/2021 
// Design Name: 
// Module Name:    EXT 
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
module EXT(
    input [15:0] DI,
    input [1:0] EXTOp,
    input [31:0] DO
    );

	assign DO = (EXTOp == 2'b00) ? ({{16{1'b0}}, DI}) :
					(EXTOp == 2'b01) ? ({{16{DI[15]}}, DI}) :
					(EXTOp == 2'b10) ? ({DI, {16{1'b0}}}) : 0;
endmodule
