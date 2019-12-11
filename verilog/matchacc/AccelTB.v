module AccelTB();

reg clk, start;
reg [1535:0] bmr;
wire finish;
wire [15:0] noteReg, lengthReg;

MatchAccelerator MatchAccelerator(.clk(clk),.bmr(bmr),.noteReg(noteReg),.lengthReg(lengthReg),.start(start),.finish(finish));

initial begin
	clk = 1'b0;
	start = 1'b0;
	//bmr = {24'hFFFFFF,336'h0,24'hFFFFFF,360'h0,24'hFFFFFF,360'h0,24'hFFFFFF,32'h0,8'hFF,13'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,18'h3FFFF,5'h0,20'hFFFFF,3'h0,22'h3FFFFF,2'h0,22'h3FFFFF,2'h0,22'h3FFFFF,3'h0,20'hFFFFF,5'h0,18'h3FFFF,7'h0,16'hFFFF,9'h0,14'h3FFF,13'h0,8'hFF,32'h0,24'hFFFFF};//A
	//bmr = {24'hFFFFFF,336'h0,24'hFFFFFF,360'h0,24'hFFFFFF,32'h0,8'hFF,13'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,18'h3FFFF,5'h0,20'hFFFFF,3'h0,22'h3FFFFF,2'h0,22'h3FFFFF,2'h0,22'h3FFFFF,3'h0,20'hFFFFF,5'h0,18'h3FFFF,7'h0,16'hFFFF,9'h0,14'h3FFF,13'h0,8'hFF,32'h0,24'hFFFFFF,360'h0,24'hFFFFF};//C
	//bmr = {24'hFFFFFF,336'h0,24'hFFFFFF,32'h0,8'hFF,13'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,18'h3FFFF,5'h0,20'hFFFFF,3'h0,22'h3FFFFF,2'h0,22'h3FFFFF,2'h0,22'h3FFFFF,3'h0,20'hFFFFF,5'h0,18'h3FFFF,7'h0,16'hFFFF,9'h0,14'h3FFF,13'h0,8'hFF,32'h0,24'hFFFFFF,360'h0,24'hFFFFFF,360'h0,24'hFFFFF};//E
	//bmr = {24'hFFFFFF,30'h0,12'hFFF,11'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,18'h3FFFF,5'h0,20'hFFFFF,3'h0,22'h3FFFFF,2'h0,22'h3FFFFF,2'h0,22'h3FFFFF,3'h0,20'hFFFFF,5'h0,18'h3FFFF,7'h0,16'hFFFF,9'h0,14'h3FFF,29'h0,24'hFFFFFF,360'h0,24'hFFFFFF,360'h0,24'hFFFFFF,360'h0,24'hFFFFF};//G
	//bmr = {24'hFFFFFF,336'h0,24'hFFFFFF,360'h0,24'hFFFFFF,224'h0,8'hFF,13'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,18'h3FFFF,5'h0,20'hFFFFF,3'h0,22'h3FFFFF,1'h0,24'hFFFFFF,1'h0,22'h3FFFFF,3'h0,20'hFFFFF,5'h0,18'h3FFFF,7'h0,16'hFFFF,9'h0,14'h3FFF,13'h0,8'hFF,224'h0,24'hFFFFF};//B
	//bmr = {24'hFFFFFF,336'h0,24'hFFFFFF,224'h0,8'hFF,13'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,18'h3FFFF,5'h0,20'hFFFFF,3'h0,22'h3FFFFF,1'h0,24'hFFFFFF,1'h0,22'h3FFFFF,3'h0,20'hFFFFF,5'h0,18'h3FFFF,7'h0,16'hFFFF,9'h0,14'h3FFF,13'h0,8'hFF,224'h0,24'hFFFFFF,360'h0,24'hFFFFF};//D
	bmr = {24'hFFFFFF,200'h0,8'hFF,13'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,18'h3FFFF,5'h0,20'hFFFFF,3'h0,22'h3FFFFF,1'h0,24'hFFFFFF,1'h0,22'h3FFFFF,3'h0,20'hFFFFF,5'h0,18'h3FFFF,7'h0,16'hFFFF,9'h0,14'h3FFF,13'h0,8'hFF,224'h0,24'hFFFFFF,360'h0,24'hFFFFFF,360'h0,24'hFFFFF};//F
	
	//bmr <= {24'hFFFFFF,336'h0,24'hFFFFFF,360'h0,24'hFFFFFF,360'h0,24'hFFFFFF,32'h0,8'hFF,13'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,5'h1F,8'h0,5'h1F,5'h0,4'hF,12'h0,4'hF,3'h0,4'hF,14'h0,4'hF,2'h0,3'h7,16'h0,3'h7,2'h,4'hF,14'h0,4'hF,3'h0,4'hF,12'h0,4'hF,5'h0,5'h1F,8'h0,5'h1F,7'h0,16'hFFFF,9'h0,14'h3FFF,13'h0,8'hFF,32'h0,24'hFFFFF};//A half
	//bmr <= {24'hFFFFFF,336'h0,24'hFFFFFF,360'h0,24'hFFFFFF,32'h0,8'hFF,13'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,5'h1F,8'h0,5'h1F,5'h0,4'hF,12'h0,4'hF,3'h0,4'hF,14'h0,4'hF,2'h0,3'h7,16'h0,3'h7,2'h,4'hF,14'h0,4'hF,3'h0,4'hF,12'h0,4'hF,5'h0,5'h1F,8'h0,5'h1F,7'h0,16'hFFFF,9'h0,14'h3FFF,13'h0,8'hFF,32'h0,24'hFFFFFF,360'h0,24'hFFFFF};//C half
	//bmr <= {24'hFFFFFF,336'h0,24'hFFFFFF,32'h0,8'hFF,13'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,5'h1F,8'h0,5'h1F,5'h0,4'hF,12'h0,4'hF,3'h0,4'hF,14'h0,4'hF,2'h0,3'h7,16'h0,3'h7,2'h,4'hF,14'h0,4'hF,3'h0,4'hF,12'h0,4'hF,5'h0,5'h1F,8'h0,5'h1F,7'h0,16'hFFFF,9'h0,14'h3FFF,13'h0,8'hFF,32'h0,24'hFFFFFF,360'h0,24'hFFFFFF,360'h0,24'hFFFFF};//E half
	//bmr <= {24'hFFFFFF,30'h0,12'hFFF,11'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,5'h1F,8'h0,5'h1F,5'h0,4'hF,12'h0,4'hF,3'h0,4'hF,14'h0,4'hF,2'h0,3'h7,16'h0,3'h7,2'h,4'hF,14'h0,4'hF,3'h0,4'hF,12'h0,4'hF,5'h0,5'h1F,8'h0,5'h1F,7'h0,16'hFFFF,9'h0,14'h3FFF,29'h0,24'hFFFFFF,360'h0,24'hFFFFFF,360'h0,24'hFFFFFF,360'h0,24'hFFFFF};//G half
	//bmr <= {24'hFFFFFF,336'h0,24'hFFFFFF,360'h0,24'hFFFFFF,224'h0,8'hFF,13'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,5'h1F,8'h0,5'h1F,5'h0,4'hF,12'h0,4'hF,3'h0,4'hF,14'h0,4'hF,1'h0,4'hF,16'h0,4'hF,1'h0,4'hF,14'h0,4'hF,3'h0,4'hF,12'h0,4'hF,5'h0,5'h1F,8'h0,5'h1F,7'h0,16'hFFFF,9'h0,14'h3FFF,13'h0,8'hFF,224'h0,24'hFFFFF};//B half
	//bmr <= {24'hFFFFFF,336'h0,24'hFFFFFF,224'h0,8'hFF,13'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,5'h1F,8'h0,5'h1F,5'h0,4'hF,12'h0,4'hF,3'h0,4'hF,14'h0,4'hF,1'h0,4'hF,16'h0,4'hF,1'h0,4'hF,14'h0,4'hF,3'h0,4'hF,12'h0,4'hF,5'h0,5'h1F,8'h0,5'h1F,7'h0,16'hFFFF,9'h0,14'h3FFF,13'h0,8'hFF,224'h0,24'hFFFFFF,360'h0,24'hFFFFF};//D half
	//bmr <= {24'hFFFFFF,200'h0,8'hFF,13'h0,14'h3FFF,9'h0,16'hFFFF,7'h0,5'h1F,8'h0,5'h1F,5'h0,4'hF,12'h0,4'hF,3'h0,4'hF,14'h0,4'hF,1'h0,4'hF,16'h0,4'hF,1'h0,4'hF,14'h0,4'hF,3'h0,4'hF,12'h0,4'hF,5'h0,5'h1F,8'h0,5'h1F,7'h0,16'hFFFF,9'h0,14'h3FFF,13'h0,8'hFF,224'h0,24'hFFFFFF,360'h0,24'hFFFFFF,360'h0,24'hFFFFF};//F half
	
	#100
	
	start = 1'b1;
	#15
	start = 1'b0;
	
	@(posedge finish)
	@(negedge finish)
	$stop;
end

always begin
	#10 clk <= ~clk;
end


endmodule