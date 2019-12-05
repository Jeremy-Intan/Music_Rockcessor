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
reg [15:0] idexe_pc;

reg [3:0] idexe_rs1_addr;
reg [3:0] idexe_rs2_addr;
reg [3:0] idexe_rd_addr;
reg [1:0] idexe_bs_addr;
reg [1:0] idexe_bd_addr;

reg [15:0] idexe_rs1_data;
reg [15:0] idexe_rs2_data;
reg [1535:0] idexe_bs_data;
reg [15:0] idexe_lit;

reg idexe_flushed;

reg idexe_br_combined;
reg [2:0] idexe_pnz;
reg idexe_ldst; 

reg idexe_ldb;
reg idexe_stb;
reg idexe_ses;
reg idexe_ret;
reg idexe_bsh;
reg idexe_bsl;
reg idexe_mv;
reg idexe_ply;
reg idexe_st;
reg idexe_ld;
reg idexe_br;
reg idexe_brr;
reg idexe_add;
reg idexe_sub;
reg idexe_halt;
reg idexe_nop;

// * IDEXE PIPES END *

// * EXE STAGE START

//exe stage outputs
reg exe_rs1_data;
reg exe_rs2_data;
reg exe_bs_data;

wire exe_rd_data;
wire exe_bd_data;

//exe stage
exe_stage Exe_stage(.pc(idexe_pc),
                    .rs1_data(exe_rs1_data),
                    .rs2_data(exe_rs2_data),
                    .bs_data(exe_bs_data),
                    .lit(idexe_lit),
                    .add(idexe_add),
                    .sub(idexe_sub),
                    .br(idexe_br_combined),
                    .mv(idexe_mv),
                    .bsh(idexe_bsh),
                    .bsl(idexe_bsl),
                    .save_addr(idexe_brr),
                    .ret(idexe_ret),
                    .pnz_in(idexe_pnz),
                    .branch_addr(),
                    .branch_taken(),
                    .rd_data(exe_rd_data),
                    .bd_data(exe_bd_data);


// * EXE STAGE END *

// for both exe and wb
// * MEMORY STUFF START *

mem_interface normalmem (.wraddress(exe_rd), .rdaddress, .wren, .data, .q, .clock);
mem_interface bitmapmem (.wraddress(), .rdaddress, .wren, .data, .q, .clock);

// * MEMORY STUFF END *

// * EXEWB PIPES START

// * EXEWB PIPES END

// * WB STAGE START *

wb_stage mem_stage        (.memin(aluout_m));


// * WB STAGE END *

end
