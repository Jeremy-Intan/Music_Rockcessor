
module controller (OpCode, RegWrite, BitmapWrite, DMemWrite, DMemEn, SignEx, MatchAcc, CompAcc, ALUBR, ALULdSt, MuxReadBM, MuxReadReg1, MuxReadReg2, MuxWriteReg, MuxWriteData, MuxPCIn, MuxALUIn, 
					NOP, HALT, SUB, ADD, BRR, BR, LD, ST, PLY, MV, BSL, BSH, RET, SES, STB, LDB);


input [3:0] 	OpCode;

output 			RegWrite, BitmapWrite, DMemWrite, DMemEn, MatchAcc, CompAcc, ALUBR, ALULdSt, MuxReadReg2, MuxWriteReg, MuxWriteData,
				NOP, HALT, SUB, ADD, BRR, BR, LD, ST, PLY, MV, BSL, BSH, RET, SES, STB, LDB;
output [1:0]	SignEx, MuxReadBM, MuxReadReg1, MuxPCIn;

assign RegWrite = ((OpCode == 4'b0010)|(OpCode == 4'0011)) ? 1 : 0;
assign BitmapWrite = ((OpCode == 4'b1011)|(OpCode == 4'1010)|(OpCode == 4'1111)|(OpCode == 4'1101)) ? 1 : 0;
assign DMemEn = ((OpCode == 4'b1111)|(OpCode == 4'1110)|(OpCode == 4'0111)|(OpCode == 4'0110)) ? 1 : 0;
assign DMemWrite = ((OpCode == 4'b1110)|(OpCode == 4'0111)) ? 1 : 0;
assign SignEx = ((OpCode == 4'b0111)|(OpCode == 4'0110)) ? 2'b11 :
				((OpCode == 4'b1111)|(OpCode == 4'1110)) ? 2'b10 :
				(OpCode == 4'b1001) ? 2'b01 : 2'b00;
assign CompAcc = ((OpCode == 4'b1011) | (OpCode == 4'b1010)) ? 1 : 0;

assign ALUBR = ((OpCode == 4'b0100) | (OpCode == 4'b0101));
assign ALULdSt = ((OpCode == 4'b0110) | (OpCode == 4'b0111)| (OpCode == 4'b1111) | (OpCode == 4'b1110));

assign MuxReadBM = (OpCode == 4'b1000) ? 2'b00 : ((OpCode == 4'b1010) | (OpCode == 4'b1011)) ? 2'b01 : 2'b11;
assign MuxReadReg2 = (OpCode == 4'b1000);
assign MuxReadReg1 = ((OpCode == 4'b1010) | (OpCode == 4'b1011)) ? 2'b00 : ((OpCode == 4'b1110) | (OpCode == 4'b1111)) ? 2'b01 : 2'b10;
assign MuxWriteReg = ((OpCode == 4'b1110) | (OpCode == 4'b1111)) ? 0 : 1;
assign MuxWriteData = ((OpCode == 4'b1001);
assign MuxPCIn =
assign MuxALUIn =


assign NOP  = (OpCode == 4'b0000);
assign HALT = (OpCode == 4'b0001);
assign SUB  = (OpCode == 4'b0010);
assign ADD  = (OpCode == 4'b0011);
assign BRR  = (OpCode == 4'b0100);
assign BR   = (OpCode == 4'b0101);
assign LD   = (OpCode == 4'b0110);
assign ST   = (OpCode == 4'b0111);
assign PLY  = (OpCode == 4'b1000);
assign MV   = (OpCode == 4'b1001);
assign BSL  = (OpCode == 4'b1010);
assign BSH  = (OpCode == 4'b1011);
assign RET  = (OpCode == 4'b1100);
assign SES  = (OpCode == 4'b1101);
assign STB  = (OpCode == 4'b1110);
assign LDB  = (OpCode == 4'b1111);


endmodule
