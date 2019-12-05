module cpu_top(input clk, input rst_n input [15:0] inst);
//top level module of the CPU


// * INST STAGE START *

//if stage outputs
wire if_pc;
wire if_inst;
wire if_inst_valid;

//inst stage
inst_stage Inst_stage(.clk(clk), .rst_n(rst_n), .branch_pc( ), .branch_to_new( ), .pc(if_inst), .inst(if_inst), .inst_valid(if_inst_valid));

// * INST STAGE END *

// * IFID PIPES START *
reg [15:0] ifid_pc;
reg [15:0] ifid_inst;
reg ifid_flushed;

always @ (posedge clk) begin
    ifid_pc <= if_pc;
    ifid_inst <= if_inst;
    ifid_flushed <= ~if_inst_valid;
end

// * IFID PIPES END *

// * DECODE STAGE START *

//decode stage output
wire decout;
wire decout_a;

//decode stage
dec_stage dec_stage        (.decin(instout_d), .decout(decout));


// * DECODE STAGE END *

// * IDEXE PIPES START *


// * IDEXE PIPES END *

// * EXE STAGE START

//exe stage outputs
wire aluout;
wire aluout_m;

//exe stage


// * EXE STAGE END *

// for both exe and wb
// * MEMORY STUFF START *

mem_interface n_mem(write_addr, read_addr, wr_enable, wr_data, rd_data, clk, rst_n);
mem_interface #(1536) b_mem(write_addr, read_addr, wr_enable, wr_data, rd_data, clk, rst_n);

// * MEMORY STUFF END *

// * EXEWB PIPES START

// * EXEWB PIPES END

// * WB STAGE START *

wb_stage mem_stage        (.memin(aluout_m));


// * WB STAGE END *

end
