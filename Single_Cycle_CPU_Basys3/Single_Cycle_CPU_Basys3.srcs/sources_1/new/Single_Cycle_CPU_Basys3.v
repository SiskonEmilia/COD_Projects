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


module Single_Cycle_CPU_Basys3(
  input Ori_CLK,
  input Key_Clk,
  input reset,
  input [1:0] status,

  output [3:0] Led_Number,
  output [6:0] Led_Code
  );

  wire CLK;
  wire Div_Clk;

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
  // Control Unit

  assign op = IDataOut[31:26];
  assign rs = IDataOut[25:21];
  assign rt = IDataOut[20:16];
  assign rd = IDataOut[15:11];
  assign sa = IDataOut[10:6];
  assign immediate = IDataOut[15:0];
  assign jumpaddr = IDataOut[25:0];

  ClockDiv clkdiv_ins(.originClock(Ori_CLK), .divClock(Div_Clk));
  KeyClock keyclk_ins(.CLK(Div_Clk), .Key_Pressed(Key_Clk), .CPU_CLK(CLK));
  LedDisplay led_ins(.Switch_Status(status), .Div_CLK(Div_Clk),
    .presentPC(IAddr), .nextPC(pc_source_out),
    .RS_Addr({2'b00, rs}), .RS_Data(ReadData1),
    .RT_Addr({2'b00, rt}), .RT_Data(ReadData2),
    .ALU_Result(result[7:0]), .DB_Data(DB[7:0]),
    .Led_Number(Led_Number), .Led_Code(Led_Code)
    );


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
