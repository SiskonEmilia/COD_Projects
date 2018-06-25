`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/23 23:40:52
// Design Name: 
// Module Name: IM
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


module IM(
  input CLK,
  input [31:0] IAddr,         // 操作地址
  input RW,                   // 读写信号量
  input IRWre,                // IR寄存器信号量
  output reg [31:0] IROut  // 输出指令
  );

  reg [7:0] Mem[0:127]; // 用于存储指令的寄存器
  reg [31:0] IDataOut;

  // 通过文件读写得到预设的指令
  initial begin
    $readmemb("D:/XILINX/PROJECTS/Multiple_Cycle_CPU/data/instructions.txt", Mem);
  end

  // 读取并输出指令
  always @(*) begin
    if (RW == 1) begin
      IDataOut[31:24] <= Mem[IAddr];
      IDataOut[23:16] <= Mem[IAddr + 1];
      IDataOut[15:8] <= Mem[IAddr + 2];
      IDataOut[7:0] <= Mem[IAddr + 3];
    end
  end

  always @(posedge CLK) begin
    if (IRWre == 1) begin
        IROut[31:0] <= IDataOut[31:0];
    end
  end
  
endmodule
