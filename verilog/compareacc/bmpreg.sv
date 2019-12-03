module bmpreg(input clk, input wren, input [1535:0] data, input nextcol, input nextrowbot, input nextrowtop, output [63:0] columnout, output [23:0] botrowout, output [23:0] toprowout, output alustart, output rowtopready, output rowbotready, output colready, output finalcolumn);

//bmpreg takes in a 24x64 bitmap and stores it in a register. It then sends it slice by slice to the ALU


//double check ordering
reg [63:0] [23:0] bitrows;
reg [23:0] [63:0] bitcolumns;

reg [5:0] colcount;
reg [5:0] botrowcount;
reg [5:0] toprowcount;

//port declarations
reg lastcolumn;
reg ready;
reg nextcolready;
reg nextrowtopready;
reg nextrowbotready;
reg [63:0] currcolumn;
reg [23:0] currrowtop;
reg [23:0] currrowbot;

//port assignments
assign finalcolumn = lastcolumn;
assign colready = nextcolready;
assign rowtopready = nextrowtopready;
assign rowbotready = nextrowbotready;
assign alustart = ready;
assign columnout = currcolumn;
assign toprowout = currrowtop;
assign botrowout = currrowbot;

//is this the last column?
always @(posedge clk) begin
        case (colcount)
            6'd24 : lastcolumn <= 1'b1;
            default : lastcolumn <= 1'b0;
        endcase
      
end

//increments column counter, and selects the next column slice to send to ALU
always @(posedge clk, posedge nextcol) begin
    case ({nextcol, lastcolumn})
        2'b10 :begin
              currcolumn = bitcolumns [colcount];
              colcount = colcount + 1;
              nextcolready = 1'b1;
              end
        default :begin
                colcount = colcount;
                nextcolready = 1'b0;
                end
    endcase
end

//increments top row counter, and selects the next row slice to send to ALU
always @(posedge clk, posedge nextrowtop) begin
    case (nextrowtop)
        2'b10 :begin
              currrowtop = bitrows [toprowcount];
              toprowcount = toprowcount - 1;
              nextrowtopready = 1'b1;
              end
        default :begin
                toprowcount = toprowcount;
                nextrowtopready = 1'b0;
                end
    endcase
end

//increments bot row counter, and selects the next row slice to send to ALU
always @(posedge clk, posedge nextrowbot) begin
    case (nextrowbot)
        2'b10 :begin
              currrowbot = bitrows [botrowcount];
              botrowcount = botrowcount + 1;
              nextrowbotready = 1'b1;
              end
        default :begin
                botrowcount = botrowcount;
                nextrowbotready = 1'b0;
                end
    endcase
end

//writes default values when a bitmap is passed in
always @(posedge clk)  begin
    case (wren)
        1'b1:   begin
                bitrows <= data;
				bitcolumns <= data;
                colcount <= 6'b0;
                ready <= 1'b1; 
                botrowcount <= 7'b0;
                toprowcount <= 7'h3f;
                end
        default: begin
                bitrows <= bitrows;
		bitcolumns <= bitcolumns;
                ready <= 1'b0;
                end
	endcase
    
end

endmodule
