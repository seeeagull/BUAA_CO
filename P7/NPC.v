`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:20:55 11/15/2021 
// Design Name: 
// Module Name:    NPC 
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
`define Btype 2'b01
`define Jtype 2'b10
module NPC(
    input [31:0] Pc,
    input [1:0] NPCOp,
    input [25:0] I26,
    output [31:0] Npc
    );

	assign Npc =	(NPCOp == `Btype) ?	({{14{I26[15]}}, I26[15:0], {2{1'b0}}} + Pc + 4):
						(NPCOp == `Jtype) ?	{Pc[31:28], I26[25:0], {2{1'b0}}} : 
						(Pc + 4);
endmodule
