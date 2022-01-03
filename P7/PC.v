`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:18:56 11/15/2021 
// Design Name: 
// Module Name:    PC 
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
module PC(
    input clk,
    input reset,
	 input ne,
	 input req,
    input [31:0] DI,
    output [31:0] DO
    );
	reg [31:0] mem;
	initial begin
		mem = 32'h0000_3000;
	end
	
	always @(posedge clk) begin
		if(reset) begin
			mem <= 32'h0000_3000;
		end
		else if(req == 1'b1) begin
			mem <= 32'h0000_4180;
		end
		else if(ne == 1'b1)begin
			mem <= mem;
		end
		else begin
			mem <= DI;
		end
	end
	
	assign DO = mem;
	
endmodule
