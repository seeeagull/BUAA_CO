`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:48:28 11/25/2021 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset,
	 input [31:0] i_inst_rdata,	// IM.Instr
	 input [31:0] m_data_rdata,	// DM.D
	 output [31:0] i_inst_addr,	// IM.A
	 output [31:0] m_data_addr,	// DM.A
	 output [31:0] m_data_wdata,	// DM.WD
	 output [3:0] m_data_byteen,	// DM.DMWr
	 output [31:0] m_inst_addr,	// DM.PC
	 output w_grf_we,					// RF.RFWr
	 output [4:0] w_grf_addr,		// RF.A3
	 output [31:0] w_grf_wdata,	// RF.WD
	 output [31:0] w_inst_addr		// RF.PC
    );
	
	
	// datapath
	////////////////stage F////////////////
	MUX_32_3 MFPCF(
		.In0(RF.RD1),
		.In1(REGW.PC8_W_O),
		.In2(REGW.DR_W_O),
		.In3(REGW.AO_W_O),
		.In4(REGW.HILO_W_O),
		.In5(REGM.PC8_M_O),
		.In6(REGM.AO_M_O),
		.In7(REGM.HILO_M_O),
		.Sel(FU.MFPCFSel)
	);
	MUX_32_2 MPC(
		.In0(ADD4.DO),
		.In1(NPC.Npc),
		.In2(MFPCF.Out),
		.Sel(CU.MPCOp)
	);
	PC PC(
		.clk(clk),
		.reset(reset),
		.ne(SCTRL.PC_NE),
		.DI(MPC.Out)
	);
	
	assign i_inst_addr = PC.DO;
	
	ADD4 ADD4(
		.DI(PC.DO)
	);
	////////////////stage D////////////////
	REGD REGD(
		.clk(clk),
		.clr(reset | SCTRL.REGD_R),
		.stall(SCTRL.REGD_S),
		.IR_D_I(i_inst_rdata),
		.PC4_D_I(ADD4.DO),
		.PC8_D_I(ADD4.DO + 32'b0100)
	);
	GRF RF(
		.clk(clk),
		.reset(reset),
		.A1(REGD.IR_D_O[25:21]),
		.A2(REGD.IR_D_O[20:16]),
		.RFWr(REGW.RFWr_W_O),
		.A3(REGW.A3_W_O),
		.WD(MRFWD.Out),
		.PC(REGW.PC4_W_O - 32'b0100)
	);
	assign w_grf_we = REGW.RFWr_W_O;
	assign w_grf_addr = REGW.A3_W_O;
	assign w_grf_wdata = MRFWD.Out;
	assign w_inst_addr = REGW.PC4_W_O - 32'b0100;
	
	EXT EXT(
		.DI(REGD.IR_D_O[15:0]),
		.EXTOp(CU.EXTOp)
	);
	NPC NPC(
		.Pc(REGD.PC4_D_O - 32'b0100),
		.NPCOp(CU.NPCOp),
		.I26(REGD.IR_D_O[25:0])
	);
	MUX_32_3 MFCMP1D(
		.In0(RF.RD1),
		.In1(REGW.PC8_W_O),
		.In2(REGW.DR_W_O),
		.In3(REGW.AO_W_O),
		.In4(REGW.HILO_W_O),
		.In5(REGM.PC8_M_O),
		.In6(REGM.AO_M_O),
		.In7(REGM.HILO_M_O),
		.Sel(FU.MFCMP1DSel)
	);
	MUX_32_3 MFCMP2D(
		.In0(RF.RD2),
		.In1(REGW.PC8_W_O),
		.In2(REGW.DR_W_O),
		.In3(REGW.AO_W_O),
		.In4(REGW.HILO_W_O),
		.In5(REGM.PC8_M_O),
		.In6(REGM.AO_M_O),
		.In7(REGM.HILO_M_O),
		.Sel(FU.MFCMP2DSel)
	);
	CMP CMP(
		.A(MFCMP1D.Out),
		.B(MFCMP2D.Out),
		.CMPOp(CU.CMPOp)
	);
	MUX_5_2 MA3E(
		.In0(REGD.IR_D_O[20:16]),
		.In1(REGD.IR_D_O[15:11]),
		.In2(5'b11111),
		.Sel(CU.MA3EOp)
	);
	////////////////stage E////////////////
	REGE REGE(
		.clk(clk),
		.clr(reset | SCTRL.REGE_R),
		.V1_E_I(MFCMP1D.Out),
		.V2_E_I(MFCMP2D.Out),
		.A1_E_I(REGD.IR_D_O[25:21]),
		.A2_E_I(REGD.IR_D_O[20:16]),
		.A3_E_I(MA3E.Out),
		.E32_E_I(EXT.DO),
		.PC4_E_I(REGD.PC4_D_O),
		.PC8_E_I(REGD.PC8_D_O),
		.RFWD_E_I(CU.RFWD),
		.RFWr_E_I(CU.RFWr),
		.DMWr_E_I(CU.DMWr),
		.DMEXTOp_E_I(CU.DMEXTOp),
		.ALUOp_E_I(CU.ALUOp),
		.ASel_E_I(CU.ASel),
		.BSel_E_I(CU.BSel),
		.HILOOp_E_I(CU.HILOOp),
		.MRFWDOp_E_I(CU.MRFWDOp),
		.Tnew_E_I(SU.Tnew)
	);
	MUX_32_3 MFALUAE(
		.In0(REGE.V1_E_O),
		.In1(REGW.PC8_W_O),
		.In2(REGW.DR_W_O),
		.In3(REGW.AO_W_O),
		.In4(REGW.HILO_W_O),
		.In5(REGM.PC8_M_O),
		.In6(REGM.AO_M_O),
		.In7(REGM.HILO_M_O),
		.Sel(FU.MFALUAESel)
	);
	MUX_32_3 MFALUBE(
		.In0(REGE.V2_E_O),
		.In1(REGW.PC8_W_O),
		.In2(REGW.DR_W_O),
		.In3(REGW.AO_W_O),
		.In4(REGW.HILO_W_O),
		.In5(REGM.PC8_M_O),
		.In6(REGM.AO_M_O),
		.In7(REGM.HILO_M_O),
		.Sel(FU.MFALUBESel)
	);
	MUX_32_1 MALUA(
		.In0(MFALUAE.Out),
		.In1(MFALUBE.Out),
		.Sel(REGE.ASel_E_O)
	);
	MUX_32_2 MALUB(
		.In0(MFALUBE.Out),
		.In1(REGE.E32_E_O),
		.In2(MFALUAE.Out),
		.In3({{27{1'b0}},REGE.E32_E_O[10:6]}),
		.Sel(REGE.BSel_E_O)
	);
	ALU ALU(
		.A(MALUA.Out),
		.B(MALUB.Out),
		.ALUOp(REGE.ALUOp_E_O)
	);
	HILO HILO(
		.clk(clk),
		.reset(reset),
		.D1(MFALUAE.Out),
		.D2(MFALUBE.Out),
		.HILOOp(REGE.HILOOp_E_O)
	);
	MUX_32_3 MFV2M(
		.In0(REGE.V2_E_O),
		.In1(REGW.PC8_W_O),
		.In2(REGW.DR_W_O),
		.In3(REGW.AO_W_O),
		.In4(REGW.HILO_W_O),
		.Sel(FU.MFV2MSel)
	);
	////////////////stage M////////////////
	REGM REGM(
		.clk(clk),
		.clr(reset),
		.V2_M_I(MFV2M.Out),
		.A2_M_I(REGE.A2_E_O),
		.AO_M_I(ALU.C),
		.HILO_M_I(HILO.DO),
		.A3_M_I(REGE.A3_E_O),
		.PC4_M_I(REGE.PC4_E_O),
		.PC8_M_I(REGE.PC8_E_O),
		.RFWD_M_I(REGE.RFWD_E_O),
		.RFWr_M_I(REGE.RFWr_E_O),
		.DMWr_M_I(REGE.DMWr_E_O),
		.DMEXTOp_M_I(REGE.DMEXTOp_E_O),
		.MRFWDOp_M_I(REGE.MRFWDOp_E_O),
		.Tnew_M_I(REGE.Tnew_E_O)
	);
	MUX_32_3 MFWDM(
		.In0(REGM.V2_M_O),
		.In1(REGW.PC8_W_O),
		.In2(REGW.DR_W_O),
		.In3(REGW.AO_W_O),
		.In4(REGW.HILO_W_O),
		.Sel(FU.MFWDMSel)
	);
	
	assign m_data_addr = REGM.AO_M_O;
	assign m_data_wdata = 	(REGM.DMWr_M_O == 2'b11) ? MFWDM.Out :
									(REGM.DMWr_M_O == 2'b10) ? {MFWDM.Out[15:0], MFWDM.Out[15:0]} :
									(REGM.DMWr_M_O == 2'b01) ? {MFWDM.Out[7:0], MFWDM.Out[7:0], MFWDM.Out[7:0], MFWDM.Out[7:0]} :
									MFWDM.Out;
	assign m_data_byteen = {(((REGM.DMWr_M_O == 2'b01) & (REGM.AO_M_O[1:0] == 2'b11)) | ((REGM.DMWr_M_O == 2'b10) & (REGM.AO_M_O[1] == 1'b1)) | (REGM.DMWr_M_O == 2'b11)),
									(((REGM.DMWr_M_O == 2'b01) & (REGM.AO_M_O[1:0] == 2'b10)) | ((REGM.DMWr_M_O == 2'b10) & (REGM.AO_M_O[1] == 1'b1)) | (REGM.DMWr_M_O == 2'b11)),
									(((REGM.DMWr_M_O == 2'b01) & (REGM.AO_M_O[1:0] == 2'b01)) | ((REGM.DMWr_M_O == 2'b10) & (REGM.AO_M_O[1] == 1'b0)) | (REGM.DMWr_M_O == 2'b11)),
									(((REGM.DMWr_M_O == 2'b01) & (REGM.AO_M_O[1:0] == 2'b00)) | ((REGM.DMWr_M_O == 2'b10) & (REGM.AO_M_O[1] == 1'b0)) | (REGM.DMWr_M_O == 2'b11))};
	assign m_inst_addr = REGM.PC4_M_O - 32'b0100;
	DMEXT DMEXT(
		 .A(REGM.AO_M_O[1:0]),
		 .Din(m_data_rdata),
		 .Op(REGM.DMEXTOp_M_O)
	);
	////////////////stage W////////////////
	REGW REGW(
		.clk(clk),
		.clr(reset),
		.A3_W_I(REGM.A3_M_O),
		.PC4_W_I(REGM.PC4_M_O),
		.PC8_W_I(REGM.PC8_M_O),
		.AO_W_I(REGM.AO_M_O),
		.HILO_W_I(REGM.HILO_M_O),
		.DR_W_I(DMEXT.Dout),
		.RFWD_W_I(REGM.RFWD_M_O),
		.RFWr_W_I(REGM.RFWr_M_O),
		.MRFWDOp_W_I(REGM.MRFWDOp_M_O)
	);
	MUX_32_2 MRFWD(
		.In0(REGW.AO_W_O),
		.In1(REGW.DR_W_O),
		.In2(REGW.PC8_W_O),
		.In3(REGW.HILO_W_O),
		.Sel(REGW.MRFWDOp_W_O)
	);
	
	
	// control
	CU CU(
		.Instr(REGD.IR_D_O),
		.Cmp(CMP.flag)
	);
	FU FU(
		 .A1_D(REGD.IR_D_O[25:21]),
		 .A2_D(REGD.IR_D_O[20:16]),
		 .A1_E(REGE.A1_E_O),
		 .A2_E(REGE.A2_E_O),
		 .A2_M(REGM.A2_M_O),	 
		 .A3_M(REGM.A3_M_O),
		 .A3_W(REGW.A3_W_O),
		 .RFWD_M(REGM.RFWD_M_O),
		 .RFWD_W(REGW.RFWD_W_O),
		 .RFWr_M(REGM.RFWr_M_O),
		 .RFWr_W(REGW.RFWr_W_O)
	);
	SU SU(
		.Op(CU.Op),
		.Tnew_E(REGE.Tnew_E_O),
		.Tnew_M(REGM.Tnew_M_O),
		.A1_D(REGD.IR_D_O[25:21]),
		.A2_D(REGD.IR_D_O[20:16]),
		.A3_E(REGE.A3_E_O),
		.A3_M(REGM.A3_M_O),
		.RFWr_E(REGE.RFWr_E_O),
		.RFWr_M(REGM.RFWr_M_O),
		.HILO(CU.hilo),
		.HILO_Busy(HILO.Busy)
	);
	SCTRL SCTRL(
		.Stall(SU.Stall)
	);
endmodule
