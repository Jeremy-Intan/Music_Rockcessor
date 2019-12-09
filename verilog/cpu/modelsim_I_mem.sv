module modelsim_I_mem (wraddress, rdaddress, wren, data, q, clock);
reg [16-1:0] ram [2**16-1:0];

input clock;
input wire [15:0] wraddress;
input wire [15:0] rdaddress;
reg [15:0] rdaddress_reg;
input wire wren;
input wire [15:0] data;
output reg [15:0] q;

initial begin
    $readmemb("program.mem", ram);
end

always @(posedge clock) begin
    if (wren) ram[wraddress] <= data;
    rdaddress_reg <= rdaddress;
end
assign q = ram[rdaddress_reg];

endmodule
