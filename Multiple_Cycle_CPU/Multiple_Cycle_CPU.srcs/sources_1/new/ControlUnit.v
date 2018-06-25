`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/15 16:59:37
// Design Name: 
// Module Name: ControlUnit
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
	input [5:0] op,
	input CLK,
	input RST,
	input zero,
	input sign,

	output reg ExtSel,
	output reg PCWre,
	output reg IRWre,
	output reg InsMemRW,
	output reg WrRegDSrc,
	output reg RegWre,
	output reg ALUSrcA,
	output reg ALUSrcB,
	output reg mRD,
	output reg mWR,
	output reg DBDataSrc,
	output reg [2:0] ALUOp,
	output reg [1:0] RegDst,
	output reg [1:0] PCSrc,
	output reg [2:0] State
	);

	`define opAdd 6'b000000
	`define opSub 6'b000001
	`define opAddi 6'b000010
	`define opOr 6'b010000
	`define opAnd 6'b010001
	`define opOri 6'b010010
	`define opSll 6'b011000
	`define opSlt 6'b100110
	`define opSltiu 6'b100111
	`define opSw 6'b110000
	`define opLw 6'b110001
	`define opBeq 6'b110100
	`define opBltz 6'b110110
	`define opJ 6'b111000
	`define opJr 6'b111001
	`define opJal 6'b111010
	`define opHalt 6'b111111

	`define sIF 3'b000 		
	`define sID 3'b001 		
	`define sEXE 3'b010		
	`define sWB 3'b011
	`define sMEM 3'b100



	initial begin
		State = 3'b000;
		PCWre = 1;
		ALUSrcA = 0;
		ALUSrcB = 0;
		DBDataSrc = 0;
		RegWre = 1;
		InsMemRW = 0;
		mRD = 1;
		mWR = 1;
		RegDst = 2'b10;
		ExtSel = 0;
		PCSrc = 2'b00;
		ALUOp = 3'b000;
		IRWre = 0;
		WrRegDSrc = 1;
	end

	always @(posedge CLK or negedge RST) begin
		if (RST == 0) begin
			State <= `sIF;
		end 
		else begin
			if (State == `sIF)
			begin
				State <= `sID;
			end 
			else if (State == `sID) begin
				case(op)
					`opJ, `opJal, `opJr, `opHalt: State <= `sIF;
					default: State <= `sEXE;
				endcase
			end
			else if (State == `sEXE) begin
				case(op)
					`opBeq, `opBltz: State <= `sIF;
					`opSw, `opLw: State <= `sMEM;
					default: State <= `sWB;
				endcase
			end
			else if (State == `sWB) begin
				State <= `sIF;
			end
			else if (State == `sMEM) begin
				if (op == `opLw) begin
					State <= `sWB;
				end
				else begin
					State <= `sIF;
				end
			end
			else begin
				State <= `sIF;
			end
		end
	end

	always @(State or zero or sign or op or RST) begin
		WrRegDSrc = (State == `sID && op == `opJal) ? 0 : 1;
		RegWre = ((State == `sID && op == `opJal) || State == `sWB) ? 1 : 0;
		mRD = ((State == `sMEM || State == `sWB) && op == `opLw);
		mWR = (State == `sMEM && op == `opSw);
		case(State)
			`sIF:
				begin
					IRWre <= 1;
					InsMemRW <= 1;
				end
			`sID:
				begin
					IRWre <= 0;

					case(op)
						`opAddi, `opSw, `opLw, `opBeq, `opBltz:
							ExtSel <= 1;
						default:
							ExtSel <= 0;
					endcase

					case(op)
						`opBeq:
							PCSrc <= (zero == 0) ? 2'b00 : 2'b01;
						`opBltz:
							PCSrc <= (sign == 0 | zero == 1) ? 2'b00 : 2'b01;
						`opJ, `opJal:
							PCSrc <= 2'b11;
						`opJr:
							PCSrc <= 2'b10;
						default:
							PCSrc <= 2'b00;
					endcase

					case(op)
						`opAdd, `opSub, `opOr, `opAnd, `opSll, `opSlt:
							RegDst <= 2'b10;
						`opAddi, `opOri, `opSltiu, `opLw:
							RegDst <= 2'b01;
						default:
							RegDst <= 2'b00;
					endcase
				end
			`sEXE:
				begin
					ALUSrcA <= (op == `opSll);
					
					case(op)
						`opOri, `opSltiu, `opSw, `opLw, `opAddi:
							ALUSrcB <= 1;
						default:
							ALUSrcB <= 0;
					endcase

					case(op)
						`opSub, `opBeq, `opBltz:
						ALUOp = 3'b001;
						`opOr, `opOri:
						ALUOp = 3'b101;
						`opAnd:
						ALUOp = 3'b110;
						`opSll:
						ALUOp = 3'b100;
						`opSlt:
						ALUOp = 3'b011;
						`opSltiu:
						ALUOp = 3'b010;
						default:
						ALUOp = 3'b000;
					endcase

					case(op)
						`opBeq:
							PCSrc <= (zero == 0) ? 2'b00 : 2'b01;
						`opBltz:
							PCSrc <= (sign == 0 | zero == 1) ? 2'b00 : 2'b01;
						`opJ, `opJal:
							PCSrc <= 2'b11;
						`opJr:
							PCSrc <= 2'b10;
						default:
							PCSrc <= 2'b00;
					endcase

					DBDataSrc <= (op == `opLw);
				end
			`sWB:
			begin
				mWR <= 0;	

				case(op)
					`opAdd, `opSub, `opOr, `opAnd, `opSll, `opSlt:
						RegDst <= 2'b10;
					`opAddi, `opOri, `opSltiu, `opLw:
						RegDst <= 2'b01;
					default:
						RegDst <= 2'b00;
				endcase
			end
		endcase
	end

	always @(negedge CLK) begin
      case (State)
        `sID: begin
          if (op == `opJ || op == `opJal || op == `opJr)  PCWre <= 1;
        end

        `sEXE: begin
          if (op == `opBeq || op == `opBltz)  PCWre <= 1;
        end
        
        `sMEM: begin
          if (op == `opSw)  PCWre <= 1;
        end
        
        `sWB: PCWre <= 1;
        
        default:  PCWre <= 0;
      endcase
    end

endmodule