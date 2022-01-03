`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:52:04 11/25/2021 
// Design Name: 
// Module Name:    CMP 
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
`define Beq		3'b000
`define Bne		3'b001
`define Blez	3'b010
`define Bgtz	3'b011
`define Bltz	3'b100
`define Bgez	3'b101
module CMP(
    input [31:0] A,
    input [31:0] B,
    input [2:0] CMPOp,
    output flag
    );

	assign flag = 	(CMPOp == `Beq) 	?	($signed(A) == $signed(B)) :
						(CMPOp == `Bne) 	?	($signed(A) != $signed(B)) :
						(CMPOp == `Blez)	?	($signed(A) <= $signed(32'b0)) :
						(CMPOp == `Bgtz)	?  ($signed(A) >  $signed(32'b0)) :
						(CMPOp == `Bltz)	?  ($signed(A) <  $signed(32'b0)) :
						(CMPOp == `Bgez)	?	($signed(A) >= $signed(32'b0)) :
						1'b0;
endmodule
