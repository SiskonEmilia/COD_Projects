`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/27 12:51:30
// Design Name: 
// Module Name: KeyClock
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


module KeyClock(
  input CLK,
  input Key_Pressed,
  output reg CPU_CLK
  );

  always @(posedge CLK) begin
    if (Key_Pressed) begin
      CPU_CLK <= 0;
    end else begin
      CPU_CLK <= 1;
    end
  end
endmodule
