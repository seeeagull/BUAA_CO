`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:36:17 11/16/2021 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
    input clk,
    input reset,
    input RFWr,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD,
	 input [31:0] PC,
    output [31:0] RD1,
    output [31:0] RD2
    );
	reg [31:0] mem[31:0];
	integer i;
	initial begin
		for(i = 0; i <= 31; i = i + 1) begin
			mem[i] <= 0;
		end
	end
	
	always @(posedge clk) begin
		if(reset) begin
			for(i = 0; i <= 31; i = i + 1) begin
				mem[i] <= 0;
			end
		end
		else if(RFWr)begin
			if(|A3) begin
				mem[A3] <= WD;
			end
		end
	end
	
	assign RD1 = mem[A1[4:0]];
	assign RD2 = mem[A2[4:0]];

endmodule
