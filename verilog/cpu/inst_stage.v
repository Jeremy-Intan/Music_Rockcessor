module inst_stage(clk, rst_n, branch_pc, branch_to_new, pc, inst, inst_valid);

input clk;
input rst_n;
input wire [15:0] branch_pc;
input wire branch_to_new;

output reg [15:0] pc;
output reg [15:0] inst;
output reg inst_valid;

reg [15:0] last_pc;
reg [15:0] fetch_pc;
reg [15:0] read_inst;

reg [15:0] last_inst;
reg [15:0] pre_fetch;
reg last_pc_branched;

reg rst_cycle;

//prefetching (sort of) 
assign fetch_pc = branch_to_new ? branch_pc : ( 
		rst_cycle ? 16'd0 : last_pc + 1);
//actual pc
assign pc = last_pc;

always @(posedge clk, negedge rst_n) begin
    if(~rst) rst_cycle = 1;
    else rst_cycle = 0;
end

//store the last pc that was fetched (the "prefetch")
always @(posedge clk) last_pc <= fetch_pc;

//store the last inst that was fetched (the "prefetch")
always @ (posedge clk, negedge rst_n) begin
    if (~rst) begin
        last_inst <= 16'd0;
    end
    else begin
        last_inst <= read_inst;
    end
end

//actual inst
assign inst_valid = branch_to_new | rst_cycle; 
assign inst = last_inst;

//inst mem
mem_interface inst_mem(.wraddress(16'd0), .rdaddress(fetch_pc), wren(1'b0), .data(16'd0), .q(read_inst), .clock(clk));

endmodule
