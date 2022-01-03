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
	
	assign Out 	=	(Sel === 2'b01) ? In1 :
						(Sel === 2'b10) ? In2 :
						(Sel === 2'b11) ? In3 :
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
	
	assign Out 	=	(Sel === 3'b001) ? In1 :
						(Sel === 3'b010) ? In2 :
						(Sel === 3'b011) ? In3 :
						(Sel === 3'b100) ? In4 :
						(Sel === 3'b101) ? In5 :
						(Sel === 3'b110) ? In6 :
						(Sel === 3'b111) ? In7 :
						In0;

endmodule

module MUX_32_4(
	 input [31:0] In0,
	 input [31:0] In1,
	 input [31:0] In2,
	 input [31:0] In3,
	 input [31:0] In4,
	 input [31:0] In5,
	 input [31:0] In6,
	 input [31:0] In7,
	 input [31:0] In8,
	 input [31:0] In9,
	 input [31:0] In10,
	 input [31:0] In11,
	 input [31:0] In12,
	 input [31:0] In13,
	 input [31:0] In14,
	 input [31:0] In15,
	 input [3:0] Sel,
	 output [31:0] Out
    );
	
	assign Out 	=	(Sel === 4'b0001) ? In1 :
						(Sel === 4'b0010) ? In2 :
						(Sel === 4'b0011) ? In3 :
						(Sel === 4'b0100) ? In4 :
						(Sel === 4'b0101) ? In5 :
						(Sel === 4'b0110) ? In6 :
						(Sel === 4'b0111) ? In7 :
						(Sel === 4'b1000) ? In8 :
						(Sel === 4'b1001) ? In9 :
						(Sel === 4'b1010) ? In10 :
						(Sel === 4'b1011) ? In11 :
						(Sel === 4'b1100) ? In12 :
						(Sel === 4'b1101) ? In13 :
						(Sel === 4'b1110) ? In14 :
						(Sel === 4'b1111) ? In15 :
						In0;

endmodule

module MUX_32_1(
	 input [31:0] In0,
	 input [31:0] In1,
	 input Sel,
	 output [31:0] Out
    );
	
	assign Out = (Sel === 1'b1) ? In1 : In0;

endmodule

module MUX_5_2(
	 input [4:0] In0,
	 input [4:0] In1,
	 input [4:0] In2,
	 input [4:0] In3,
	 input [1:0] Sel,
	 output [4:0] Out
    );
	
	assign Out = 	(Sel === 2'b01) ? In1 :
						(Sel === 2'b10) ? In2 :
						(Sel === 2'b11) ? In3 :
						In0;

endmodule

module MUX_5_1(
	 input [4:0] In0,
	 input [4:0] In1,
	 input Sel,
	 output [4:0] Out
    );
	
	assign Out = (Sel === 1'b1) ? In1 : In0;

endmodule