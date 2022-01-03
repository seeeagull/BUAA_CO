`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:35:33 12/13/2021 
// Design Name: 
// Module Name:    CPU 
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
module CPU(
    input clk,
    input reset,
	 input interrupt,
	 output [31:0] macroscopic_pc,
	 
	 input [31:0] i_inst_rdata,	// IM.Instr
	 output [31:0] i_inst_addr,	// IM.A
	 
	 input [31:0] m_data_rdata,	// DM.D
	 
	 output w_grf_we,					// RF.RFWr
	 output [4:0] w_grf_addr,		// RF.A3
	 output [31:0] w_grf_wdata,	// RF.WD
	 output [31:0] w_inst_addr,	// RF.PC
	 
	 input TC0IRQ,
	 input TC1IRQ,
	 
	 output [31:0] AO_M_O,
	 output [1:0] DMWr_M_O,
	 output [31:0] PC4_M_O,
	 output Req,
	 output [31:0] MFWDMOut,
	 output IntWE,
	 input [31:0] br
    );
	 
	 // datapath
	////////////////stage F////////////////
	MUX_32_4 MFPCF(
		.In0(RF.RD1),
		.In1(REGW.PC8_W_O),
		.In2(REGW.DR_W_O),
		.In3(REGW.AO_W_O),
		.In4(REGW.HILO_W_O),
		.In5(REGW.PC0_W_O),
		.In6(REGM.PC8_M_O),
		.In7(REGM.AO_M_O),
		.In8(REGM.HILO_M_O),
		.Sel(FU.MFPCFSel)
	);
	MUX_32_2 MPC(
		.In0(ADD4.DO),
		.In1(NPC.Npc),
		.In2(MFPCF.Out),
		.Sel(CU.MPCOp)
	);
	MUX_32_1 MPCIE(
		.In0(MPC.Out),
		.In1(32'h0000_4180),
		.Sel(PC0.Req)
	);
	PC PC(
		.clk(clk),
		.reset(reset),
		.req(PC0.Req),
		.ne(SCTRL.PC_NE),
		.DI(MPCIE.Out)
	);
	
	assign i_inst_addr = (CU.EXLClr === 1'b1) ? PC0.EPC : PC.DO;
	
	wire ExcDSel;
	assign ExcDSel = (i_inst_addr[1:0] !== 2'b0) | (i_inst_addr < 32'h3000 || i_inst_addr > 32'h6ffc);
	
	ADD4 ADD4(
		.DI(i_inst_addr)
	);
	////////////////stage D////////////////
	MUX_5_1 MExcD(
		.In0(5'b00000),
		.In1(5'b00100),
		.Sel(ExcDSel)
	);
	REGD REGD(
		.clk(clk),
		.clr(reset),
		.req(PC0.Req),
		.stall(SCTRL.REGD_S),
		.IR_D_I(ExcDSel ? 32'b0 : i_inst_rdata),
		.PC4_D_I(ADD4.DO),
		.PC8_D_I(ADD4.DO + 32'b0100),
		.Exc_D_I(MExcD.Out),
		.bd_D_I(CU.bd)
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
	MUX_32_4 MFCMP1D(
		.In0(RF.RD1),
		.In1(REGW.PC8_W_O),
		.In2(REGW.DR_W_O),
		.In3(REGW.AO_W_O),
		.In4(REGW.HILO_W_O),
		.In5(REGW.PC0_W_O),
		.In6(REGM.PC8_M_O),
		.In7(REGM.AO_M_O),
		.In8(REGM.HILO_M_O),
		.Sel(FU.MFCMP1DSel)
	);
	MUX_32_4 MFCMP2D(
		.In0(RF.RD2),
		.In1(REGW.PC8_W_O),
		.In2(REGW.DR_W_O),
		.In3(REGW.AO_W_O),
		.In4(REGW.HILO_W_O),
		.In5(REGW.PC0_W_O),
		.In6(REGM.PC8_M_O),
		.In7(REGM.AO_M_O),
		.In8(REGM.HILO_M_O),
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
	MUX_5_1 MExcE(
		.In0(REGD.Exc_D_O),
		.In1(5'b01010),
		.Sel(CU.MExcESel)
	);
	MUX_5_1 MExcFE(
		.In0(MExcE.Out),
		.In1(REGD.Exc_D_O),
		.Sel(|REGD.Exc_D_O)
	);
	REGE REGE(
		.clk(clk),
		.clr(reset),
		.req(PC0.Req),
		.stall(SCTRL.REGE_R),
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
		.Tnew_E_I(SU.Tnew),
		.Exc_E_I(MExcFE.Out),
		.ls_E_I(CU.ls),
		.as_E_I(CU.as),
		.bd_E_I(REGD.bd_D_O),
		.PC0WE_E_I(CU.CP0WE),
		.PC0A_E_I(REGD.IR_D_O[15:11]),
		.EXLClr_E_I(CU.EXLClr)
	);
	MUX_32_4 MFALUAE(
		.In0(REGE.V1_E_O),
		.In1(REGW.PC8_W_O),
		.In2(REGW.DR_W_O),
		.In3(REGW.AO_W_O),
		.In4(REGW.HILO_W_O),
		.In5(REGW.PC0_W_O),
		.In6(REGM.PC8_M_O),
		.In7(REGM.AO_M_O),
		.In8(REGM.HILO_M_O),
		.Sel(FU.MFALUAESel)
	);
	MUX_32_4 MFALUBE(
		.In0(REGE.V2_E_O),
		.In1(REGW.PC8_W_O),
		.In2(REGW.DR_W_O),
		.In3(REGW.AO_W_O),
		.In4(REGW.HILO_W_O),
		.In5(REGW.PC0_W_O),
		.In6(REGM.PC8_M_O),
		.In7(REGM.AO_M_O),
		.In8(REGM.HILO_M_O),
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
		.ALUOp(REGE.ALUOp_E_O),
		.ls(REGE.ls_E_O),
		.as(REGE.as_E_O)
	);
	HILO HILO(
		.clk(clk),
		.reset(reset),
		.req(PC0.Req),
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
		.In5(REGW.PC0_W_O),
		.Sel(FU.MFV2MSel)
	);
	////////////////stage M////////////////
	MUX_5_2 MExcM(
		.In0(REGE.Exc_E_O),
		.In1(5'b00100),
		.In2(5'b00101),
		.In3(5'b01100),
		.Sel(ALU.ExcMSel)
	);
	MUX_5_1 MExcFM(
		.In0(MExcM.Out),
		.In1(REGE.Exc_E_O),
		.Sel(|REGE.Exc_E_O)
	);
	REGM REGM(
		.clk(clk),
		.clr(reset),
		.req(PC0.Req),
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
		.Tnew_M_I(REGE.Tnew_E_O),
		.Exc_M_I(MExcFM.Out),
		.bd_M_I(REGE.bd_E_O),
		.PC0WE_M_I(REGE.PC0WE_E_O),
		.PC0A_M_I(REGE.PC0A_E_O),
		.EXLClr_M_I(REGE.EXLClr_E_O)
	);
	MUX_32_3 MFWDM(
		.In0(REGM.V2_M_O),
		.In1(REGW.PC8_W_O),
		.In2(REGW.DR_W_O),
		.In3(REGW.AO_W_O),
		.In4(REGW.HILO_W_O),
		.In5(REGW.PC0_W_O),
		.Sel(FU.MFWDMSel)
	);
	
	PC0 PC0(
		.clk(clk),
		.rst(reset),
		.A1(REGM.PC0A_M_O),
		.A2(REGM.PC0A_M_O),
		.DIn(MFWDM.Out),
		.PC(REGM.PC4_M_O-32'b0100),
		.ExcCode(REGM.Exc_M_O),
		.bd(REGM.bd_M_O),
		.HWInt({3'b000, interrupt, TC1IRQ, TC0IRQ}),
		.WE(REGM.PC0WE_M_O),
		.EXLClr(REGM.EXLClr_M_O)
	);
	IntHandler IntHandler(
		.clk(clk),
		.interrupt(PC0.IntSig)
	);
	
	DMEXT DMEXT(
		 .A(REGM.AO_M_O[1:0]),
		 .Din(br),
		 .Op(REGM.DMEXTOp_M_O)
	);
	
	assign macroscopic_pc = REGM.PC4_M_O - 32'b0100;
	////////////////stage W////////////////
	REGW REGW(
		.clk(clk),
		.clr(reset),
		.req(PC0.Req),
		.A3_W_I(REGM.A3_M_O),
		.PC4_W_I(REGM.PC4_M_O),
		.PC8_W_I(REGM.PC8_M_O),
		.AO_W_I(REGM.AO_M_O),
		.PC0_W_I(PC0.DOut),
		.HILO_W_I(REGM.HILO_M_O),
		.DR_W_I(DMEXT.Dout),
		.RFWD_W_I(REGM.RFWD_M_O),
		.RFWr_W_I(REGM.RFWr_M_O),
		.MRFWDOp_W_I(REGM.MRFWDOp_M_O)
	);
	MUX_32_3 MRFWD(
		.In0(REGW.AO_W_O),
		.In1(REGW.DR_W_O),
		.In2(REGW.PC8_W_O),
		.In3(REGW.HILO_W_O),
		.In4(REGW.PC0_W_O),
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
		.HILO_Busy(HILO.Busy),
		.mtc0_E(REGE.PC0WE_E_O),
		.mtc0_M(REGM.PC0WE_M_O),
		.mtc0A_E(REGE.PC0A_E_O),
		.mtc0A_M(REGM.PC0A_M_O),
		.eret(CU.EXLClr)
	);
	SCTRL SCTRL(
		.Stall(SU.Stall)
	);
	
	assign AO_M_O = IntHandler.WE ? 32'h0000_7f20 : REGM.AO_M_O;
	assign DMWr_M_O = REGM.DMWr_M_O;
	assign PC4_M_O = REGM.PC4_M_O;
	assign Req = PC0.Req;
	assign MFWDMOut = MFWDM.Out;
	assign IntWE = IntHandler.WE;

endmodule
