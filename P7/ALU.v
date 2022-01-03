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
	 input [7:0] ls,
	 input [2:0] as,
    output [31:0] C,
	 output [1:0] ExcMSel
    );
	wire overflow, AdEL, AdES;
	wire [32:0] C33;
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
	
	assign C33 = 	(as[2] | as[1] | (|ls)) ? ($signed({A[31], A}) + $signed({B[31], B})) :
						as[0] ? ($signed({A[31], A}) - $signed({B[31], B})) :
						33'b0;
	assign overflow = (|{ls, as}) & (C33[32] != C33[31]);
	// ls = {lb, lbu, lh, lhu, lw, sb, sh, sw}
	assign AdEL		=	(ls[3] & (C[1:0] != 2'b00)) |
							((ls[4] | ls[5]) & (C[0] != 1'b0)) |
							((ls[7] | ls[6] | ls[5] | ls[4]) & ((C >= 32'h7f00 & C <= 32'h7f0b) | (C >= 32'h7f10 & C <= 32'h7f1b))) |
							((ls[7] | ls[6] | ls[5] | ls[4] | ls[3]) & overflow) |
							((ls[7] | ls[6] | ls[5] | ls[4] | ls[3]) & !((C >= 32'h0000 & C <= 32'h2fff) | (C >= 32'h7f00 & C <= 32'h7f0b) | (C >= 32'h7f10 & C <= 32'h7f1b)));
	assign AdES		=	(ls[0] & (C[1:0] != 2'b00)) |
							(ls[1] & (C[0] != 1'b0)) |
							((ls[2] | ls[1]) & ((C >= 32'h7f00 & C <= 32'h7f0b) | (C >= 32'h7f10 & C <= 32'h7f1b))) |
							((ls[2] | ls[1] | ls[0]) & overflow) |
							((ls[2] | ls[1] | ls[0]) & ((C >= 32'h7f08 & C <= 32'h7f0b) | (C >= 32'h7f18 & C <= 32'h7f1b))) |
							((ls[2] | ls[1] | ls[0]) & !((C >= 32'h0000 & C <= 32'h2fff) | (C >= 32'h7f00 & C <= 32'h7f0b) | (C >= 32'h7f10 & C <= 32'h7f1b)));
	assign ExcMSel =	AdEL ? 2'b01 :
							AdES ? 2'b10 :
							overflow ? 2'b11 :
							2'b00;
endmodule
