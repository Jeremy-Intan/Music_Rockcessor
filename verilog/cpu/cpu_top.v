module cpu_top(input clk, input rst_n input [15:0] inst);
//top level module of the CPU

//will do work on interfacing in a bit, should give an idea of how we're doing this

//instruction stage outputs
wire instout;
wire instout_d;

//decode stage output
wire decout;
wire decout_a;

//ALU stage outputs
wire aluout;
wire aluout_m;



inst_stage inst_stage  (.inst(inst), .clk(clk), .rst_n(rst), .instout(instout));
mem_interface inst_mem(write_addr, read_addr, wr_enable, wr_data, rd_data, clk, rst_n);

//IF/ID pipes

dec_stage dec_stage        (.decin(instout_d), .decout(decout));

//ID/EXE pipes

exe_stage alu_stage           (.aluin(decout_a), .aluout(aluout));

mem_interface n_mem(write_addr, read_addr, wr_enable, wr_data, rd_data, clk, rst_n);
mem_interface #(1536) b_mem(write_addr, read_addr, wr_enable, wr_data, rd_data, clk, rst_n);

//EXE/WB stage

wb_stage mem_stage        (.memin(aluout_m));

end
