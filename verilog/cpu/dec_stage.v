module dec_stage (inst, clk);

input [15:0] inst;
input clk;
output rs1, rs2, rd, pc, reg_write, mem_write, bm_write, se16;

wire [15:0] se4_16, se6_16, se8_16, se9_16;
wire [1:0] SignExOut, BMAddr, writeBMAddr,
wire [3:0] regAddr1, regAddr2, writeRegAddr
wire writeRegEn, writeBMEn

control controller (.OpCode(), .RegWrite(), .BitmapWrite(), .DMemWrite(), .DMemEn(), .SignEx(), .MatchAcc(), .CompAcc(), .ALUAdd(), .ALUSub(), .ALUBR(), .ALULdSt(), .ALUShift(), .ALUScale(), .MuxReadBM(), .MuxReadReg1(), .MuxReadReg2(), .MuxWriteReg(), .MuxWriteData(), .MuxPCIn(), .MuxALUIn());
					
					
reg_file reg_file (.rd_addr_1(regAddr1),.rd_data_1(),.rd_addr_2(regAddr2),.rd_data_2(),.wr_addr(writeRegAddr),.wr_data(),.wr(writeRegEn),.rbm_addr(BMAddr),.rbm_data(),.wbm_addr(writeBMAddr),.wbm_data(),.wbm(writeBMEn),.clk(clk));
//sign extend

assign se4_16 = {{12{inst[3]}}, inst[3:0]}; 
assign se6_16 = {{10{inst[5]}}, inst[5:0]}; 
assign se8_16 = {{8{inst[7]}}, inst[7:0]}; 
assign se9_16 = {{7{inst[8]}}, inst[8:0]}; 

assign se16 = (SignExOut == 2'b11) ? se4_16:
				(SignExOut == 2'b10) ? se6_16:
				(SignExOut == 2'b01) ? se8_16:
				(SignExOut == 2'b00) ? se9_16;
