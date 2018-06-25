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
    input CLK,                  // 时钟信号
    input WE,                   // 写入信号
    input WrRegDSrc,            // 写入数据选择信号
    input [1:0] RegDst,         // 写入地址来源
    input [4:0] RReg1,          // 读取寄存器地址 1
    input [4:0] RReg2,          // 读取寄存器地址 2
    input [4:0] rd,             // rd 地址段，可能的写入寄存器地址
    input [31:0] DB,            // 待写入的数据1
    input [31:0] PC4,           // 待写入的数据2
    output reg [31:0] ReadData1,// 读取到的数据 1
    output reg [31:0] ReadData2 // 读取到的数据 2
    );

    reg [4:0] WReg;
    wire [31:0] WriteData;

    always @(*) begin
        case(RegDst)
            2'b00:
                WReg <= 5'b11111;
            2'b01:
                WReg <= RReg2;
            2'b10:
                WReg <= rd;
        endcase
    end 

    assign WriteData = (WrRegDSrc) ? DB : PC4;

    reg [31:0] Regs[0:31]; // 寄存器组（32位*32个）
    
    integer i = 0; 
    initial begin // 初始化寄存器组
      repeat(32) begin
        Regs[i] = 0;
        i = i + 1;
      end
    end

    // 读取数据
    always @(*) begin
        ReadData1 <= Regs[RReg1];
        ReadData2 <= Regs[RReg2];
    end

    // 写入数据（如果需要）
    always @(negedge CLK) begin
      if (WE) begin
        Regs[WReg] <= WriteData;
      end
    end
endmodule
