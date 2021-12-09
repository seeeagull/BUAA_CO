`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:54:12 11/25/2021 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUOp,
    output [31:0] C
    );

	assign C =	(ALUOp == 4'b0000) ? (A + B) :
					(ALUOp == 4'b0001) ? (A - B) :
					(ALUOp == 4'b0010) ? ($signed(A) + $signed(B)) :
					(ALUOp == 4'b0011) ? ($signed(A) - $signed(B)) :
					(ALUOp == 4'b0100) ? (A << B[4:0]) :
					(ALUOp == 4'b0101) ? (A >> B[4:0]) :
					(ALUOp == 4'b0111) ? $signed(($signed(A) >>> B[4:0])) :
					(ALUOp == 4'b1000) ? (A & B) :
					(ALUOp == 4'b1001) ? (A | B) :
					(ALUOp == 4'b1010) ? (A ^ B) :
					(ALUOp == 4'b1011) ? ~(A | B) :
					(ALUOp == 4'b1100) ? (A < B) :
					(ALUOp == 4'b1101) ? ($signed(A) < $signed(B)) :
					A;
endmodule
