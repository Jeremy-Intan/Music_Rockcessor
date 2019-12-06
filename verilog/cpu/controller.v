module controller (OpCode, bmrIn, RegWrite, BitmapWrite, DMemWrite, DMemEn, SignEx, MatchAcc, CompAcc, ALUBR, ALULdSt, MuxReadBM, MuxReadReg1, MuxReadReg2, MuxWriteReg, MuxWriteData, rs1_used, rs2_used, bs_used, 
					NOP, HALT, SUB, ADD, BRR, BR, LD, ST, PLY, MV, BSL, BSH, RET, SES, STB, LDB);


input [3:0] 	OpCode;
input [1:0]		bmrIn; 

output			RegWrite, BitmapWrite, DMemWrite, DMemEn, MatchAcc, CompAcc, ALUBR, ALULdSt, MuxReadReg1, MuxWriteReg, MuxWriteData, rs1_used, rs2_used, bs_used, 
				NOP, HALT, SUB, ADD, BRR, BR, LD, ST, PLY, MV, BSL, BSH, RET, SES, STB, LDB;
output [1:0]	SignEx, MuxReadBM, MuxReadReg2;

wire	NOPw, HALTw, SUBw, ADDw, BRRw, BRw, LDw, STw, PLYw, MVw, BSLw, BSHw, RETw, SESw, STBw, LDBw;

assign NOPw  = (OpCode == 4'b0000);
assign HALTw = (OpCode == 4'b0001);
assign SUBw  = (OpCode == 4'b0010);
assign ADDw  = (OpCode == 4'b0011);
assign BRRw  = (OpCode == 4'b0100);
assign BRw   = (OpCode == 4'b0101);
assign LDw   = (OpCode == 4'b0110);
assign STw   = (OpCode == 4'b0111);
assign PLYw  = (OpCode == 4'b1000);
assign MVw   = (OpCode == 4'b1001);
assign BSLw  = (OpCode == 4'b1010);
assign BSHw  = (OpCode == 4'b1011);
assign RETw  = (OpCode == 4'b1100);
assign SESw  = (OpCode == 4'b1101);
assign STBw  = (OpCode == 4'b1110);
assign LDBw  = (OpCode == 4'b1111);

assign DMemEn = (LDBw|STBw|STw|LDw) ? 1 : 0;
assign DMemWrite = (STBw|STw) ? 1 : 0;
assign SignEx = (STw|LDw) ? 2'b11 :
				(LDBw|STBw) ? 2'b10 :
				(MVw) ? 2'b01 : 2'b00;
assign CompAcc = (BSHw | BSLw | (LDBw && (bmrIn == 2'b01))) ? 1 : 0;
assign MatchAcc = (LDBw && (bmrIn == 2'b01));

assign rs1_used = (SUBw | ADDw | LDw | STw | PLYw | BSLw | BSHw | STBw | LDBw);
assign rs2_used = (SUBw | ADDw | STw | PLYw);
assign bs_used = (PLYw | BSHw | BSLw | STBw);
assign ALUBR = (BRRw | BRw);
assign ALULdSt = (LDw | STw | LDBw | STBw);

//Register files input

assign RegWrite = (SUBw | ADDw) ? 1 : 0;
assign BitmapWrite = (BSHw|BSLw|LDBw|SESw) ? 1 : 0;
assign MuxReadBM = PLYw ? 2'b00 : (BSLw | BSHw) ? 2'b01 : 2'b11;
assign MuxReadReg2 = PLYw ? 2'b10 :(STBw | LDBw) ? 2'b11 : 2'b01;
assign MuxReadReg1 = (BSLw | BSHw) ? 0 : 1;
assign MuxWriteReg = (STBw | LDBw) ? 0 : 1;
assign MuxWriteData = (MVw);

//instructions

assign NOP  = NOPw;
assign HALT = HALTw;
assign SUB  = SUBw;
assign ADD  = ADDw;
assign BRR  = BRRw;
assign BR   = BRw;
assign LD   = LDw;
assign ST   = STw;
assign PLY  = PLYw;
assign MV   = MVw;
assign BSL  = BSLw;
assign BSH  = BSHw;
assign RET  = RETw;
assign SES  = SESw;
assign STB  = STBw;
assign LDB  = LDBw;


endmodule
