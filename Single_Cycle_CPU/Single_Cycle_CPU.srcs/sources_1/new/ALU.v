`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/24 20:28:12
// Design Name: 
// Module Name: ALU
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


module ALU(
    input ALUSrcA,            // 决定输入A的信号量
    input ALUSrcB,            // 决定输入B的信号量
    input [31:0] RData1,      // RF 读取的第一个数据，操作数A的可能值
    input [31:0] RData2,      // RF 读取的第二个数据，操作数B的可能值
    input [4:0] sa,           // 移位操作的操作数，操作数A的可能值
    input [31:0] sze,         // 由位/零拓展得到的操作数，操作数B的可能值
    input [2:0] ALUOp,        // 决定操作类型的信号量
    output zero,              // 判定结果是否为0的信号量
    output reg [31:0] result  // 计算结果
    );

    wire [31:0] A;  // 最后决定的操作数A
    wire [31:0] B;  // 最后决定的操作数B

    // 选取两个操作数
    assign A[4:0] = (ALUSrcA) ? sa : RData1[4:0];
    assign A[31:5] = (ALUSrcA) ? 0 : RData1[31:5];
    assign B = (ALUSrcB) ? sze : RData2;

    // 设置零信号量
    assign zero = (result == 0);

    // 根据操作类型信号量，进行相应类型的操作
    always @(*) begin
      case(ALUOp)
        3'b000: result = A + B;
        3'b001: result = A - B;
        3'b010: result = B << A;
        3'b011: result = A | B;
        3'b100: result = A & B;
        3'b101: result = (A < B) ? 1 : 0;
        3'b110: result = ((A < B && A[31] == B[31]) || (A[31] == 1 && B[31] == 0)) ? 1 : 0;
        3'b111: result = A ^ B;
        default: result = 0;
      endcase
    end
endmodule
