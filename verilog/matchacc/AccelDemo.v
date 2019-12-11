module AccelTB();

reg clk, start, rst;
reg [1535:0] bmr;
wire finish;
wire [15:0] noteReg, lengthReg;

MatchAccelerator MatchAccelerator(.rst(rst),.clk(clk),.bmr(bmr),.noteReg(noteReg),.lengthReg(lengthReg),.start(start),.finish(finish));

initial begin
	clk = 1'b0;
	rst = 1'b0;
	#10 rst = 1'b1;
	start = 1'b0;
	bmr = {24'hFFFFFF,336'h0,24'hFFFFFF,360'h0,24'hFFFFFF,360'h0,24'hFFFFFF,32'h0,8'hFF,13'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,18'h3FFFF,5'h0,20'hFFFFF,3'h0,22'h3FFFFF,2'h0,22'h3FFFFF,2'h0,22'h3FFFFF,3'h0,20'hFFFFF,5'h0,18'h3FFFF,7'h0,16'hFFFF,9'h0,14'h3FFF,13'h0,8'hFF,32'h0,24'hFFFFF};//A
	
	#100
	start = 1'b1;
	#15
	start = 1'b0;
	@(posedge finish)
	@(negedge finish)
	#100
	
	bmr = {24'hFFFFFF,336'h0,24'hFFFFFF,360'h0,24'hFFFFFF,32'h0,8'hFF,13'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,18'h3FFFF,5'h0,20'hFFFFF,3'h0,22'h3FFFFF,2'h0,22'h3FFFFF,2'h0,22'h3FFFFF,3'h0,20'hFFFFF,5'h0,18'h3FFFF,7'h0,16'hFFFF,9'h0,14'h3FFF,13'h0,8'hFF,32'h0,24'hFFFFFF,360'h0,24'hFFFFF};//C
	
	#100
	start = 1'b1;
	#15
	start = 1'b0;
	@(posedge finish)
	@(negedge finish)
	#100
	
	bmr = {24'hFFFFFF,336'h0,24'hFFFFFF,32'h0,8'hFF,13'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,18'h3FFFF,5'h0,20'hFFFFF,3'h0,22'h3FFFFF,2'h0,22'h3FFFFF,2'h0,22'h3FFFFF,3'h0,20'hFFFFF,5'h0,18'h3FFFF,7'h0,16'hFFFF,9'h0,14'h3FFF,13'h0,8'hFF,32'h0,24'hFFFFFF,360'h0,24'hFFFFFF,360'h0,24'hFFFFF};//E
	
	#100
	start = 1'b1;
	#15
	start = 1'b0;
	@(posedge finish)
	@(negedge finish)
	#100
	
	bmr = {24'hFFFFFF,30'h0,12'hFFF,11'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,18'h3FFFF,5'h0,20'hFFFFF,3'h0,22'h3FFFFF,2'h0,22'h3FFFFF,2'h0,22'h3FFFFF,3'h0,20'hFFFFF,5'h0,18'h3FFFF,7'h0,16'hFFFF,9'h0,14'h3FFF,29'h0,24'hFFFFFF,360'h0,24'hFFFFFF,360'h0,24'hFFFFFF,360'h0,24'hFFFFF};//G
	
	#100
	start = 1'b1;
	#15
	start = 1'b0;
	@(posedge finish)
	@(negedge finish)
	#100
	
	bmr = {24'hFFFFFF,336'h0,24'hFFFFFF,360'h0,24'hFFFFFF,224'h0,8'hFF,13'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,18'h3FFFF,5'h0,20'hFFFFF,3'h0,22'h3FFFFF,1'h0,24'hFFFFFF,1'h0,22'h3FFFFF,3'h0,20'hFFFFF,5'h0,18'h3FFFF,7'h0,16'hFFFF,9'h0,14'h3FFF,13'h0,8'hFF,224'h0,24'hFFFFF};//B
	
	#100
	start = 1'b1;
	#15
	start = 1'b0;
	@(posedge finish)
	@(negedge finish)
	#100
	
	bmr = {24'hFFFFFF,336'h0,24'hFFFFFF,224'h0,8'hFF,13'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,18'h3FFFF,5'h0,20'hFFFFF,3'h0,22'h3FFFFF,1'h0,24'hFFFFFF,1'h0,22'h3FFFFF,3'h0,20'hFFFFF,5'h0,18'h3FFFF,7'h0,16'hFFFF,9'h0,14'h3FFF,13'h0,8'hFF,224'h0,24'hFFFFFF,360'h0,24'hFFFFF};//D
	
	#100
	start = 1'b1;
	#15
	start = 1'b0;
	@(posedge finish)
	@(negedge finish)
	#100
	
	bmr = {24'hFFFFFF,200'h0,8'hFF,13'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,18'h3FFFF,5'h0,20'hFFFFF,3'h0,22'h3FFFFF,1'h0,24'hFFFFFF,1'h0,22'h3FFFFF,3'h0,20'hFFFFF,5'h0,18'h3FFFF,7'h0,16'hFFFF,9'h0,14'h3FFF,13'h0,8'hFF,224'h0,24'hFFFFFF,360'h0,24'hFFFFFF,360'h0,24'hFFFFF};//F
	
	#100
	start = 1'b1;
	#15
	start = 1'b0;
	@(posedge finish)
	@(negedge finish)
	#100
	
	bmr = {24'hFFFFFF,336'h0,24'hFFFFFF,360'h0,24'hFFFFFF,360'h0,24'hFFFFFF,32'h0,8'hFF,13'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,5'h1F,8'h0,5'h1F,5'h0,4'hF,12'h0,4'hF,3'h0,4'hF,14'h0,4'hF,2'h0,3'h7,16'h0,3'h7,2'h0,4'hF,14'h0,4'hF,3'h0,4'hF,12'h0,4'hF,5'h0,5'h1F,8'h0,5'h1F,7'h0,16'hFFFF,9'h0,14'h3FFF,13'h0,8'hFF,32'h0,24'hFFFFF};//A half
	
	#100
	start = 1'b1;
	#15
	start = 1'b0;
	@(posedge finish)
	@(negedge finish)
	#100
	
	bmr = {24'hFFFFFF,336'h0,24'hFFFFFF,360'h0,24'hFFFFFF,32'h0,8'hFF,13'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,5'h1F,8'h0,5'h1F,5'h0,4'hF,12'h0,4'hF,3'h0,4'hF,14'h0,4'hF,2'h0,3'h7,16'h0,3'h7,2'h0,4'hF,14'h0,4'hF,3'h0,4'hF,12'h0,4'hF,5'h0,5'h1F,8'h0,5'h1F,7'h0,16'hFFFF,9'h0,14'h3FFF,13'h0,8'hFF,32'h0,24'hFFFFFF,360'h0,24'hFFFFF};//C half
	
	#100
	start = 1'b1;
	#15
	start = 1'b0;
	@(posedge finish)
	@(negedge finish)
	#100
	
	bmr = {24'hFFFFFF,336'h0,24'hFFFFFF,32'h0,8'hFF,13'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,5'h1F,8'h0,5'h1F,5'h0,4'hF,12'h0,4'hF,3'h0,4'hF,14'h0,4'hF,2'h0,3'h7,16'h0,3'h7,2'h0,4'hF,14'h0,4'hF,3'h0,4'hF,12'h0,4'hF,5'h0,5'h1F,8'h0,5'h1F,7'h0,16'hFFFF,9'h0,14'h3FFF,13'h0,8'hFF,32'h0,24'hFFFFFF,360'h0,24'hFFFFFF,360'h0,24'hFFFFF};//E half
	
	#100
	start = 1'b1;
	#15
	start = 1'b0;
	@(posedge finish)
	@(negedge finish)
	#100
	
	bmr = {24'hFFFFFF,30'h0,12'hFFF,11'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,5'h1F,8'h0,5'h1F,5'h0,4'hF,12'h0,4'hF,3'h0,4'hF,14'h0,4'hF,2'h0,3'h7,16'h0,3'h7,2'h0,4'hF,14'h0,4'hF,3'h0,4'hF,12'h0,4'hF,5'h0,5'h1F,8'h0,5'h1F,7'h0,16'hFFFF,9'h0,14'h3FFF,29'h0,24'hFFFFFF,360'h0,24'hFFFFFF,360'h0,24'hFFFFFF,360'h0,24'hFFFFF};//G half
	
	#100
	start = 1'b1;
	#15
	start = 1'b0;
	@(posedge finish)
	@(negedge finish)
	#100
	
	bmr = {24'hFFFFFF,336'h0,24'hFFFFFF,360'h0,24'hFFFFFF,224'h0,8'hFF,13'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,5'h1F,8'h0,5'h1F,5'h0,4'hF,12'h0,4'hF,3'h0,4'hF,14'h0,4'hF,1'h0,4'hF,16'h0,4'hF,1'h0,4'hF,14'h0,4'hF,3'h0,4'hF,12'h0,4'hF,5'h0,5'h1F,8'h0,5'h1F,7'h0,16'hFFFF,9'h0,14'h3FFF,13'h0,8'hFF,224'h0,24'hFFFFF};//B half
	
	#100
	start = 1'b1;
	#15
	start = 1'b0;
	@(posedge finish)
	@(negedge finish)
	#100
	
	bmr = {24'hFFFFFF,336'h0,24'hFFFFFF,224'h0,8'hFF,13'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,5'h1F,8'h0,5'h1F,5'h0,4'hF,12'h0,4'hF,3'h0,4'hF,14'h0,4'hF,1'h0,4'hF,16'h0,4'hF,1'h0,4'hF,14'h0,4'hF,3'h0,4'hF,12'h0,4'hF,5'h0,5'h1F,8'h0,5'h1F,7'h0,16'hFFFF,9'h0,14'h3FFF,13'h0,8'hFF,224'h0,24'hFFFFFF,360'h0,24'hFFFFF};//D half
	
	#100
	start = 1'b1;
	#15
	start = 1'b0;
	@(posedge finish)
	@(negedge finish)
	#100
	
	bmr = {24'hFFFFFF,200'h0,8'hFF,13'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,5'h1F,8'h0,5'h1F,5'h0,4'hF,12'h0,4'hF,3'h0,4'hF,14'h0,4'hF,1'h0,4'hF,16'h0,4'hF,1'h0,4'hF,14'h0,4'hF,3'h0,4'hF,12'h0,4'hF,5'h0,5'h1F,8'h0,5'h1F,7'h0,16'hFFFF,9'h0,14'h3FFF,13'h0,8'hFF,224'h0,24'hFFFFFF,360'h0,24'hFFFFFF,360'h0,24'hFFFFF};//F half
	
	#100
	start = 1'b1;
	#15
	start = 1'b0;
	@(posedge finish)
	@(negedge finish)
	#100
	$stop;
end

always begin
	#10 clk <= ~clk;
end


endmodule