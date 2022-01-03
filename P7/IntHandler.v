`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:50:29 12/14/2021 
// Design Name: 
// Module Name:    IntHandler 
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
module IntHandler(
	 input clk,
    input interrupt,
    output WE
    );
	 
	reg wereg;
	
	initial begin
		wereg <= 1'b0;
	end
	always@(posedge clk) begin
		wereg	<= interrupt;
	end
	assign WE = wereg;
endmodule
