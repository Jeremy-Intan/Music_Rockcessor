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
isnt_dec_pipe idreg     (.instout(instout), .decin(instout_d));
dec_stage dec_stage        (.decin(instout_d), .decout(decout));
dec_alu_pipe dareg      (.decout(decout), .aluin(decout_a));
exe_stage alu_stage           (.aluin(decout_a), .aluout(aluout));
alu_mem_pipe amreg      (.alout(aluout), .memin(aluout_m));
wb_stage mem_stage        (.memin(aluout_m));

end
