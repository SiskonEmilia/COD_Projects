`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/25 19:50:00
// Design Name: 
// Module Name: cpu_sim
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


module cpu_sim();
  reg CLK;
  reg reset;

  wire [5:0] op;
  wire [4:0] rs;
  wire [4:0] rt;
  wire [4:0] rd;
  wire [4:0] sa;
  wire [15:0] immediate;
  wire [25:0] jumpaddr;
  // Analysis Instruction

  wire [31:0] IAddr;
  wire [31:0] PC4;
  // PC

  wire [31:0] pc_source_out;
  // PC_Source

  wire [31:0] PC_Jump;
  // PC_Jumper

  wire [31:0] IDataOut;
  // Instruction Memory

  wire [31:0] DB;
  // Data Memory

  wire [31:0] ReadData1;
  wire [31:0] ReadData2;
  // Register File

  wire [31:0] Extended;
  // Sign/Zero Extend

  wire zero;
  wire [31:0] result;
  // ALU

  wire ExtSel;
  wire PCWre;
  wire InsMemRW;
  wire RegDst;
  wire RegWre;
  wire ALUSrcA;
  wire ALUSrcB;
  wire nRD;
  wire nWR;
  wire DBDataSrc;
  wire [2:0] ALUOp;
  wire [1:0] PCSrc;

  Single_Cycle_CPU cpu(
    .CLK(CLK), .reset(reset),
    .op(op), .rs(rs), .rt(rt), .rd(rd), .sa(sa), .immediate(immediate), .jumpaddr(jumpaddr),
    .IAddr(IAddr), .PC4(PC4), .pc_source_out(pc_source_out), .PC_Jump(PC_Jump),
    .IDataOut(IDataOut),
    .DB(DB),
    .ReadData1(ReadData1), .ReadData2(ReadData2),
    .Extended(Extended),
    .zero(zero), .result(result),
    .ExtSel(ExtSel), .PCWre(PCWre), .InsMemRW(InsMemRW),
    .RegDst(RegDst), .RegWre(RegWre), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB),
    .nRD(nRD), .nWR(nWR), .DBDataSrc(DBDataSrc),
    .ALUOp(ALUOp), .PCSrc(PCSrc)
  );

  initial begin
    CLK = 0;
    reset = 0;
    #50;
        CLK=1;
    #50;
        reset=1;
    forever #50 begin
        CLK=~CLK;
    end
  end

endmodule
