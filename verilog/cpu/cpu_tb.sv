module cpu_tb ();

reg clk, rst_n;
reg [3:0] buttons;
wire test;

cpu_top iDUT(.clk(clk), .rst_n(rst_n), .buttons_pressed(buttons),.test(test));

initial begin
clk = 0;
rst_n = 0;
buttons = 0;
@(posedge clk);
@(negedge clk);
rst_n = 1;
for(int i = 0; i < 90; i++) begin
    @(posedge clk);
    @(negedge clk);
    if(iDUT.wb_wr_reg == 1) $display("write %d to register %d", iDUT.wb_rd_data, iDUT.wb_rd_addr);
    if(iDUT.wb_wr_breg == 1) $display("write %d to register %d", iDUT.wb_bd_data, iDUT.wb_bd_addr);
end
$stop;

end

always begin
#2 clk = ~clk;
end

endmodule
