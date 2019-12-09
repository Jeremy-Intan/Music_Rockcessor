module cmpacc_tb;




//test variables
reg [15:0] counter;
reg clk, wren;
reg [1535:0] bitmap;
reg res_correct;


//dut outputs
wire [12:0] result;
wire done;

cmpacc dut(.clk(clk), .wren(wren), .bitmap(bitmap), .result(result), .done(done));


initial begin
	clk = 0;
	wren = 0;
	bitmap = 0;
	counter = 0;
	res_correct = 0;
	
	@(negedge clk);
	@(negedge clk);
	
	//should have two empty rows on left and bottom
	bitmap = 
	{
	24'h000000, 
	24'h000000,  
	24'h000000,  
	24'h000000,  
	24'h000000,  
	24'h000000, 
	24'h000000, 
	24'h000000,  
	24'h000000,  
	24'h000000,
	24'h000000, 
	24'h000000, 
	24'h000000, 
	24'h000000,
	24'h000000,
	24'h000000, 
	24'h000000, 
	24'h000000, 
	24'h000000, 
	24'h000000, 
	24'h000000, 
	24'h000000, 
	24'h000000, 
	24'h000000, 
	24'h000000, 
	24'h000000, 
	24'h000000, 
	24'h000000, 
	24'h000000, 
	24'h000000, 
	24'h000000, 
	24'h000000, 
	24'h000000, 
	24'h000000, 
	24'h000000, 
	24'h3f0000, 
	24'h3f0000, 
	24'h3f0000, 
	24'h3f0000, 
	24'h3f0000, 
	24'h3f0000, 
	24'h3f0000, 
	24'h3f0000, 
	24'h3f0000, 
	24'h3f0000, 
	24'h3f0000, 
	24'h3f0000, 
	24'h3f0000, 
	24'h3f0000, 
	24'h3f0000, 
	24'h3f0000, 
	24'h3f0000, 
	24'h3f0000, 
	24'h3f0000, 
	24'h3f0000, 
	24'h3f0000, 
	24'h3f0000, 
	24'h3f0000, 
	24'h3f0000, 
	24'h3f0000, 
	24'h3f0000, 
	24'h000000,
	24'h000000};
	
	@(negedge clk);
	wren = 1'b1;
	
	@(negedge clk);
	wren = 1'b0;
	
	@(negedge clk);
	while (counter < 1000) begin
		if (result[11] == 1 && result [12] == 1 && result[4:0] == 5'b00010 && result[10:5] == 6'b00010 && done == 1) begin
			res_correct = 1;
			break;
		end
		counter = counter + 1;
		@(negedge clk);
	end
	
	if (res_correct == 1) begin
		$display("result correct");
	end
	
	if (res_correct == 0) begin
		$display("wrong");
	end
	$stop;
end

always #10 clk = ~clk;


endmodule