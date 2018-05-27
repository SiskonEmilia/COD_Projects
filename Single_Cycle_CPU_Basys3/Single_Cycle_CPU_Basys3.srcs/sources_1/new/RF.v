`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/24 15:38:46
// Design Name: 
// Module Name: RF
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


module RF(
    input CLK,                    // 时钟信号
    input WE,                     // 写入信号
    input RegDst,                 // 写入地址来源
    input [4:0] RReg1,            // 读取寄存器地址 1
    input [4:0] RReg2,            // 读取寄存器地址 2
    input [4:0] rd,               // rd 地址段，可能的写入寄存器地址
    input [31:0] WriteData,       // 待写入的数据
    output [31:0] ReadData1,      // 读取到的数据 1
    output [31:0] ReadData2       // 读取到的数据 2
    );

    wire [4:0] WReg;
    assign WReg = (RegDst) ? rd : RReg2; // 根据信号量选取读入寄存器地址

    reg [31:0] Regs[0:31]; // 寄存器组（32位*32个）
    
    integer i = 0; 
    initial begin // 初始化寄存器组
      repeat(32) begin
        Regs[i] = 0;
        i = i + 1;
      end
    end

    // 读取数据
    assign ReadData1 = Regs[RReg1];
    assign ReadData2 = Regs[RReg2];

    // 写入数据（如果需要）
    always @(negedge CLK) begin
      if (WE) begin
        Regs[WReg] <= WriteData;
      end
    end
endmodule
