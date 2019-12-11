module inst_stage(clk, rst_n, stall, branch_pc, branch_to_new, pc, inst, inst_invalid);

input wire clk;
input wire rst_n;
input wire stall;
input wire [15:0] branch_pc;
input wire branch_to_new;

output wire [15:0] pc;
output wire [15:0] inst;
output wire inst_invalid;

reg [15:0] last_pc;
wire [15:0] fetch_pc;
wire [15:0] read_inst;

reg [15:0] last_inst;
reg [15:0] pre_fetch;
reg last_pc_branched;

reg rst_cycle;


//prefetching (sort of) 
assign fetch_pc = rst_cycle ? 16'd0 : (
            branch_to_new ? branch_pc : ( 
            stall ? last_pc : 
            last_pc + 1));
//actual pc
assign pc = last_pc;

always @(posedge clk, negedge rst_n) begin
    if(~rst_n) rst_cycle = 1;
    else rst_cycle = 0;
end

//store the last pc that was fetched (the "prefetch")
always @(posedge clk) last_pc <= fetch_pc;

//I'm pretty sure this part is wrong
//store the last inst that was fetched (the "prefetch")
//always @ (posedge clk, negedge rst_n) begin
//    if (~rst) begin
//        last_inst <= 16'd0;
//    end
//    else begin
//        last_inst <= read_inst;
//    end
//end

//actual inst
assign inst_invalid = branch_to_new | rst_cycle; 
assign inst = read_inst;

//inst mem
/*
modelsim_I_mem inst_mem(.wraddress(16'd0), .rdaddress(fetch_pc), .wren(1'b0), .data(16'd0), .q(read_inst), .clock(clk));
/**/
/**/
I_mem I_mem (
	.address(fetch_pc),
	.clock(clk),
	.data(16'd0),
	.wren(1'b0),
	.q(read_inst)
	);
/**/	
	
endmodule
