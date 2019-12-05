//not an actual module, all memory module should have this interface (input and output)
//wr_enable enables the write, read is always enabled
//reset is asynch active low
//all read and writes are assumed to be 1 cycle latency, so no ready bit needed
module mem_interface(wraddress, rdaddress, wren, data, q, clock);

parameter width=16; //the bit width

input wire [15:0] wraddress;
input wire [15:0] rdaddress;
input wire wren;
input wire [width-1:0] data;
input clock;
input aclr;
output reg [width-1:0] q;

endmodule
