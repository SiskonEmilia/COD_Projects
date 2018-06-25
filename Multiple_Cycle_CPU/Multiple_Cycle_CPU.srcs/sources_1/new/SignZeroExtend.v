`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/24 14:08:07
// Design Name: 
// Module Name: SZE
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Sign/Zero Extend
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SZE(
    input ExtSel,           // 信号量，决定拓展方式
    input [15:0] Origin,    // 原始信号
    output [31:0] Extended  // 拓展后的信号
    );

    assign Extended[15:0] = Origin[15:0];                                   // 后16位不做改变
    assign Extended[31:16] = (ExtSel && Origin[15]) ? 16'hffff : 16'h0000;  // 根据信号量不同，在前16位填充相应的位值
endmodule
