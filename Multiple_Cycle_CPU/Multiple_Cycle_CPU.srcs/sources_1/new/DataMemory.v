`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/24 15:23:17
// Design Name: 
// Module Name: DM
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


module DM(
  input CLK,            // 时钟信号
  input RD,             // 读取信号
  input WR,             // 写入信号
  input DBDataSrc,      // DB 信号源选择
  input [31:0] result,  // ALU 运算结果，DB 的可能取值
  input [31:0] DAddr,   // 数据地址
  input [31:0] DataIn,  // 待写入的数据
  output reg [31:0] DB      // 数据总线
  );

  wire [31:0] DataOut;  // 读取得到的数据，DB 的可能取值

  // 128 bytes memory
  // Big-endiness
  reg [7:0] Data_Mem[0:127]; 
  
  integer i = 0;

  // 初始化数据寄存器
  initial begin
    repeat(128) begin
        Data_Mem[i] = 0;
        i = i + 1;
    end
  end

  // Read Data
  assign DataOut[7:0] = (RD) ? Data_Mem[DAddr + 3] : 8'bz; 
  assign DataOut[15:8] = (RD) ? Data_Mem[DAddr + 2] : 8'bz;
  assign DataOut[23:16] = (RD) ? Data_Mem[DAddr + 1] : 8'bz;
  assign DataOut[31:24] = (RD) ? Data_Mem[DAddr] : 8'bz;

  // Write Data
  always @(negedge CLK) begin
    if (WR) begin
      Data_Mem[DAddr] <= DataIn[31:24];
      Data_Mem[DAddr + 1] <= DataIn[23:16];
      Data_Mem[DAddr + 2] <= DataIn[15:8];
      Data_Mem[DAddr + 3] <= DataIn[7:0];
    end
  end

  // 根据信号量选择数据总线信号源
  always @(*) begin
    DB <= (DBDataSrc) ? DataOut : result;
  end
endmodule
