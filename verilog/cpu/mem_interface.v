//not an actual module, all memory module should have this interface (input and output)
parameter width=16; //the bit width
//wr_enable enables the write, read is always enabled
//reset is asynch active low
module mem_interface(write_addr, read_addr, wr_enable, wr_data, rd_data, clk, rst_n);

input wire [15:0] wr_addr;
input wire [15:0] rd_addr;
input wire wr_enable;
input wire [width-1:0] wr_data;
input clk;
input rst_n;
output reg [width-1:0] rd_data;

endmodule
