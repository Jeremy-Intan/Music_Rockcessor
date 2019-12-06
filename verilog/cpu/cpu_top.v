module cpu_top(input clk, input rst_n input [15:0] inst);
//top level module of the CPU

//B R A N C H B O I S
reg cpu_branch_pc;
reg cpu_branch_to_new;

// * INST STAGE START *

//if stage outputs
wire if_pc;
wire if_inst;
wire if_inst_valid;

//inst stage
inst_stage Inst_stage(.clk(clk), .rst_n(rst_n), .branch_pc(cpu_branch_pc), .branch_to_new(cpu_branch_to_new), .pc(if_inst), .inst(if_inst), .inst_valid(if_inst_valid));

// * INST STAGE END *

// * IFID PIPES START *
reg ifid_stall;

reg [15:0] ifid_pc;
reg [15:0] ifid_inst;
reg ifid_flushed;

//TODO
assign ifid_stall = 

always @ (posedge clk) begin
    if (~ifid_stall) begin
        ifid_pc <= if_pc;
        ifid_inst <= if_inst;
    end
    ifid_flushed <= if_inst_invalid | ifid_stall;
end

// * IFID PIPES END *

// * DECODE STAGE START *

//decode stage output
//TODO: add more necessary wires
wire [3:0] id_rs1_addr;
wire [3:0] id_rs2_addr;
wire [1:0] id_bd_addr;
wire [15:0] id_rs1_data;
wire [15:0] id_rs2_data;
wire [1535:0] id_bd_data;

//decode stage
dec_stage dec_stage        (.decin(instout_d), .decout(decout));


// * DECODE STAGE END *

// * IDEXE PIPES START *
reg [15:0] idexe_stall;

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

reg idexe_wr_reg;
reg idexe_wr_breg;

reg idexe_comp_acc_activate;
reg idexe_match_acc_activate;

reg idexe_rs1_used;
reg idexe_rs2_used;
reg idexe_bs_used;

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

//TODO: stall & flushed logic
assign idexe_stall = 

//TODO: more flip flop stuff, should be literally just conneccting shit to shit
always @ (posedge clk) begin
    if (idexe_stall) begin
        if ((idexe_rs1_addr == wb_rd_addr & wb_wr_reg) idexe_rs1_data <= wb_rd_data;
    end
    else begin   
        if ((id_rs1_addr == wb_rd_addr) & wb_wr_reg) idexe_rs1_data <= wb_rd_data;
        else idexe_rs1_data <= id_rs1_data;
    end

    if (idexe_stall) begin
        if ((idexe_rs2_addr == wb_rd_addr & wb_wr_reg) idexe_rs2_data <= wb_rd_data;
    end
    else begin   
        if ((id_rs2_addr == wb_rd_addr) & wb_wr_reg) idexe_rs2_data <= wb_rd_data;
        else idexe_rs2_data <= id_rs2_data;
    end

    if (idexe_stall) begin
        if ((idexe_bs_addr == wb_bd_addr & wb_wr_reg) idexe_bs_data <= wb_bd_data;
    end
    else begin   
        if ((id_bs_addr == wb_bd_addr) & wb_wr_reg) idexe_bs_data <= wb_bd_data;
        else idexe_bs_data <= id_bs_data;
    end
end
// * IDEXE PIPES END *

// * EXE STAGE START

//exe stage outputs
reg [15:0] exe_rs1_data;
reg [15:0] exe_rs2_data;
reg [1535:0] exe_bs_data;

wire [15:0] exe_rd_data;
wire [1535:0] exe_bd_data;

//wiring + forwarding
assign exe_rs1_data = (idexe_rs1_addr == exewb_rd_addr) & exewb_wr_reg ? wb_rd_data : idexe_rs1_data; 
assign exe_rs2_data = (idexe_rs2_addr == exewb_rd_addr) & exewb_wr_reg ? wb_rd_data : idexe_rs2_data; 
assign exe_bs_data = (idexe_bs_addr == exewb_bd_addr) & exewb_wr_breg ? wb_bd_data : idexe_bs_data;

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

mem_interface normalmem (.wraddress(exe_rd_data), .rdaddress(exe_rd_data), .wren(exe_write_nreg), .data(exe_rs1_data), .q(exewb_nmem_read_data), .clock(clk));
mem_interface bitmapmem (.wraddress(exe_rd_data), .rdaddress(exe_rd_data), .wren(exe_write_breg), .data(exe_bs_data), .q(exewb_bmem_read_data), .clock(clk));

// * MEMORY STUFF END *

// * EXEWB PIPES START
reg exewb_stall;

wire [15:0] exewb_nmem_read_data; //written directly from memory and not a pipe
wire [1535:0] exewb_bmem_read_data; //written directly from memory and not a pipe

reg exewb_wr_reg;
reg exewb_mem_reg;
reg exewb_alu_breg;
reg exewb_wr_breg;

reg [15:0] exewb_rd_data;
reg [1535:0] exewb_bd_data;

reg [3:0] exewb_rd_addr;
reg [1:0] exewb_bd_addr;

reg exewb_flushed;

//TODO
assign exewb_stall

always @(posedge clk) begin
    exewb_wr_reg <= idexe_wr_reg;
    exewb_mem_reg <= idexe_ld;
    exewb_wr_breg <= idexe_wr_breg;
    exewb_mem_breg <= idexe_ldb;

    exewb_rd_data <= exe_rd_data;
    exewb_bd_data <= exe_bd_data;

    exewb_rd_addr <= idexe_rd_addr;
    exewb_bd_addr <= idexe_bd_addr;    
end

// * EXEWB PIPES END

// * WB STAGE START *
reg [3:0] wb_rd_addr;
reg [15:0] wb_rd_data;
reg wb_wr_reg;
reg [1:0] wb_bd_addr;
reg [1535:0] wb_bd_data;
reg wb_wr_breg;

assign wb_rd_addr = exewb_rd_addr;
assign wb_rd_data = exewb_mem_reg ? exewb_nmem_read_data : exewb_rd_data;
assign wb_bd_addr = exewb_bd_addr;
assign wb_bd_data = exewb_mem_breg ? exewb_bmem_read_data : exewb_bd_data;
assign wb_wr_reg = exewb_wr_reg;
assign wb_wr_breg = exewb_wr_breg;

// * WB STAGE END *

end
