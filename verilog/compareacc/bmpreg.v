module bmpreg(input clk, input wren, input [1535:0] bmpin, input nextcol, input nextrowbot, input nextrowtop, output [63:0] columnout, output [23:0] botrowout, output [23:0] toprowout, output alustart, output rowtopready, output rowbotready, output colready, output finalcolumn);

//bmpreg takes in a 24x64 bitmap and stores it in a register. It then sends it slice by slice to the ALU


//bitmap is stored in register
//bitrows and bitcolumns are buses from the bitmap register
//assigned slice by slice
reg  [1535:0] data;
wire [23:0] bitrows [63:0];
wire [63:0] bitcolumns[23:0];



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
				data <= bmpin;
                colcount <= 6'b0;
                ready <= 1'b1; 
                botrowcount <= 7'b0;
                toprowcount <= 7'h3f;
                end
        default: begin
				data <= data;
                ready <= 1'b0;
                end
	endcase
    
end

//temp solution, data not stored in reg, so must be accurate in CPU
generate
					genvar rowindex;
					genvar colindex;
					genvar colrow;
						for (rowindex = 0; rowindex < 64; rowindex = rowindex + 1) begin
							assign bitrows [rowindex] = data [(((rowindex + 1) * 24) - 1) : (rowindex * 24)];
						end 
						
						for (colindex = 0; colindex < 24; colindex = colindex + 1) begin
							assign bitcolumns [colindex] = {data[colindex], data[colindex + 24], data[colindex + 48], data[colindex + 72], data[colindex + 96], data[colindex + 120], data[colindex + 144], data[colindex + 168], data[colindex + 192], data[colindex + 216], data[colindex + 240], data[colindex + 264], data[colindex + 288], data[colindex + 312], data[colindex + 336], data[colindex + 360], data[colindex + 384], data[colindex + 408], data[colindex + 432], data[colindex + 456], data[colindex + 480], data[colindex + 504], data[colindex + 528], data[colindex + 552], data[colindex + 576], data[colindex + 600], data[colindex + 624], data[colindex + 648], data[colindex + 672], data[colindex + 696], data[colindex + 720], data[colindex + 744], data[colindex + 768], data[colindex + 792], data[colindex + 816], data[colindex + 840], data[colindex + 864], data[colindex + 888], data[colindex + 912], data[colindex + 936], data[colindex + 960], data[colindex + 984], data[colindex + 1008], data[colindex + 1032], data[colindex + 1056], data[colindex + 1080], data[colindex + 1104], data[colindex + 1128], data[colindex + 1152], data[colindex + 1176], data[colindex + 1200], data[colindex + 1224], data[colindex + 1248], data[colindex + 1272], data[colindex + 1296], data[colindex + 1320], data[colindex + 1344], data[colindex + 1368], data[colindex + 1392], data[colindex + 1416], data[colindex + 1440], data[colindex + 1464], data[colindex + 1488], data[colindex + 1512]};
						end
endgenerate


endmodule
