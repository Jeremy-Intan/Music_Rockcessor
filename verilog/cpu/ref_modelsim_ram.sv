module RAM_1 (
 input data,
 input [9:0] addr,
 input we, clk,
 output q);
 // Declare the RAM variable
 reg [1-1:0] ram[2**10-1:0];
 // Variable to hold the registered read address
 reg [10-1:0] addr_reg;

 initial begin
 	$readmemh("ram_input_contents_sample_1.txt", ram);
 end

 always @ (posedge clk)
 begin
 if (we) // Write
 ram[addr] <= data;
 addr_reg <= addr;
 end
 assign q = ram[addr_reg];

endmodule
