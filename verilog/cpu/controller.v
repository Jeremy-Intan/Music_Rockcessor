module controller (OpCode, RegWrite, BitmapWrite, DMemWrite, DMemEn, SignEx, MatchAcc, CompAcc, ALUAdd, ALUSub, ALUBR, ALULdSt, ALUShift, ALUScale, MuxReadBM, MuxReadReg1, MuxReadReg2, MuxWriteReg, MuxWriteData, MuxPCIn, MuxALUIn);


input [3:0] 	OpCode;

output 			RegWrite, BitmapWrite, DMemWrite, DMemEn, MatchAcc, CompAcc, ALUAdd, ALUSub, ALUBR, ALULdSt, ALUShift, ALUScale, MuxReadReg2, MuxWriteReg, MuxWriteData;
output [1:0]	SignEx, MuxReadBM, MuxReadReg1, MuxPCIn;

assign RegWrite = ((OpCode == 4'b0010)|(OpCode == 4'0011)) ? 1 : 0;
assign BitmapWrite = ((OpCode == 4'b1011)|(OpCode == 4'1010)|(OpCode == 4'1111)|(OpCode == 4'1101)) ? 1 : 0;
assign DMemEn = ((OpCode == 4'b1111)|(OpCode == 4'1110)|(OpCode == 4'0111)|(OpCode == 4'0110)) ? 1 : 0;
assign DMemWrite = ((OpCode == 4'b1110)|(OpCode == 4'0111)) ? 1 : 0;
assign SignEx = ((OpCode == 4'b0111)|(OpCode == 4'0110)) ? 2'b11 :
				((OpCode == 4'b1111)|(OpCode == 4'1110)) ? 2'b10 :
				(OpCode == 4'b1001) ? 2'b01 : 2'b00;
assign CompAcc = ((OpCode == 4'b1011) | (OpCode == 4'b1010)) ? 1 : 0;

assign ALUAdd = (OpCode == 4'b0011);
assign ALUSub = (OpCode == 4'b0010);
assign ALUBR = ((OpCode == 4'b0100) | (OpCode == 4'b0101));
assign ALULdSt = ((OpCode == 4'b0110) | (OpCode == 4'b0111)| (OpCode == 4'b1111) | (OpCode == 4'b1110));
assign ALUShift = (OpCode == 4'b1011);
assign ALUScale = (OpCode == 4'b1010);

assign MuxReadBM = (OpCode == 4'b1000) ? 2'b00 : ((OpCode == 4'b1010) | (OpCode == 4'b1011)) ? 2'b01 : 2'b11;
assign MuxReadReg2 = (OpCode == 4'b1000);
assign MuxReadReg1 = ((OpCode == 4'b1010) | (OpCode == 4'b1011)) ? 2'b00 : ((OpCode == 4'b1110) | (OpCode == 4'b1111)) ? 2'b01 : 2'b10;
assign MuxWriteReg = ((OpCode == 4'b1110) | (OpCode == 4'b1111)) ? 0 : 1;
assign MuxWriteData = ((OpCode == 4'b1001);
assign MuxPCIn =
assign MuxALUIn =



endmodule
