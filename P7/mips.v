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
	 input interrupt,
	 output [31:0] macroscopic_pc,
	 
	 input [31:0] i_inst_rdata,	// IM.Instr
	 output [31:0] i_inst_addr,	// IM.A
	 
	 input [31:0] m_data_rdata,	// DM.D
	 output [31:0] m_data_addr,	// DM.A
	 output [31:0] m_data_wdata,	// DM.WD
	 output [3:0] m_data_byteen,	// DM.DMWr
	 output [31:0] m_inst_addr,	// DM.PC
	 
	 output w_grf_we,					// RF.RFWr
	 output [4:0] w_grf_addr,		// RF.A3
	 output [31:0] w_grf_wdata,	// RF.WD
	 output [31:0] w_inst_addr		// RF.PC
    );
	
	CPU CPU(
		.clk(clk),
		.reset(reset),
		.interrupt(interrupt),
		.i_inst_rdata(i_inst_rdata),
		.m_data_rdata(m_data_rdata),
		.TC0IRQ(TC0.IRQ),
		.TC1IRQ(TC1.IRQ),
		.br(bridge.PrRD)
	);
	
	assign macroscopic_pc = CPU.macroscopic_pc;
	assign i_inst_addr = CPU.i_inst_addr;
	assign w_grf_we = CPU.w_grf_we;
	assign w_grf_addr = CPU.w_grf_addr;
	assign w_grf_wdata = CPU.w_grf_wdata;
	assign w_inst_addr = CPU.w_inst_addr;
	
	wire [31:0] CPUPrWD;
	assign CPUPrWD = (CPU.DMWr_M_O == 2'b11) ? CPU.MFWDMOut :
							(CPU.DMWr_M_O == 2'b10) ? {CPU.MFWDMOut[15:0], CPU.MFWDMOut[15:0]} :
							(CPU.DMWr_M_O == 2'b01) ? {CPU.MFWDMOut[7:0], CPU.MFWDMOut[7:0], CPU.MFWDMOut[7:0], CPU.MFWDMOut[7:0]} :
							CPU.MFWDMOut;
	
	bridge bridge(
		.PrAddr(CPU.AO_M_O),
		.PrWE((|CPU.DMWr_M_O) & (!CPU.Req)),
		.PrWD(CPU.MFWDMOut),
		.DMOut(m_data_rdata),
		.Dev0Out(TC0.Dout),
		.Dev1Out(TC1.Dout)
	);
	
	wire [3:0] byteen;
	assign m_data_addr = CPU.AO_M_O;
	assign m_data_wdata = 	CPUPrWD;
	assign byteen 		   = {(((CPU.DMWr_M_O == 2'b01) & (CPU.AO_M_O[1:0] == 2'b11)) | ((CPU.DMWr_M_O == 2'b10) & (CPU.AO_M_O[1] == 1'b1)) | (CPU.DMWr_M_O == 2'b11)),
									(((CPU.DMWr_M_O == 2'b01) & (CPU.AO_M_O[1:0] == 2'b10)) | ((CPU.DMWr_M_O == 2'b10) & (CPU.AO_M_O[1] == 1'b1)) | (CPU.DMWr_M_O == 2'b11)),
									(((CPU.DMWr_M_O == 2'b01) & (CPU.AO_M_O[1:0] == 2'b01)) | ((CPU.DMWr_M_O == 2'b10) & (CPU.AO_M_O[1] == 1'b0)) | (CPU.DMWr_M_O == 2'b11)),
									(((CPU.DMWr_M_O == 2'b01) & (CPU.AO_M_O[1:0] == 2'b00)) | ((CPU.DMWr_M_O == 2'b10) & (CPU.AO_M_O[1] == 1'b0)) | (CPU.DMWr_M_O == 2'b11))}
									& {bridge.DMWE, bridge.DMWE, bridge.DMWE, bridge.DMWE};
	assign m_data_byteen =  byteen | {CPU.IntWE, CPU.IntWE, CPU.IntWE, CPU.IntWE};
	assign m_inst_addr = CPU.PC4_M_O - 32'b0100;
	
	TC TC0(
		.clk(clk),
		.reset(reset),
		.Addr(CPU.AO_M_O[31:2]),
		.WE(bridge.Dev0WE),
		.Din(CPU.MFWDMOut)
	);
	TC TC1(
		.clk(clk),
		.reset(reset),
		.Addr(CPU.AO_M_O[31:2]),
		.WE(bridge.Dev1WE),
		.Din(CPU.MFWDMOut)
	);
endmodule
