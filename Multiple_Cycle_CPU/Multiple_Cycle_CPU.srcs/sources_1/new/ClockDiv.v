`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/27 12:51:30
// Design Name: 
// Module Name: ClockDiv
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


module ClockDiv(
  input originClock,
  output divClock
  );

  reg [16:0] counter;

  always @(posedge originClock) begin
    counter <= counter + 1;
  end

  assign divClock = counter[16];
endmodule
