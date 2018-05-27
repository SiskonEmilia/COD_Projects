`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/23 11:09:09
// Design Name: 
// Module Name: PC
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


module PC(
  input CLK,                    // 时钟信号
  input Reset,                  // 重置信号
  input PCWre,                 // PC 更改信号，为 0 时保持
  input [31:0] pc,              // 下一条指令的地址
  output reg [31:0] IAddr = 0,  // 输出指令地址
  output [31:0] PC4             // PC + 4
  );

  always @(posedge CLK or negedge Reset) begin
    if (!Reset) begin
      IAddr <= 0; 
      // 重置信号为 0，初始化 PC 为 0
    end
    else if (PCWre) begin
      IAddr <= pc;
      // 否则如果 PCWre 为1，则根据 PC 更改当前地址
    end
  end

  assign PC4 = IAddr + 4;
  // PC4 = IAddr + 4
endmodule

module PC_Source (
  input [31:0] PC4,          // PC 模块的 PC4 端，一般情况下使用
  input [31:0] PC_Brench,    // Brench 命令时使用的数据端
  input [31:0] PC_Jump,      // Jump 命令时使用的数据端
  input [31:0] PC_Nouse,     // 并没有用的数据端
  input [1:0] PC_Src, // 选择数据源
  output reg [31:0] pc    // 输出的指令位置数据
  );

  always @(*) begin
    case(PC_Src)
      2'b00: pc <= PC4;                     // 一般情况，使用 PC+4 作为下一个地址
      2'b01: pc <= (PC_Brench << 2) + PC4;  // brench 系列语句下，使用 PC_Brench 传来的地址
      2'b10: pc <= PC_Jump;                 // j 语句下，使用 PC_Jumper 生成的地址
      default: pc <= PC4;
    endcase
  end
endmodule

module PC_Jumper (
  input [31:0] PC4,
  input [25:0] pc,
  output [31:0] PC_Jump
);
  assign PC_Jump[31:28] = PC4[31:28]; // 取 PC + 4 的前四位作为新指令的前四位
  assign PC_Jump[27:0] = pc << 2;     // 将传来的27位地址左移2位，因为所有指令末尾都为0
endmodule
