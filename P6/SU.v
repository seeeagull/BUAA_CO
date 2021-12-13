`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:14:01 11/27/2021 
// Design Name: 
// Module Name:    SU 
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
module SU(
	 input [15:0] Op,
	 input [1:0] Tnew_E,
	 input [1:0] Tnew_M,
	 input [4:0] A1_D,
	 input [4:0] A2_D,
	 input [4:0] A3_E,
	 input [4:0] A3_M,
	 input RFWr_E,
	 input RFWr_M,
	 input HILO,
	 input HILO_Busy,
	 output Stall,
	 output [1:0] Tnew
    );

	wire	hl, mf, mt, alur, alui, shift, shiftv, set, seti, load, store, branch, j, jal, jr, jalr;
	wire	Tuse_RS0, Tuse_RS1, Tuse_RT0, Tuse_RT1, Tuse_RT2;
	wire	Stall_RS0_E1, Stall_RS0_E2, Stall_RS1_E2, Stall_RS0_M1,
			Stall_RT0_E1, Stall_RT0_E2, Stall_RT1_E2, Stall_RT0_M1,
			Stall_RS, Stall_RT, Stall_HILO;
	
	assign hl		= Op[15];
	assign mf		= Op[14];
	assign mt		= Op[13];
	assign alur		= Op[12];
	assign alui		= Op[11];
	assign shift	= Op[10];
	assign shiftv	= Op[9];
	assign set		= Op[8];
	assign seti		= Op[7];
	assign load		= Op[6];
	assign store	= Op[5];
	assign branch	= Op[4];
	assign j			= Op[3];
	assign jal		= Op[2];
	assign jr		= Op[1];
	assign jalr		= Op[0];
	
	// hazard solving
	assign Tuse_RS0	=	branch | jr | jalr;
	assign Tuse_RS1	=	hl | mt | alur | alui | shiftv | set | seti | load | store;
	assign Tuse_RT0	=	branch;
	assign Tuse_RT1	=	hl | alur | shift | shiftv | set;
	assign Tuse_RT2	=	store;
	
	assign Stall_RS0_E1	=	Tuse_RS0 & (Tnew_E == 2'b01) & (A1_D != 5'b0) & (A1_D == A3_E) & RFWr_E;
	assign Stall_RS0_E2	=	Tuse_RS0 & (Tnew_E == 2'b10) & (A1_D != 5'b0) & (A1_D == A3_E) & RFWr_E;
	assign Stall_RS1_E2	=	Tuse_RS1 & (Tnew_E == 2'b10) & (A1_D != 5'b0) & (A1_D == A3_E) & RFWr_E;
	assign Stall_RS0_M1	=	Tuse_RS0 & (Tnew_M == 2'b01) & (A1_D != 5'b0) & (A1_D == A3_M) & RFWr_M;
	assign Stall_RS 		=	Stall_RS0_E1 | Stall_RS0_E2 | Stall_RS1_E2 | Stall_RS0_M1;
	
	assign Stall_RT0_E1	=	Tuse_RT0 & (Tnew_E == 2'b01) & (A2_D != 5'b0) & (A2_D == A3_E) & RFWr_E;
	assign Stall_RT0_E2	=	Tuse_RT0 & (Tnew_E == 2'b10) & (A2_D != 5'b0) & (A2_D == A3_E) & RFWr_E;
	assign Stall_RT1_E2	=	Tuse_RT1 & (Tnew_E == 2'b10) & (A2_D != 5'b0) & (A2_D == A3_E) & RFWr_E;
	assign Stall_RT0_M1	=	Tuse_RT0 & (Tnew_M == 2'b01) & (A2_D != 5'b0) & (A2_D == A3_M) & RFWr_M;
	assign Stall_RT 		=	Stall_RT0_E1 | Stall_RT0_E2 | Stall_RT1_E2 | Stall_RT0_M1;
	
	assign Stall_HILO		=	HILO & HILO_Busy;
	
	assign Stall 			=	Stall_RS | Stall_RT | Stall_HILO; 
	
	assign Tnew			=	{load, alur | alui | shift | shiftv | set | seti | mf};
	
endmodule
