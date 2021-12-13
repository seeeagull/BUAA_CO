`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:06:41 11/25/2021 
// Design Name: 
// Module Name:    CU
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
`define Lb		6'b100000
`define Lbu		6'b100100
`define Lh		6'b100001
`define Lhu		6'b100101
`define Sb		6'b101000
`define Sh		6'b101001
`define Lw 		6'b100011
`define Sw 		6'b101011

`define Addi	6'b001000
`define Addiu	6'b001001
`define Andi	6'b001100
`define Xori	6'b001110
`define Ori		6'b001101
`define Lui		6'b001111
`define Slti	6'b001010
`define Sltiu	6'b001011
`define Beq		6'b000100
`define Bne		6'b000101
`define Blez	6'b000110
`define Bgtz	6'b000111
`define Bltz	6'b000001
`define Bgez	6'b000001
`define J		6'b000010
`define Jal		6'b000011

`define Rtype	6'b000000
`define Add		6'b100000
`define Addu	6'b100001
`define Sub		6'b100010
`define Subu	6'b100011
`define Sll		6'b000000
`define Srl		6'b000010
`define Sra		6'b000011
`define Sllv	6'b000100
`define Srlv	6'b000110
`define Srav	6'b000111
`define Or		6'b100101
`define And		6'b100100
`define Xor		6'b100110
`define Nor		6'b100111
`define Slt		6'b101010
`define Sltu	6'b101011
`define Jalr	6'b001001
`define Jr		6'b001000
`define Mult	6'b011000
`define Multu	6'b011001
`define Div		6'b011010
`define Divu	6'b011011
`define Mfhi	6'b010000
`define Mflo	6'b010010
`define Mthi	6'b010001
`define Mtlo	6'b010011
module CU(
	 input [31:0] Instr,
	 input Cmp,
	 output [15:0] Op,
	 output hilo,
	 output [2:0] CMPOp,		// D
	 output [1:0] MPCOp,		// D
	 output [1:0] NPCOp,		// D
	 output RFWr,				// W OK
	 output [1:0] RFWD,		// D
	 output [1:0] MA3EOp,	// D
	 output [1:0] MRFWDOp,	// W OK
	 output [1:0] EXTOp,		// D
	 output [3:0] ALUOp,		// E OK
	 output ASel,				// E OK
	 output [1:0] BSel,		// E OK
	 output [3:0] HILOOp,	// E OK
	 output [1:0] DMWr,		// M OK
	 output [2:0] DMEXTOp	// M OK
    );
	wire 	lb, lbu, lh, lhu, sb, sh, lw, sw,
			slt, slti, sltiu, sltu, 
			beq, bne, blez, bgtz, bltz, bgez,
			j, jal, jalr, jr,
			mfhi, mflo, mthi, mtlo,
			add, addu, sub, subu, mult, multu, div, divu, 
			sll, srl, sra, sllv, srlv, srav,
			_and, _or, _xor, _nor,
			addi, addiu, andi, ori, xori, lui;
	
	assign lb 	= 	Instr[31:26] == `Lb;
	assign lbu 	= 	Instr[31:26] == `Lbu;
	assign lh 	= 	Instr[31:26] == `Lh;
	assign lhu 	= 	Instr[31:26] == `Lhu;
	assign sb 	= 	Instr[31:26] == `Sb;
	assign sh 	= 	Instr[31:26] == `Sh;
	assign lw 	= 	Instr[31:26] == `Lw;
	assign sw 	= 	Instr[31:26] == `Sw;
	
	assign addi	= 	Instr[31:26] == `Addi;
	assign addiu= 	Instr[31:26] == `Addiu;
	assign andi	= 	Instr[31:26] == `Andi;
	assign xori	= 	Instr[31:26] == `Xori;
	assign ori 	= 	Instr[31:26] == `Ori;
	assign lui 	= 	Instr[31:26] == `Lui;
	assign slti	= 	Instr[31:26] == `Slti;
	assign sltiu= 	Instr[31:26] == `Sltiu;
	assign beq 	= 	Instr[31:26] == `Beq;
	assign bne 	= 	Instr[31:26] == `Bne;
	assign blez = 	Instr[31:26] == `Blez;
	assign bgtz	= 	Instr[31:26] == `Bgtz;
	assign bltz	= 	(Instr[31:26] == `Bltz) && (Instr[20:16] == 5'b00000);
	assign bgez	= 	(Instr[31:26] == `Bgez) && (Instr[20:16] == 5'b00001);
	assign j 	= 	Instr[31:26] == `J;
	assign jal 	= 	Instr[31:26] == `Jal;
	
	assign add	= 	(Instr[31:26] == `Rtype) && (Instr[5:0] == `Add);
	assign addu	= 	(Instr[31:26] == `Rtype) && (Instr[5:0] == `Addu);
	assign sub	= 	(Instr[31:26] == `Rtype) && (Instr[5:0] == `Sub);
	assign subu	= 	(Instr[31:26] == `Rtype) && (Instr[5:0] == `Subu);
	assign sll	= 	(Instr[31:26] == `Rtype) && (Instr[5:0] == `Sll);
	assign srl	= 	(Instr[31:26] == `Rtype) && (Instr[5:0] == `Srl);
	assign sra	= 	(Instr[31:26] == `Rtype) && (Instr[5:0] == `Sra);
	assign sllv	= 	(Instr[31:26] == `Rtype) && (Instr[5:0] == `Sllv);
	assign srlv	= 	(Instr[31:26] == `Rtype) && (Instr[5:0] == `Srlv);
	assign srav	= 	(Instr[31:26] == `Rtype) && (Instr[5:0] == `Srav);
	assign _or	=	(Instr[31:26] == `Rtype) && (Instr[5:0] == `Or);
	assign _and	=	(Instr[31:26] == `Rtype) && (Instr[5:0] == `And);
	assign _xor	=	(Instr[31:26] == `Rtype) && (Instr[5:0] == `Xor);
	assign _nor	=	(Instr[31:26] == `Rtype) && (Instr[5:0] == `Nor);
	assign slt	=	(Instr[31:26] == `Rtype) && (Instr[5:0] == `Slt);
	assign sltu	=	(Instr[31:26] == `Rtype) && (Instr[5:0] == `Sltu);
	assign jalr	= 	(Instr[31:26] == `Rtype) && (Instr[5:0] == `Jalr);
	assign jr 	= 	(Instr[31:26] == `Rtype) && (Instr[5:0] == `Jr);
	assign mult	= 	(Instr[31:26] == `Rtype) && (Instr[5:0] == `Mult);
	assign multu= 	(Instr[31:26] == `Rtype) && (Instr[5:0] == `Multu);
	assign div	= 	(Instr[31:26] == `Rtype) && (Instr[5:0] == `Div);
	assign divu	= 	(Instr[31:26] == `Rtype) && (Instr[5:0] == `Divu);
	assign mfhi	= 	(Instr[31:26] == `Rtype) && (Instr[5:0] == `Mfhi);
	assign mflo	= 	(Instr[31:26] == `Rtype) && (Instr[5:0] == `Mflo);
	assign mthi	= 	(Instr[31:26] == `Rtype) && (Instr[5:0] == `Mthi);
	assign mtlo	= 	(Instr[31:26] == `Rtype) && (Instr[5:0] == `Mtlo);
	
	assign Op	=	{mult | multu | div | divu, mfhi | mflo, mthi | mtlo, alur, alui, sll | srl | sra, sllv | srlv | srav, slt | sltu, slti | sltiu, load, store, branch, j, jal, jr, jalr};
	assign hilo		=	mult | multu | div | divu | mfhi | mflo | mthi | mtlo;
	
	assign store	=	sb | sh | sw;
	assign load		=	lb | lbu | lh | lhu | lw;
	assign branch	= 	beq | bne | blez | bgtz | bltz | bgez;
	assign shift	=	sll | srl | sra | sllv | srlv | srav;
	assign set		=	slt | slti | sltiu | sltu;
	assign alur		=	add | addu | sub | subu | _and | _or | _xor | _nor;
	assign alui		=	addi | addiu | andi | ori | xori | lui;
	
	assign imm		=	slti | sltiu | addi | addiu | andi | ori | xori | lui;
	
	assign MPCOp	=	{jr | jalr, (branch & Cmp) | j | jal};									// OK
	assign CMPOp	=	{bltz | bgez, blez | bgtz, bne | bgtz | bgez};						//	OK
	assign NPCOp	= 	{j | jal, (branch & Cmp)};													// OK
	assign RFWr 	= 	alur | alui | shift | load | set | jal | jalr | mfhi | mflo;	// OK
	assign RFWD		=	(mfhi | mflo) 						? 2'b11 : // HILO						// OK
							(jal | jalr)						? 2'b10 : // PC8
							load									? 2'b01 : // DM
							(alur | alui | shift | set) 	? 2'b00 : // ALU
							2'b00;
	assign MA3EOp	=	{jal, jalr | alur | shift | slt | sltu | mfhi | mflo};			// OK
	assign MRFWDOp	=	{mfhi | mflo | jal | jalr, mfhi | mflo | load};						// OK
	assign EXTOp 	= 	{lui, load | store | addi | addiu | slti | sltiu};					// OK
	assign ALUOp	=	{_and | _or | _xor | _nor | andi | ori | xori | set,				// OK
							 shift | set,
							 add | sub | addi | sra | srav | _xor | _nor | xori,
							 subu | sub | srl | sra | srlv | srav | _or | ori | _nor | slt | slti};
	assign ASel		=	shift;																			// OK
	assign BSel		=	{shift, imm | load | store | sll | sra | srl}; 						// OK
	assign HILOOp	=	{mthi | mtlo, 
							mfhi | mflo | div | divu, 
							mult | multu | mfhi | mflo,
							multu | divu | mflo | mtlo};												// OK
	assign DMWr		=	sw	? 2'b11 :																	// OK
							sh ? 2'b10 :
							sb ? 2'b01 :
							2'b00;
	assign DMEXTOp	=	lh	? 3'b100 :																	// OK
							lhu? 3'b011 :
							lb ? 3'b010 :
							lbu? 3'b001 :
							2'b000;

endmodule
