`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:45:39 12/13/2021 
// Design Name: 
// Module Name:    bridge 
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
module bridge(
    input [31:0] PrAddr,
	 input PrWE,
    input [31:0] PrWD,
	 input [31:0] Dev0Out,
	 input [31:0] Dev1Out,
	 input [31:0] DMOut,
    output [31:0] PrRD,
	 output DMWE,
	 output Dev0WE,
	 output Dev1WE
    );

	wire HitDev0, HitDev1, HitDM;
	
	assign HitDM	= (PrAddr >= 32'h0000_0000) && (PrAddr <= 32'h0000_2fff);
	assign HitDev0 = (PrAddr >= 32'h0000_7f00) && (PrAddr <= 32'h0000_7f0b);
	assign HitDev1 = (PrAddr >= 32'h0000_7f10) && (PrAddr <= 32'h0000_7f1b);
	
	assign PrRD 	=	HitDM		? DMOut		:
							HitDev0	? Dev0Out	:
							HitDev1	? Dev1Out	:
							0;
	assign DMWE		=	HitDM & PrWE;
	assign Dev0WE	=	HitDev0 & PrWE;
	assign Dev1WE	=	HitDev1 & PrWE;
	
endmodule
