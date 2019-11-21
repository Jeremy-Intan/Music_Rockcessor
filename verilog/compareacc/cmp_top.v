module cmpacc(input clk, input wren, input [1535:0] bitmap, output [15:0] result, output done);


//bmp reg to alu
wire alustart;
wire colready;
wire rowready;
wire [63:0] columnout;
wire [23:0] rowout;

//alu to bmp reg
wire nextcol;
wire nextrow


//alu to res storage
wire [15:0] calc;


//output
wire finished;

wire [15:0] res;


assign done = finished;
assign res = result;


//module instantiation

bmpreg bmpreg(.clk(clk), .wren(wren), .data(bitmap), .nextcol(nextcol), .nextrow(nextrow), .columnout(columnout), .rowout(rowout), .alustart(alustart), .rowready(rowready), .colready(colready));

cmpalu alu(.clk(clk), start(alustart), .bitcolumn(columnout), .bitrow(rowout), .result, output done, output nextcolumn, output nextrow);

resreg resultreg(.clk(clk), .wren(lshiftdone), .data(lshiftmove), .resout(.lshiftres));


end