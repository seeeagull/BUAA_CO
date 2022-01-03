`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:18:33 12/11/2021 
// Design Name: 
// Module Name:    PC0 
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
`define IM		SR[15:10]
`define EXL		SR[1]
`define IE		SR[0]
`define BD		Cause[31]
`define IP		Cause[15:10]
`define ExcCd	Cause[6:2]
module PC0(
    input [4:0] A1,
    input [4:0] A2,
    input [31:0] DIn,
    input [31:0] PC,
    input [6:2] ExcCode,
	 input bd,
    input [5:0] HWInt,
    input WE,
    input EXLClr,
    input clk,
    input rst,
    output Req,
    output [31:0] EPC,
    output [31:0] DOut,
	 output IntSig
    );
	 
	 reg [31:0] SR;
	 reg [31:0] Cause;
	 reg [31:0] EPCReg;
	 reg [31:0] PRId;
	 
	 wire ExcReq, IntReq;
	 
	 assign IntReq = (|(HWInt & `IM)) & (~`EXL) & `IE;		// interrupt
	 assign ExcReq = (|ExcCode) & (~`EXL);						// exception
	 assign Req		= IntReq | ExcReq; 
	 
	 assign IntSig = HWInt[2] & SR[12] & (~`EXL) & `IE;
	 
	 initial begin
		SR <= 32'b0;
		Cause <= 32'b0;
		PRId <= 32'h3f3f_3f3f;
		EPCReg <= 32'b0;
	 end
	 
	 always@(posedge clk) begin
		if(rst) begin
			SR <= 32'b0;
			Cause <= 32'b0;
			PRId <= 32'h3f3f_3f3f;
			EPCReg <= 32'b0;
		end
		else begin
			if(EXLClr) begin
				`EXL <= 1'b0;
			end
			if(Req) begin
				`EXL <= 1'b1;
				`ExcCd <= IntReq ? 5'b0 : ExcCode;
				`BD <= bd;
				EPCReg <= bd ? (PC[31:0] - 4'b0100) : PC[31:0];
			end
			else if(WE) begin
				if(A2[4:0] == 5'd12)			SR <= DIn;
				else if(A2[4:0] == 5'd14)	EPCReg <= DIn;
			end
			`IP <= HWInt;
		end
	 end
	
	 assign EPC	=	Req ? (bd ? (PC[31:0] - 4'b0100) : PC[31:0]) : EPCReg;
	 assign DOut = (A1[4:0] == 5'd12) ? SR :
						(A1[4:0] == 5'd13) ? Cause :
						(A1[4:0] == 5'd14) ? EPC :
						(A1[4:0] == 5'd15) ? PRId :
						32'b0;
	 
endmodule
