`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:04:01 11/26/2021 
// Design Name: 
// Module Name:    MUX 
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
module MUX_32_2(
	 input [31:0] In0,
	 input [31:0] In1,
	 input [31:0] In2,
	 input [31:0] In3,
	 input [1:0] Sel,
	 output [31:0] Out
    );
	
	assign Out 	=	(Sel == 2'b00) ? In0 :
						(Sel == 2'b01) ? In1 :
						(Sel == 2'b10) ? In2 :
						(Sel == 2'b11) ? In3 :
						In0;

endmodule

module MUX_32_3(
	 input [31:0] In0,
	 input [31:0] In1,
	 input [31:0] In2,
	 input [31:0] In3,
	 input [31:0] In4,
	 input [31:0] In5,
	 input [31:0] In6,
	 input [31:0] In7,
	 input [2:0] Sel,
	 output [31:0] Out
    );
	
	assign Out 	=	(Sel == 3'b000) ? In0 :
						(Sel == 3'b001) ? In1 :
						(Sel == 3'b010) ? In2 :
						(Sel == 3'b011) ? In3 :
						(Sel == 3'b100) ? In4 :
						(Sel == 3'b101) ? In5 :
						(Sel == 3'b110) ? In6 :
						(Sel == 3'b111) ? In7 :
						In0;

endmodule

module MUX_32_1(
	 input [31:0] In0,
	 input [31:0] In1,
	 input Sel,
	 output [31:0] Out
    );
	
	assign Out = (Sel == 1'b0) ? In0 : In1;

endmodule

module MUX_5_2(
	 input [4:0] In0,
	 input [4:0] In1,
	 input [4:0] In2,
	 input [4:0] In3,
	 input [1:0] Sel,
	 output [4:0] Out
    );
	
	assign Out = 	(Sel == 2'b00) ? In0 :
						(Sel == 2'b01) ? In1 :
						(Sel == 2'b10) ? In2 :
						(Sel == 2'b11) ? In3 :
						In0;

endmodule