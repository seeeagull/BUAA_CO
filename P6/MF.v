`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:01:44 11/25/2021 
// Design Name: 
// Module Name:    FREG
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
module REGD(
	 input clk,
	 input clr,
	 input stall,
	 input [31:0] IR_D_I,
	 input [31:0] PC4_D_I,
	 input [31:0] PC8_D_I,
	 output reg [31:0] IR_D_O,
	 output reg [31:0] PC4_D_O,
	 output reg [31:0] PC8_D_O
    );
	initial begin
		IR_D_O <= 0;
		PC4_D_O <= 0;
		PC8_D_O <= 0;
	end
	always @(posedge clk) begin
		if(clr) begin
			IR_D_O <= 0;
			PC4_D_O <= 0;
			PC8_D_O <= 0;
		end
		else if(!stall)begin
			IR_D_O <= IR_D_I;
			PC4_D_O <= PC4_D_I;
			PC8_D_O <= PC8_D_I;
		end
		else begin
			IR_D_O <= IR_D_O;
			PC4_D_O <= PC4_D_O;
			PC8_D_O <= PC8_D_O;
		end
	end
	
endmodule

module REGE(
	 input clk,
	 input clr,
	 input [31:0] V1_E_I,
	 input [31:0] V2_E_I,
	 input [4:0] A1_E_I,
	 input [4:0] A2_E_I,
	 input [4:0] A3_E_I,
	 input [31:0] E32_E_I,
	 input [31:0] PC4_E_I,
	 input [31:0] PC8_E_I,
	 input [1:0] RFWD_E_I,
	 input RFWr_E_I,
	 input [1:0] DMWr_E_I,
	 input [2:0] DMEXTOp_E_I,
	 input [3:0] ALUOp_E_I,
	 input ASel_E_I,
	 input [1:0] BSel_E_I,
	 input [3:0] HILOOp_E_I,
	 input [1:0] MRFWDOp_E_I,
	 input [1:0] Tnew_E_I,
	 output reg [31:0] V1_E_O,
	 output reg [31:0] V2_E_O,
	 output reg [4:0] A1_E_O,
	 output reg [4:0] A2_E_O,
	 output reg [4:0] A3_E_O,
	 output reg [31:0] E32_E_O,
	 output reg [31:0] PC4_E_O,
	 output reg [31:0] PC8_E_O,
	 output reg [1:0] RFWD_E_O,
	 output reg RFWr_E_O,
	 output reg [1:0] DMWr_E_O,
	 output reg [2:0] DMEXTOp_E_O,
	 output reg [3:0] ALUOp_E_O,
	 output reg ASel_E_O,
	 output reg [1:0] BSel_E_O,
	 output reg [3:0] HILOOp_E_O,
	 output reg [1:0] MRFWDOp_E_O,
	 output reg [1:0] Tnew_E_O
    );

	initial begin
		V1_E_O <= 0;
		V2_E_O <= 0;
		A1_E_O <= 0;
		A2_E_O <= 0;
		A3_E_O <= 0;
		E32_E_O <= 0;
		PC4_E_O <= 0;
		PC8_E_O <= 0;
		RFWD_E_O <= 0;
		RFWr_E_O <= 0;
		DMWr_E_O <= 0;
		DMEXTOp_E_O <= 0;
		ALUOp_E_O <= 0;
		ASel_E_O <= 0;
		BSel_E_O <= 0;
		HILOOp_E_O <= 0;
		MRFWDOp_E_O <= 0;
		Tnew_E_O <= 0;
	end
	
	always @(posedge clk) begin
		if(clr) begin
			V1_E_O <= 0;
			V2_E_O <= 0;
			A1_E_O <= 0;
			A2_E_O <= 0;
			A3_E_O <= 0;
			E32_E_O <= 0;
			PC4_E_O <= 0;
			PC8_E_O <= 0;
			RFWD_E_O <= 0;
			RFWr_E_O <= 0;
			DMWr_E_O <= 0;
			DMEXTOp_E_O <= 0;
			ALUOp_E_O <= 0;
			ASel_E_O <= 0;
			BSel_E_O <= 0;
			HILOOp_E_O <= 0;
			MRFWDOp_E_O <= 0;
			Tnew_E_O <= 0;
		end
		else begin
			V1_E_O <= V1_E_I;
			V2_E_O <= V2_E_I;
			A1_E_O <= A1_E_I;
			A2_E_O <= A2_E_I;
			A3_E_O <= A3_E_I;
			E32_E_O <= E32_E_I;
			PC4_E_O <= PC4_E_I;
			PC8_E_O <= PC8_E_I;
			RFWD_E_O <= RFWD_E_I;
			RFWr_E_O <= RFWr_E_I;
			DMWr_E_O <= DMWr_E_I;
			DMEXTOp_E_O <= DMEXTOp_E_I;
			ALUOp_E_O <= ALUOp_E_I;
			ASel_E_O <= ASel_E_I;
			BSel_E_O <= BSel_E_I;
			HILOOp_E_O <= HILOOp_E_I;
			MRFWDOp_E_O <= MRFWDOp_E_I;
			Tnew_E_O <= Tnew_E_I;
		end
	end

endmodule

module REGM(
	 input clk,
	 input clr,
	 input [31:0] V2_M_I,
	 input [4:0] A2_M_I,
	 input [31:0] AO_M_I,
	 input [31:0] HILO_M_I,
	 input [4:0] A3_M_I,
	 input [31:0] PC4_M_I,
	 input [31:0] PC8_M_I,
	 input [1:0] RFWD_M_I,
	 input RFWr_M_I,
	 input [1:0] DMWr_M_I,
	 input [2:0] DMEXTOp_M_I,
	 input [1:0] MRFWDOp_M_I,
	 input [1:0] Tnew_M_I,
	 output reg [31:0] V2_M_O,
	 output reg [4:0] A2_M_O,
	 output reg [31:0] AO_M_O,
	 output reg [31:0] HILO_M_O,
	 output reg [4:0] A3_M_O,
	 output reg [31:0] PC4_M_O,
	 output reg [31:0] PC8_M_O,
	 output reg [1:0] RFWD_M_O,
	 output reg RFWr_M_O,
	 output reg [1:0] DMWr_M_O,
	 output reg [2:0] DMEXTOp_M_O,
	 output reg [1:0] MRFWDOp_M_O,
	 output reg [1:0] Tnew_M_O
    );
	 
	initial begin
		V2_M_O <= 0;
		A2_M_O <= 0;
		AO_M_O <= 0;
		HILO_M_O <= 0;
		A3_M_O <= 0;
		PC4_M_O <= 0;
		PC8_M_O <= 0;
		RFWD_M_O <= 0;
		RFWr_M_O <= 0;
		DMWr_M_O <= 0;
		DMEXTOp_M_O <= 0;
		MRFWDOp_M_O <= 0;
		Tnew_M_O <= 0;
	end
	always @(posedge clk) begin
		if(clr) begin
			V2_M_O <= 0;
			A2_M_O <= 0;
			AO_M_O <= 0;
			HILO_M_O <= 0;
			A3_M_O <= 0;
			PC4_M_O <= 0;
			PC8_M_O <= 0;
			RFWD_M_O <= 0;
			RFWr_M_O <= 0;
			DMWr_M_O <= 0;
			DMEXTOp_M_O <= 0;
			MRFWDOp_M_O <= 0;
			Tnew_M_O <= 0;
		end
		else begin
			V2_M_O <= V2_M_I;
			A2_M_O <= A2_M_I;
			AO_M_O <= AO_M_I;
			HILO_M_O <= HILO_M_I;
			A3_M_O <= A3_M_I;
			PC4_M_O <= PC4_M_I;
			PC8_M_O <= PC8_M_I;
			RFWD_M_O <= RFWD_M_I;
			RFWr_M_O <= RFWr_M_I;
			DMWr_M_O <= DMWr_M_I;
			DMEXTOp_M_O <= DMEXTOp_M_I;
			MRFWDOp_M_O <= MRFWDOp_M_I;
			if(Tnew_M_I >= 2'b01) begin
				Tnew_M_O <= Tnew_M_I - 2'b01;
			end
			else begin
				Tnew_M_O <= Tnew_M_I;
			end
		end
	end
	
endmodule

module REGW(
	 input clk,
	 input clr,
	 input [4:0] A3_W_I,
	 input [31:0] PC4_W_I,
	 input [31:0] PC8_W_I,
	 input [31:0] AO_W_I,
	 input [31:0] HILO_W_I,
	 input [31:0] DR_W_I,
	 input [1:0] RFWD_W_I,
	 input RFWr_W_I,
	 input [1:0] MRFWDOp_W_I,
	 output reg [4:0] A3_W_O,
	 output reg [31:0] PC4_W_O,
	 output reg [31:0] PC8_W_O,
	 output reg [31:0] AO_W_O,
	 output reg [31:0] HILO_W_O,
	 output reg [31:0] DR_W_O,
	 output reg [1:0] RFWD_W_O,
	 output reg RFWr_W_O,
	 output reg [1:0] MRFWDOp_W_O
    );
	
	initial begin
		A3_W_O <= 0;
		PC4_W_O <= 0;
		PC8_W_O <= 0;
		AO_W_O <= 0;
		HILO_W_O <= 0;
		DR_W_O <= 0;
		RFWD_W_O <= 0;
		RFWr_W_O <= 0;
		MRFWDOp_W_O <= 0;
	end
	
	always @(posedge clk) begin
		if(clr) begin
			A3_W_O <= 0;
			PC4_W_O <= 0;
			PC8_W_O <= 0;
			AO_W_O <= 0;
			HILO_W_O <= 0;
			DR_W_O <= 0;
			RFWD_W_O <= 0;
			RFWr_W_O <= 0;
			MRFWDOp_W_O <= 0;
		end
		else begin
			A3_W_O <= A3_W_I;
			PC4_W_O <= PC4_W_I;
			PC8_W_O <= PC8_W_I;
			AO_W_O <= AO_W_I;
			HILO_W_O <= HILO_W_I;
			DR_W_O <= DR_W_I;
			RFWD_W_O <= RFWD_W_I;
			RFWr_W_O <= RFWr_W_I;
			MRFWDOp_W_O <= MRFWDOp_W_I;
		end
	end

endmodule