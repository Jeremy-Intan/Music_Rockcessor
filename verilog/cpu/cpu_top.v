module cpu_top(clk, rst_n, buttons_pressed, test);
output [15:0] test;
//top level module of the CPU
//butons_pressed are active high here, convert it in the higher level
input wire clk;
input wire rst_n;
input wire [3:0] buttons_pressed;

//B R A N C H B O I S
wire [15:0] cpu_branch_pc;
wire cpu_branch_to_new;

//WB SIGNALS
wire [3:0] wb_rd_addr;
wire [15:0] wb_rd_data;
wire wb_wr_reg;
wire [1:0] wb_bd_addr;
wire [1535:0] wb_bd_data;
wire wb_wr_breg;

//INTERUPPTS
reg cpu_int;
wire exe_int_state;

always @ (posedge clk) begin
    cpu_int <= exe_int_state;
end

//Stall stuff
wire if_stall;
wire ifid_stall;
wire [15:0] idexe_stall;
wire exe_stall;
wire exe_flush_cmd;
wire exewb_stall;

// * INST STAGE START *

//if stage outputs
wire [15:0] if_pc;
wire [15:0] if_inst;
wire if_inst_invalid;

assign if_stall = ifid_stall; 

//inst stage
inst_stage Inst_stage(.clk(clk), .rst_n(rst_n), .stall(if_stall), .branch_pc(cpu_branch_pc), .branch_to_new(cpu_branch_to_new), .pc(if_pc), .inst(if_inst), .inst_invalid(if_inst_invalid));

// * INST STAGE END *

// * IFID PIPES START *

reg [15:0] ifid_pc;
reg [15:0] ifid_inst;
reg [3:0] ifid_int;
reg ifid_flushed;

assign ifid_stall = idexe_stall; 

always @ (posedge clk, negedge rst_n) begin
	 if (~rst_n) begin
	     ifid_pc <= 16'd0;
        ifid_inst <= 16'd0;
    end
    else if (~ifid_stall) begin
        ifid_pc <= if_pc;
        ifid_inst <= if_inst;
    end
    if (~rst_n) ifid_flushed <= 1'b1;
    else if (~ifid_stall) ifid_flushed <= if_inst_invalid;
end

// * IFID PIPES END *

// * DECODE STAGE START *

//decode stage output
wire [2:0] id_pnz;
wire [3:0] id_rs1_addr;
wire [3:0] id_rs2_addr;
wire [3:0] id_rd_addr;
wire [1:0] id_bs_addr;
wire [1:0] id_bd_addr;
wire [15:0] id_rs1_data;
wire [15:0] id_rs2_data;
wire [1535:0] id_bs_data;
wire [15:0] id_lit;
wire id_wr_reg;
wire id_wr_breg;
//not used
//wire id_dmem_write; 
//wire id_dmem_en;
wire id_match_acc_en;
wire id_comp_acc_en;
wire id_br_combined;
wire id_ldst;
wire id_rs1_used;
wire id_rs2_used;
wire id_bs_used;
wire id_nop;
wire id_halt;
wire id_sub;
wire id_add;
wire id_brr;
wire id_br;
wire id_ld;
wire id_st;
wire id_ply;
wire id_mv;
wire id_bsl;
wire id_bsh;
wire id_ret;
wire id_ses;
wire id_stb;
wire id_ldb;

//decode stage
dec_stage Dec_stage(.inst(ifid_inst), .write_reg_addr(wb_rd_addr), .write_reg_data(wb_rd_data), .write_reg_en(wb_wr_reg), .write_bm_addr(wb_bd_addr), .write_bm_data(wb_bd_data), .write_bm_en(wb_wr_breg), .clk(clk),
					.PNZ(id_pnz), .se16(id_lit), .regAddr1(id_rs1_addr), .regAddr2(id_rs2_addr), .regAddrDest(id_rd_addr), .rd_data_1(id_rs1_data), .rd_data_2(id_rs2_data), .rbm_data(id_bs_data), .reg_write(id_wr_reg), .BMAddr(id_bs_addr), .bm_write(id_wr_breg), .write_bm_addr_out(id_bd_addr), .DMemWrite(), .DMemEn(), .MatchAcc(id_match_acc_en), .CompAcc(id_comp_acc_en), .ALUBR(id_br_combined), .ALULdSt(id_ldst), .rs1_used(id_rs1_used), .rs2_used(id_rs2_used), .bs_used(id_bs_used),
					.NOP(id_nop), .HALT(id_halt), .SUB(id_sub), .ADD(id_add), .BRR(id_brr), .BR(id_br), .LD(id_ld), .ST(id_st), .PLY(id_ply), .MV(id_mv), .BSL(id_bsl), .BSH(id_bsh), .RET(id_ret), .SES(id_ses), .STB(id_stb), .LDB(id_ldb),.test(test));

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

assign idexe_stall = exe_stall;

always @ (posedge clk, negedge rst_n) begin
    if (~rst_n) begin
	     idexe_rs1_data = 16'd0;
	 end
    else if (idexe_stall) begin
        if ((idexe_rs1_addr == wb_rd_addr) & wb_wr_reg) idexe_rs1_data <= wb_rd_data;
    end
    else begin   
        if ((id_rs1_addr == wb_rd_addr) & wb_wr_reg) idexe_rs1_data <= wb_rd_data;
        else idexe_rs1_data <= id_rs1_data;
    end

	 if (~rst_n) begin
	     idexe_rs2_data = 16'd0;
	 end
    else if (idexe_stall) begin
        if ((idexe_rs2_addr == wb_rd_addr) & wb_wr_reg) idexe_rs2_data <= wb_rd_data;
    end
    else begin   
        if ((id_rs2_addr == wb_rd_addr) & wb_wr_reg) idexe_rs2_data <= wb_rd_data;
        else idexe_rs2_data <= id_rs2_data;
    end

	 if (~rst_n) begin
	     idexe_bs_data = 1536'd0;
	 end
    else if (idexe_stall) begin
        if ((idexe_bs_addr == wb_bd_addr) & wb_wr_reg) idexe_bs_data <= wb_bd_data;
    end
    else begin   
        if ((id_bs_addr == wb_bd_addr) & wb_wr_reg) idexe_bs_data <= wb_bd_data;
        else idexe_bs_data <= id_bs_data;
    end

	 if (~rst_n) begin
	     idexe_pc <= 0;

        idexe_rs1_addr <= 0;
        idexe_rs2_addr <= 0;
        idexe_rd_addr <= 0;
        idexe_bs_addr <= 0;
        idexe_bd_addr <= 0;

        idexe_lit <= 0;

        idexe_br_combined <= 0;
        idexe_pnz <= 0;
        idexe_ldst <= 0;

        idexe_wr_reg <= 0;
        idexe_wr_breg <= 0;

        idexe_comp_acc_activate <= 0;
        idexe_match_acc_activate <= 0;

        idexe_rs1_used <= 0;
        idexe_rs2_used <= 0;
        idexe_bs_used <= 0;

        idexe_ldb <= 0;
        idexe_stb <= 0;
        idexe_ses <= 0;
        idexe_ret <= 0;
        idexe_bsh <= 0;
        idexe_bsl <= 0;
        idexe_mv <= 0;
        idexe_ply <= 0;
        idexe_st <= 0;
        idexe_ld <= 0;
        idexe_br <= 0;
        idexe_brr <= 0;
        idexe_add <= 0;
        idexe_sub <= 0;
        idexe_halt <= 0;
        idexe_nop <= 0;
    end
    else if (~idexe_stall) begin        
        idexe_pc <= ifid_pc;

        idexe_rs1_addr <= id_rs1_addr;
        idexe_rs2_addr <= id_rs2_addr;
        idexe_rd_addr <= id_rd_addr;
        idexe_bs_addr <= id_bs_addr;
        idexe_bd_addr <= id_bd_addr;

        idexe_lit <= id_lit;

        idexe_br_combined <= id_br_combined;
        idexe_pnz <= id_pnz;
        idexe_ldst <= id_ldst;

        idexe_wr_reg <= id_wr_reg;
        idexe_wr_breg <= id_wr_breg;

        idexe_comp_acc_activate <= id_comp_acc_en;
        idexe_match_acc_activate <= id_match_acc_en;

        idexe_rs1_used <= id_rs1_used;
        idexe_rs2_used <= id_rs2_used;
        idexe_bs_used <= id_bs_used;

        idexe_ldb <= id_ldb;
        idexe_stb <= id_stb;
        idexe_ses <= id_ses;
        idexe_ret <= id_ret;
        idexe_bsh <= id_bsh;
        idexe_bsl <= id_bsl;
        idexe_mv <= id_mv;
        idexe_ply <= id_ply;
        idexe_st <= id_st;
        idexe_ld <= id_ld;
        idexe_br <= id_br;
        idexe_brr <= id_brr;
        idexe_add <= id_add;
        idexe_sub <= id_sub;
        idexe_halt <= id_halt;
        idexe_nop <= id_nop;
    end

    if (~rst_n) idexe_flushed <= 1'b1;
    else if ((|buttons_pressed) & ~cpu_int) idexe_flushed <= 1'b1;
    else if (~idexe_stall) idexe_flushed <= ifid_flushed;
end
// * IDEXE PIPES END *

// * EXE STAGE START
wire exe_br_combined;
wire exe_save_addr;
wire exe_ret;
wire exe_write_nreg;
wire exe_write_breg;
wire exe_int;

assign exe_int = ((|buttons_pressed) & ~cpu_int);

//Flushing and stalling
//flush for every branch
assign exe_flush_cmd = cpu_branch_to_new;
//for now no stalling, but needed for later
assign exe_stall = 1'b0;

assign exe_br_combined = idexe_br_combined & ~idexe_flushed & ~exe_int;
assign exe_save_addr = idexe_brr & ~idexe_flushed & ~exe_int;
assign exe_ret = idexe_ret & ~idexe_flushed & ~exe_int;
assign exe_write_nreg = idexe_st & ~idexe_flushed & ~exe_int;
assign exe_write_breg = idexe_stb & ~idexe_flushed & ~exe_int;

//exe stage outputs
wire [15:0] exe_rs1_data;
wire [15:0] exe_rs2_data;
wire [1535:0] exe_bs_data;
wire [15:0] exe_noint_branch_pc;
wire exe_noint_branch_taken;

wire [15:0] exe_rd_data;
wire [1535:0] exe_bd_data;

//wiring + forwarding
assign exe_rs1_data = (idexe_rs1_addr == wb_rd_addr) & wb_wr_reg ? wb_rd_data : idexe_rs1_data; 
assign exe_rs2_data = (idexe_rs2_addr == wb_rd_addr) & wb_wr_reg ? wb_rd_data : idexe_rs2_data; 
assign exe_bs_data = (idexe_bs_addr == wb_bd_addr) & wb_wr_breg ? wb_bd_data : idexe_bs_data;

//exe stage
assign cpu_branch_pc = buttons_pressed[3] & ~cpu_int ? 16'h0f80 : (
                       buttons_pressed[2] & ~cpu_int ? 16'h0fa0 : (
                       buttons_pressed[1] & ~cpu_int ? 16'h0fc0 : (
                       buttons_pressed[0] & ~cpu_int ? 16'h0fe0 : 
                       exe_noint_branch_pc )));
assign cpu_branch_to_new =  exe_int | (exe_noint_branch_taken & ~idexe_flushed);

exe_stage Exe_stage(.clk(clk),
                    .rst_n(rst_n),
                    .pc(idexe_pc),
                    .rs1_data(exe_rs1_data),
                    .rs2_data(exe_rs2_data),
                    .bs_data(exe_bs_data),
                    .ldst(idexe_ldst),
                    .lit(idexe_lit),
                    .add(idexe_add),
                    .sub(idexe_sub),
                    .br(exe_br_combined),
                    .mv(idexe_mv),
                    .bsh(idexe_bsh),
                    .bsl(idexe_bsl),
                    .save_addr(exe_save_addr),
                    .int_in(exe_int),
                    .ret(exe_ret),
                    .int_state(cpu_int),
                    .pnz_in(idexe_pnz),
                    .branch_addr(exe_noint_branch_pc),
                    .branch_taken(exe_noint_branch_taken),
                    .rd_data(exe_rd_data),
                    .bd_data(exe_bd_data),
                    .int_state_out(exe_int_state));
// * EXE STAGE END *

// for both exe and wb
// * MEMORY STUFF START *
wire [15:0] exewb_nmem_read_data; //written directly from memory and not a pipe
wire [1535:0] exewb_bmem_read_data; //written directly from memory and not a pipe
//modelsim_N_mem normalmem (.wraddress(exe_rd_data), .rdaddress(exe_rd_data), .wren(exe_write_nreg), .data(exe_rs2_data), .q(exewb_nmem_read_data), .clock(clk));

//modelsim_B_mem bitmapmem (.wraddress(exe_rd_data), .rdaddress(exe_rd_data), .wren(exe_write_breg), .data(exe_bs_data), .q(exewb_bmem_read_data), .clock(clk));


bitmap_mem bitmap_mem (
	.address(exe_rd_data[2:0]),
	.clock(clk),
	.data(exe_bs_data),
	.wren(exe_write_breg),
	.q(exewb_bmem_read_data)
	);
	
D_mem D_mem (
	.address(exe_rd_data[9:0]),
	.clock(clk),
	.data(exe_rs2_data),
	.wren(exe_write_nreg),
	.q(exewb_nmem_read_data)
	);
	
	
	
// * MEMORY STUFF END *

// * EXEWB PIPES START
//Part of memory now to avoid errors
//wire [15:0] exewb_nmem_read_data; //written directly from memory and not a pipe
//wire [1535:0] exewb_bmem_read_data; //written directly from memory and not a pipe

reg exewb_wr_reg;
reg exewb_mem_reg;
reg exewb_wr_breg;
reg exewb_mem_breg;

reg [15:0] exewb_rd_data;
reg [1535:0] exewb_bd_data;

reg [3:0] exewb_rd_addr;
reg [1:0] exewb_bd_addr;

reg exewb_flushed;

//I don't think last stage stall
assign exewb_stall = 1'b0;

always @(posedge clk, negedge rst_n) begin
    if(~rst_n) begin
        exewb_wr_reg <= 0;
        exewb_mem_reg <= 0;
        exewb_wr_breg <= 0;
        exewb_mem_breg <= 0;

        exewb_rd_data <= 0;
        exewb_bd_data <= 0;

        exewb_rd_addr <= 0;
        exewb_bd_addr <= 0;
    end
    else if(~exewb_stall) begin
        exewb_wr_reg <= idexe_wr_reg;
        exewb_mem_reg <= idexe_ld;
        exewb_wr_breg <= idexe_wr_breg;
        exewb_mem_breg <= idexe_ldb;

        exewb_rd_data <= exe_rd_data;
        exewb_bd_data <= exe_bd_data;

        exewb_rd_addr <= idexe_rd_addr;
        exewb_bd_addr <= idexe_bd_addr;
    end
    
    if (~rst_n) exewb_flushed <= 1'b1;
    else if (~exewb_stall) exewb_flushed <= ((|buttons_pressed) & ~cpu_int) | idexe_flushed;
end

// * EXEWB PIPES END

// * WB STAGE START *

assign wb_rd_addr = exewb_rd_addr;
assign wb_rd_data = exewb_mem_reg ? exewb_nmem_read_data : exewb_rd_data;
assign wb_bd_addr = exewb_bd_addr;
assign wb_bd_data = exewb_mem_breg ? exewb_bmem_read_data : exewb_bd_data;
assign wb_wr_reg = exewb_wr_reg & ~exewb_flushed;
assign wb_wr_breg = exewb_wr_breg & ~exewb_flushed;

// * WB STAGE END *

endmodule
