`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/24 20:28:12
// Design Name: 
// Module Name: CU
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


module CU(
  input zero,               // 零信号量
  input [5:0] instruction,  // 指令
  output ExtSel,            // 拓展类型
  output PCWre,             // PC控制信号
  output InsMemRW,          // 指令寄存器读写信号量
  output RegDst,            // 寄存器地址选择信号量
  output RegWre,            // 寄存器读写信号量
  output ALUSrcA,           // ALU 操作数选择
  output ALUSrcB,           // ALU 操作数选择
  output nRD,               // 数据存储器写信号
  output nWR,               // 数据存储器读信号
  output DBDataSrc,         // 数据总线信号源
  output [2:0] ALUOp,       // 逻辑计算单元操作
  output [1:0] PCSrc        // 指令地址源信号量
  );

  // 预定义各个指令的宏，增加代码易读性
  `define opAdd 6'b000000
  `define opAddi 6'b000001
  `define opSub 6'b000010
  `define opOri 6'b010000
  `define opAnd 6'b010001
  `define opOr 6'b010010
  `define opSll 6'b011000
  `define opSlti 6'b011011
  `define opSw 6'b100110
  `define opLw 6'b100111
  `define opBeq 6'b110000
  `define opBne 6'b110001
  `define opJ 6'b111000
  `define opHalt 6'b111111

  // 根据指令设置信号量
  assign PCWre = (instruction != `opHalt) ? 1 : 0;
  assign ALUSrcA = (instruction == `opSll) ? 1 : 0;
  assign ALUSrcB = (instruction == `opAddi || instruction == `opOri || instruction == `opSlti || instruction == `opSw || instruction == `opLw) ? 1 : 0;
  assign DBDataSrc = (instruction == `opLw) ? 1 : 0;
  assign RegWre = (instruction == `opBeq || instruction == `opBne || instruction == `opSw || instruction == `opHalt || instruction == `opJ) ? 0 : 1;
  assign InsMemRW = 1;
  assign nRD = (instruction == `opLw) ? 1 : 0;
  assign nWR = (instruction == `opSw) ? 1 : 0;
  assign RegDst = (instruction == `opAddi || instruction == `opOri || instruction == `opLw || instruction == `opSlti) ? 0 : 1;
  assign ExtSel = (instruction == `opOri) ? 0 : 1;
  assign PCSrc[1] = (instruction == `opJ) ? 1 : 0;
  assign PCSrc[0] = ((instruction == `opBeq && zero == 1) || (instruction == `opBne && zero == 0)) ? 1 : 0;
  assign ALUOp[2] = (instruction == `opAnd || instruction == `opSlti) ? 1 : 0;
  assign ALUOp[1] = (instruction == `opSlti || instruction == `opOr || instruction == `opSll || instruction == `opOri) ? 1 : 0;
  assign ALUOp[0] = (instruction == `opAdd || instruction == `opSll || instruction == `opOr || instruction == `opSlti || instruction === `opAddi || instruction == `opOri || instruction == `opSw || instruction == `opLw) ? 0 : 1;


endmodule