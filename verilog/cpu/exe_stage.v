module exe_stage(pc, rs1_data, rs2_data, bs_data, lit, add, sub, br, mv, bsh, bsl, save_addr, int, ret, int_state, pnz_in, branch_addr, branch_taken, rd_data, bd_data, int_state_out);


input wire [15:0] pc;
input wire [15:0] rs1_data;
input wire [15:0] rs2_data
input wire [1535:0] bs_data;
input wire [15:0] lit;
input wire add;
input wire sub;
input wire mv;
input wire bsh;
input wire bsl;
input wire br;
input wire save_addr;
input wire int;
input wire ret;
input wire int_state;
input wire pnz_in;
//input wire ld;
//input wire st;
//input wire ldb;
//input wire stb; //just wire this correctly zulul
output reg [15:0] branch_addr;
output reg branch_taken;
//for mem address (both bitmap and normal) and register
output reg [15:0] rd_data;
output reg [1535:0] bd_data;
output reg int_state_out;
//probably not needed here as well
//input wire [3:0] rd_addr
//input wire [1:0] bd_addr;
//forwarding, not needed here maybe?
//input wire [3:0] rs1_addr;
//input wire [3:0] rs2_addr;
//input wire [1:0] bs_addr;
//output reg [3:0] rs1_addr_out;
//output reg [3:0] rs2_addr_out;
//output reg [1:0] bs_addr_out;

reg [2:0] pnz_reg;
wire [15:0] ras_top;

wire [2:0] pnz_out;
wire [15:0] alu_output;
wire [1535:0] alu_bmo;


// * pc stuff here *

// A bit of interrupt stuff
reg [15:0] int_pc_reg;

//int reg
always @ (posedge clk) begin
    if (int) int_pc_reg <= pc;
end

assign int_state_out = (~int_state & int) | (int_state & ~ret);

//pnz flag
always @(posedge clk) begin
    if (add & sub) 
        pnz_reg <= pnz_new;
    else
        pnz_reg <= pnz_reg;
end

assign branch_addr = ret & int_state ? int_pc_reg : (
                     ret & ~int_state ? ras_top : alu_output);
assign branch_taken = (br & ((pnz_in & pnz_reg) != 0)) | ret;   
ras ras (.push(save_addr), .new_data(pc + 1), .pop(ret), .top_of_stack(ras_top), .err());

// * end pc stuff *

// * OUTPUT STUFF HERE *

assign rd_data = mv ? lit : alu_output;
assign bd_data = alu_bmo;

// * OUTPUT STUFF END *

//the ALU
ALU alu(.pc(pc),
        .rs1(rs1_data),
        .rs2(rs2_data),
        .val(lit),
        .bmr(bs_data),
        .add(add),
        .sub(sub),
        .br(br),
        .ldst(ldst),
        .shift(bsh),
        .scale(bsl),
        .pnz(pnz_out),
        .alu_output(alu_output),
        .alu_bmo(alu_bmo));

endmodule
