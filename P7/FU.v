`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:09:38 11/27/2021 
// Design Name: 
// Module Name:    FU 
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
`define RFWD_PC0	3'b100
`define RFWD_HILO	3'b011
`define RFWD_PC4	3'b010
`define RFWD_DM	3'b001
`define RFWD_ALU	3'b000
module FU(
	 input [4:0] A1_D,
	 input [4:0] A2_D,
	 input [4:0] A1_E,
	 input [4:0] A2_E,
	 input [4:0] A2_M,	 
	 input [4:0] A3_M,
	 input [4:0] A3_W,
	 input [2:0] RFWD_M,
	 input [2:0] RFWD_W,
	 input RFWr_M,
	 input RFWr_W,
	 output [3:0] MFPCFSel,		// D
	 output [3:0] MFCMP1DSel,	// D
	 output [3:0] MFCMP2DSel,	// D
	 output [3:0] MFALUAESel,	// E
	 output [3:0] MFALUBESel,	// E
	 output [2:0] MFV2MSel,		// REGM(E)
	 output [2:0] MFWDMSel		// M
    );


	assign MFPCFSel	=	(A1_D != 5'b0) & (A1_D == A3_M) & (RFWD_M == `RFWD_HILO)	& RFWr_M ? 4'b1000 :
								(A1_D != 5'b0) & (A1_D == A3_M) & (RFWD_M == `RFWD_ALU)	& RFWr_M ? 4'b0111 :
								(A1_D != 5'b0) & (A1_D == A3_M) & (RFWD_M == `RFWD_PC4)	& RFWr_M ? 4'b0110 :
								(A1_D != 5'b0) & (A1_D == A3_W) & (RFWD_W == `RFWD_PC0) 	& RFWr_W ? 4'b0101 :
								(A1_D != 5'b0) & (A1_D == A3_W) & (RFWD_W == `RFWD_HILO)	& RFWr_W ? 4'b0100 :
								(A1_D != 5'b0) & (A1_D == A3_W) & (RFWD_W == `RFWD_ALU)	& RFWr_W ? 4'b0011 :
								(A1_D != 5'b0) & (A1_D == A3_W) & (RFWD_W == `RFWD_DM) 	& RFWr_W ? 4'b0010 :
								(A1_D != 5'b0) & (A1_D == A3_W) & (RFWD_W == `RFWD_PC4)	& RFWr_W ? 4'b0001 :
								4'b0000;
	assign MFCMP1DSel	=	(A1_D != 5'b0) & (A1_D == A3_M) & (RFWD_M == `RFWD_HILO)	& RFWr_M ? 4'b1000 :
								(A1_D != 5'b0) & (A1_D == A3_M) & (RFWD_M == `RFWD_ALU)	& RFWr_M ? 4'b0111 :
								(A1_D != 5'b0) & (A1_D == A3_M) & (RFWD_M == `RFWD_PC4)	& RFWr_M ? 4'b0110 :
								(A1_D != 5'b0) & (A1_D == A3_W) & (RFWD_W == `RFWD_PC0) 	& RFWr_W ? 4'b0101 :
								(A1_D != 5'b0) & (A1_D == A3_W) & (RFWD_W == `RFWD_HILO)	& RFWr_W ? 4'b0100 :
								(A1_D != 5'b0) & (A1_D == A3_W) & (RFWD_W == `RFWD_ALU)	& RFWr_W ? 4'b0011 :
								(A1_D != 5'b0) & (A1_D == A3_W) & (RFWD_W == `RFWD_DM) 	& RFWr_W ? 4'b0010 :
								(A1_D != 5'b0) & (A1_D == A3_W) & (RFWD_W == `RFWD_PC4)	& RFWr_W ? 4'b0001 :
								4'b0000;
	assign MFCMP2DSel	=	(A2_D != 5'b0) & (A2_D == A3_M) & (RFWD_M == `RFWD_HILO)	& RFWr_M ? 4'b1000 :
								(A2_D != 5'b0) & (A2_D == A3_M) & (RFWD_M == `RFWD_ALU)	& RFWr_M ? 4'b0111 :
								(A2_D != 5'b0) & (A2_D == A3_M) & (RFWD_M == `RFWD_PC4)	& RFWr_M ? 4'b0110 :
								(A2_D != 5'b0) & (A2_D == A3_W) & (RFWD_W == `RFWD_PC0) 	& RFWr_W ? 4'b0101 :
								(A2_D != 5'b0) & (A2_D == A3_W) & (RFWD_W == `RFWD_HILO)	& RFWr_W ? 4'b0100 :
								(A2_D != 5'b0) & (A2_D == A3_W) & (RFWD_W == `RFWD_ALU)	& RFWr_W ? 4'b0011 :
								(A2_D != 5'b0) & (A2_D == A3_W) & (RFWD_W == `RFWD_DM) 	& RFWr_W ? 4'b0010 :
								(A2_D != 5'b0) & (A2_D == A3_W) & (RFWD_W == `RFWD_PC4)	& RFWr_W ? 4'b0001 :
								4'b0000;
	assign MFALUAESel	=	(A1_E != 5'b0) & (A1_E == A3_M) & (RFWD_M == `RFWD_HILO)	& RFWr_M ? 4'b1000 :
								(A1_E != 5'b0) & (A1_E == A3_M) & (RFWD_M == `RFWD_ALU)	& RFWr_M ? 4'b0111 :
								(A1_E != 5'b0) & (A1_E == A3_M) & (RFWD_M == `RFWD_PC4)	& RFWr_M ? 4'b0110 :
								(A1_E != 5'b0) & (A1_E == A3_W) & (RFWD_W == `RFWD_PC0) 	& RFWr_W ? 4'b0101 :
								(A1_E != 5'b0) & (A1_E == A3_W) & (RFWD_W == `RFWD_HILO)	& RFWr_W ? 4'b0100 :
								(A1_E != 5'b0) & (A1_E == A3_W) & (RFWD_W == `RFWD_ALU)	& RFWr_W ? 4'b0011 :
								(A1_E != 5'b0) & (A1_E == A3_W) & (RFWD_W == `RFWD_DM) 	& RFWr_W ? 4'b0010 :
								(A1_E != 5'b0) & (A1_E == A3_W) & (RFWD_W == `RFWD_PC4)	& RFWr_W ? 4'b0001 :
								4'b0000;
	assign MFALUBESel	=	(A2_E != 5'b0) & (A2_E == A3_M) & (RFWD_M == `RFWD_HILO)	& RFWr_M ? 4'b1000 :
								(A2_E != 5'b0) & (A2_E == A3_M) & (RFWD_M == `RFWD_ALU)	& RFWr_M ? 4'b0111 :
								(A2_E != 5'b0) & (A2_E == A3_M) & (RFWD_M == `RFWD_PC4)	& RFWr_M ? 4'b0110 :
								(A2_E != 5'b0) & (A2_E == A3_W) & (RFWD_W == `RFWD_PC0) 	& RFWr_W ? 4'b0101 :
								(A2_E != 5'b0) & (A2_E == A3_W) & (RFWD_W == `RFWD_HILO)	& RFWr_W ? 4'b0100 :
								(A2_E != 5'b0) & (A2_E == A3_W) & (RFWD_W == `RFWD_ALU)	& RFWr_W ? 4'b0011 :
								(A2_E != 5'b0) & (A2_E == A3_W) & (RFWD_W == `RFWD_DM) 	& RFWr_W ? 4'b0010 :
								(A2_E != 5'b0) & (A2_E == A3_W) & (RFWD_W == `RFWD_PC4)	& RFWr_W ? 4'b0001 :
								4'b0000;
	assign MFV2MSel	=	(A2_E != 5'b0) & (A2_E == A3_W) & (RFWD_W == `RFWD_PC0)	& RFWr_W ? 3'b101 :
								(A2_E != 5'b0) & (A2_E == A3_W) & (RFWD_W == `RFWD_HILO)	& RFWr_W ? 3'b100 :
								(A2_E != 5'b0) & (A2_E == A3_W) & (RFWD_W == `RFWD_ALU)	& RFWr_W ? 3'b011 :
								(A2_E != 5'b0) & (A2_E == A3_W) & (RFWD_W == `RFWD_DM) 	& RFWr_W ? 3'b010 :
								(A2_E != 5'b0) & (A2_E == A3_W) & (RFWD_W == `RFWD_PC4)	& RFWr_W ? 3'b001 :
								3'b000;
	assign MFWDMSel	=	(A2_M != 5'b0) & (A2_M == A3_W) & (RFWD_W == `RFWD_PC0)	& RFWr_W ? 3'b101 :
								(A2_M != 5'b0) & (A2_M == A3_W) & (RFWD_W == `RFWD_HILO)	& RFWr_W ? 3'b100 :
								(A2_M != 5'b0) & (A2_M == A3_W) & (RFWD_W == `RFWD_ALU)	& RFWr_W ? 3'b011 :
								(A2_M != 5'b0) & (A2_M == A3_W) & (RFWD_W == `RFWD_DM) 	& RFWr_W ? 3'b010 :
								(A2_M != 5'b0) & (A2_M == A3_W) & (RFWD_W == `RFWD_PC4)	& RFWr_W ? 3'b001 :
								3'b000;
endmodule
