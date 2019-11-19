module cmpacc(input clk, input wren, input [1535:0] bitmap, output [15:0] lshift, output [15:0] dshift, output [15:0] hscale, output [15:0] vscale), output done;


//bmp reg to alu
wire [1535:0] bmpmove;
wire alustart;

//alu to res storage
wire [15:0] lshiftmove;
wire [15:0] dshiftmove;
wire [15:0] hscalemove;
wire [15:0] vscalemove;

//output
wire finished;
wire lshiftdone;
wire dshiftdone;
wire hscaledone;
wire vscaledone;
wire [15:0] lshiftres;
wire [15:0] dshiftres;
wire [15:0] hscaleres;
wire [15:0] vscaleres;

assign done = finished;
assign lshiftres = lshift;
assign dshiftres = dshift;
assign hscaleres = hscale;
assign vscaleres = vscale;

//module instantiation

bmpreg bmpreg(.clk(clk), .wren(wren), .data(bitmap), .dataout(bmpmove), .alustart(alustart));

cmpalu alu(.clk(clk), .start(alustart), .bitmap(bmpmove), .lshift(lshiftmove), .dshift(dshiftmove), .hscale(hscalemove), .vscale(vscalemove), .done(finished), .lshiftdone(lshiftdone), .dshiftdone(dshiftdone), .hscaledone(hscaledone), .vscaledone(vscaledone));

resreg lshiftreg(.clk(clk), .wren(lshiftdone), .data(lshiftmove), .resout(.lshiftres));
resreg dshiftreg(.clk(clk), .wren(dshiftdone), .data(dshiftmove), .resout(.dshiftres));
resreg hscalereg(.clk(clk), .wren(hscaledone), .data(hscalemove), .resout(.hscaleres));
resreg vscalereg(.clk(clk), .wren(vscaledone), .data(vscalemove), .resout(.vscaleres));

end