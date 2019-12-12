module cmpacc(input clk, input wren, input [1535:0] bitmap, output [12:0] result, output done);


//bmp reg to alu
wire alustart;
wire colready;
wire rowtopready;
wire rowbotready;
wire finalcolumn;
wire finalrowtop;
wire finalrowbot;
wire [63:0] columnout;
wire [23:0] toprowout;
wire [23:0] botrowout;

//alu to bmp reg
wire nextcol;
wire nextrowbot;
wire nextrowtop;



//module instantiation

bmpreg bitmapreg(.clk(clk), .wren(wren), .bmpin(bitmap), .nextcol(nextcol), .lastrowtop(finalrowtop), .lastrowbot(finalrowbot), .nextrowbot(nextrowbot), .nextrowtop(nextrowtop), .columnout(columnout), .toprowout(toprowout), .botrowout(botrowout), .alustart(alustart), .rowbotready(rowbotready), .rowtopready(rowtopready), .colready(colready), .finalcolumn(finalcolumn));

cmpalu alu(.clk(clk), .start(alustart), .bitcolumn(columnout), .lastrowbot(finalrowbot), .lastrowtop(finalrowtop), .bitrowbot(botrowout), .bitrowtop(toprowout), .nextrowtopready(rowtopready), .nextrowbotready(rowbotready), .nextcolumnready(colready), .lastcolumn(finalcolumn), .result(result), .done(done), .nextcolumn(nextcol), .nextrowtop(nextrowtop), .nextrowbot(nextrowbot));

endmodule