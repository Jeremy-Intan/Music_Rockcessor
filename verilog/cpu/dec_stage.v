module dec_stage (inst, write_reg_addr, write_reg_data, write_reg_en, write_bm_addr, write_bm_data, write_bm_en, clk,
					PNZ, rd_data_1, rd_data_2, rbm_data, DMemWrite, DMemEn, MatchAcc, CompAcc, ALUBR, ALULdSt, rs1_used, rs2_used, bs_used,
					NOP, HALT, SUB, ADD, BRR, BR, LD, ST, PLY, MV, BSL, BSH, RET, SES, STB, LDB);

input wire [15:0] inst;
input wire [3:0] write_reg_addr;
input wire [15:0] write_reg_data;
input wire write_reg_en;
input wire [1:0] write_bm_addr;
input wire [1535:0] write_bm_data;
input wire [1:0] write_bm_en;
input wire clk;

output rs1, rs2, rd, pc, reg_write, mem_write, bm_write, se16,
		NOP, HALT, SUB, ADD, BRR, BR, LD, ST, PLY, MV, BSL, BSH, RET, SES, STB, LDB);
output [2:0] PNZ;
output [15:0] rd_data_1, rd_data_2;
output [1535:0] rbm_data;

wire [15:0] se4_16, se6_16, se8_16, se9_16;
wire [1:0] SignExOut, BMAddr;
wire [3:0] regAddr1, regAddr2;

assign PNZ = inst[11:9];

controlcontroller (.OpCode(inst[15:12]), .bmrIn(inst[11:10]), .RegWrite(RegWrite), .BitmapWrite(BitmapWrite), .DMemWrite(DMemWrite), .DMemEn(DMemEn), .SignEx(SignEx), .MatchAcc(MatchAcc), .CompAcc(CompAcc), .ALUBR(ALUBR), 
					.ALULdSt(ALULdSt), .MuxReadBM(MuxReadBM), .MuxReadReg1(MuxReadReg1), .MuxReadReg2(MuxReadReg2), .MuxWriteReg(MuxWriteReg), .MuxWriteData(MuxWriteData), .rs1_used(rs1_used), .rs2_used(rs2_used), .bs_used(bs_used), 
					.NOP(NOP), .HALT(HALT), .SUB(SUB), .ADD(ADD), .BRR(BRR), .BR(BR), .LD(LD), .ST(ST), .PLY(PLY), .MV(MV), .BSL(BSL), .BSH(BSH), .RET(RET), .SES(SES), .STB(STB), .LDB(LDB));
					
					
reg_file reg_file (.rd_addr_1(regAddr1),.rd_data_1(rd_data_1),.rd_addr_2(regAddr2),.rd_data_2(rd_data_2),.wr_addr(write_reg_addr),.wr_data(wr_reg_data),.wr(wr_reg_en),
					.rbm_addr(BMAddr),.rbm_data(rbm_data),.wbm_addr(wr_bm_addr),.wbm_data(wr_bm_data),.wbm(wr_bm_en),.clk(clk));


//sign extend

assign se4_16 = {{12{inst[3]}}, inst[3:0]}; 
assign se6_16 = {{10{inst[5]}}, inst[5:0]}; 
assign se8_16 = {{8{inst[7]}}, inst[7:0]}; 
assign se9_16 = {{7{inst[8]}}, inst[8:0]}; 

assign se16 = (SignExOut == 2'b11) ? se4_16:
				(SignExOut == 2'b10) ? se6_16:
				(SignExOut == 2'b01) ? se8_16:
				(SignExOut == 2'b00) ? se9_16;
				
				
endmodule
