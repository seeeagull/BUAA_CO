`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:15:05 12/03/2021 
// Design Name: 
// Module Name:    HILO
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
`define MULT	4'b0010
`define MULTU	4'b0011
`define DIV		4'b0100
`define DIVU	4'b0101
`define MFHI	4'b0110
`define MFLO	4'b0111
`define MTHI	4'b1000
`define MTLO	4'b1001
module HILO(
	 input clk,
	 input reset,
    input [31:0] D1,
    input [31:0] D2,
	 input [3:0] HILOOp,
    output [31:0] DO,
    output Busy
    );
	
	wire mult, multu, div, divu, mfhi, mflo, mthi, mtlo;
	wire start;
	reg [31:0] HI, LO, HI_tmp, LO_tmp;
	reg [3:0] during;
	reg busy;
	
	assign mult	=	(HILOOp == `MULT);
	assign multu=	(HILOOp == `MULTU);
	assign div	=	(HILOOp == `DIV);
	assign divu	=	(HILOOp == `DIVU);
	assign mfhi	=	(HILOOp == `MFHI);
	assign mflo	=	(HILOOp == `MFLO);
	assign mthi	=	(HILOOp == `MTHI);
	assign mtlo	=	(HILOOp == `MTLO);
	
	assign start=	mult | multu | div | divu;
	
	initial begin
		HI <= 0;
		LO <= 0;
		HI_tmp <= 0;
		LO_tmp <= 0;
		during <= 0;
		busy <= 0;
	end
	
	always @(posedge clk) begin
		if(reset) begin
			HI <= 0;
			LO <= 0;
			HI_tmp <= 0;
			LO_tmp <= 0;
			during <= 0;
			busy <= 0;
		end
		else begin
			if(during == 0) begin
				if(mtlo) begin
					LO <= D1;
				end
				else if(mthi) begin
					HI <= D1;
				end
				else if(mult) begin
					{HI_tmp, LO_tmp} <= $signed(D1) * $signed(D2);
					during <= 5;
					busy <= 1;
				end
				else if(multu) begin
					{HI_tmp, LO_tmp} <= D1 * D2;
					during <= 5;
					busy <= 1;
				end
				else if(div) begin
					LO_tmp <= $signed(D1) / $signed(D2);
					HI_tmp <= $signed(D1) % $signed(D2);
					during <= 10;
					busy <= 1;
				end
				else if(divu) begin
					LO_tmp <= D1 / D2;
					HI_tmp <= D1 % D2;
					during <= 10;
					busy <= 1;
				end
			end
			else if(during == 1) begin
				during <= during - 1;
				busy <= 0;
				HI <= HI_tmp;
				LO <= LO_tmp;
			end
			else begin
				during <= during - 1;
			end
		end
	end
	
	assign Busy = busy | start;
	assign DO = mfhi ? HI :
					mflo ? LO :
					32'b0;

endmodule
