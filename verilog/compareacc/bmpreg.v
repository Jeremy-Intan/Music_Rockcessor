module bmpreg(input clk, input wren, input [1535:0] data, input nextcol, input nextrowbot, input nextrowtop, output [63:0] columnout, output [23:0] rowout, output alustart, output rowtopready, output rowbotready, output colready, output lastcolumn);
//bmpreg takes in a 24x64 bitmap and stores it in a register. It then sends it slice by slice to the ALU


reg [23:0] [63:0] bitmap;
reg ready;

reg [4:0] colcount;
reg [5:0] botrowcount;
reg [5:0] toprowcount;
reg nextcolready;
reg nextrowtopready;
reg nextrowbotready;
reg lastcolumn;

assign rowtopready = nextrowtopready;
assign rowbotready = nextrowbotready;
assign colready = nextcolready;
assign dataout = bitmap;
assign alustart = ready;

//is this the last row or column?
always @(posedge clk) begin
        case (colcount)
            5'd23 : lastcolumn <= 1'b1;
            default : lastcolumn <= 1'b0;
        endcase
        case (botrowcount)
            6'd63: lastrowbot <= 1'b1;
            default: lastrowbot <= 1'b0;
        endcase
        case (toprowcount)
            6'd00: lastrowtop <= 1'b1;
            default: lastrowtop <= 1'b0;
        endcase
end


//increments column counter, and selects the next column slice to send to ALU
always @(posedge clk, posedge nextcol) begin
    case ({nextcol, lastcolumn})
        2'b10 :begin
              colcount = colcount + 1;
              columnout = bmp [colcount] [63:0];
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
    case ({nextrowtop, lastrow})
        2'b10 :begin
              toprowcount = toprowcount - 1;
              toprowout = bmp [23:0] [toprowcount];
              nextrowtopready = 1'b1;
              end
        default :begin
                toprowcount = toprowcount;
                nextrowtopready = 1'b0;
                end
    endcase
end

//increments row counter, and selects the next row slice to send to ALU
always @(posedge clk, posedge nextrowbot) begin
    case ({nextrowbot, lastrow})
        2'b10 :begin
              botrowcount = botrowcount + 1;
              botrowout = bmp [23:0] [botrowcount];
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
                bitmap <= data;
                colcount <= 5'b0;
                alustart <= 1'b1; 
                botrowcount <= 6'b0;
                toprowcount <= 6'h3f;
                end
        default: begin
                bitmap <= bitmap;
                alustart <= 1'b0;
                end
    
end



end
        


