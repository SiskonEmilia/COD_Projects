`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/25 10:39:11
// Design Name: 
// Module Name: Single_Cycle_CPU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Single_Cycle_CPU(
  input CLK,
  input reset,

  output [5:0] op,
  output [4:0] rs,
  output [4:0] rt,
  output [4:0] rd,
  output [4:0] sa,
  output [15:0] immediate,
  output [25:0] jumpaddr,
  // Analysis Instruction

  output [31:0] IAddr,
  output [31:0] PC4,
  // PC

  output [31:0] pc_source_out,
  // PC_Source

  output [31:0] PC_Jump,
  // PC_Jumper

  output [31:0] IDataOut,
  // Instruction Memory

  output [31:0] DB,
  // Data Memory

  output [31:0] ReadData1,
  output [31:0] ReadData2,
  // Register File

  output [31:0] Extended,
  // Sign/Zero Extend

  output zero,
  output [31:0] result,
  // ALU

  output ExtSel,
  output PCWre,
  output InsMemRW,
  output RegDst,
  output RegWre,
  output ALUSrcA,
  output ALUSrcB,
  output nRD,
  output nWR,
  output DBDataSrc,
  output [2:0] ALUOp,
  output [1:0] PCSrc
  // Control Unit
  );

  assign op = IDataOut[31:26];
  assign rs = IDataOut[25:21];
  assign rt = IDataOut[20:16];
  assign rd = IDataOut[15:11];
  assign sa = IDataOut[10:6];
  assign immediate = IDataOut[15:0];
  assign jumpaddr = IDataOut[25:0];

  CU cu_ins(.zero(zero), .instruction(op), .ExtSel(ExtSel),
    .PCWre(PCWre), .InsMemRW(InsMemRW), .RegDst(RegDst),
    .RegWre(RegWre), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB),
    .nRD(nRD), .nWR(nWR), .DBDataSrc(DBDataSrc),
    .ALUOp(ALUOp), .PCSrc(PCSrc));

  ALU alu_ins(.ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB),
    .RData1(ReadData1), .RData2(ReadData2),
    .sa(sa), .sze(Extended), .ALUOp(ALUOp),
    .zero(zero), .result(result));

  RF rf_ins(.CLK(CLK), .RegDst(RegDst), .WE(RegWre), .RReg1(rs), .RReg2(rt),
    .rd(rd), .WriteData(DB), .ReadData1(ReadData1), .ReadData2(ReadData2));

  PC pc_ins(.CLK(CLK), .Reset(reset), .PCWre(PCWre), .pc(pc_source_out), .IAddr(IAddr), .PC4(PC4));

  PC_Source pc_source_ins(.PC4(PC4), .PC_Brench(Extended), .PC_Jump(PC_Jump), .PC_Src(PCSrc), .pc(pc_source_out));

  PC_Jumper pc_jumper_ins(.PC4(PC4), .pc(jumpaddr), .PC_Jump(PC_Jump));

  SZE sze_ins(.ExtSel(ExtSel), .Origin(immediate), .Extended(Extended));

  IM im_ins(.IAddr(IAddr), .RW(InsMemRW), .IDataOut(IDataOut));

  DM dm_ins(.CLK(CLK), .RD(nRD), .WR(nWR), .DBDataSrc(DBDataSrc), .result(result), .DAddr(result), .DataIn(ReadData2), .DB(DB));
  
endmodule
