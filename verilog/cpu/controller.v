module controller (OpCode, RegWrite, BitmapWrite, DMemWrite, DMemEn, SignEx, MatchAcc, CompAcc, ALUEn);


input [3:0] 	OpCode;

output 			RegWrite, BitmapWrite, DMemWrite, DMemEn, MatchAcc, CompAcc, ALUEn;
output [1:0]	SignEx;

assign RegWrite = ((OpCode == 4'b0010)|(OpCode == 4'0011)) ? 1 : 0;
assign BitmapWrite = ((OpCode == 4'b1011)|(OpCode == 4'1010)|(OpCode == 4'1111)|(OpCode == 4'1101)) ? 1 : 0;
assign DMemEn = ((OpCode == 4'b1111)|(OpCode == 4'1110)|(OpCode == 4'0111)|(OpCode == 4'0110)) ? 1 : 0;
assign DMemWrite = ((OpCode == 4'b1110)|(OpCode == 4'0111)) ? 1 : 0;
assign SignEx = ((OpCode == 4'b0111)|(OpCode == 4'0110)) ? 2'b11 :
				((OpCode == 4'b1111)|(OpCode == 4'1110)) ? 2'b10 :
				(OpCode == 4'b1001) ? 2'b01 : 2'b00;
assign ALUEn = (((OpCode >= 4'b0010) & (OpCode >= 4'b0111)) | (OpCode == 4'b1111) | (OpCode == 4'b1110)) ? 1 : 0;
assign CompAcc = ((OpCode == 4'b1011) | (OpCode == 4'b1010)) ? 1 : 0;

				



endmodule
