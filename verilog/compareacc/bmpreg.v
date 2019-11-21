module bmpreg(input clk, input wren, input [1535:0] data, input nextcol, input nextrow, output [63:0] columnout, output [23:0] rowout, output alustart, output rowready, output colready);
//bmpreg takes in a 24x64 bitmap and stores it in a register. It then sends it slice by slice to the ALU


reg [23:0] [63:0] bitmap;
reg ready;

reg [4:0] colcount;
reg [5:0] rowcount;
reg nextcolready;
reg nextrowready;

assign rowready = nextrowready;
assign colready = nextcolready;
assign dataout = bitmap;
assign alustart = ready;


//increments column counter, and selects the next column slice to send to ALU
always @(posedge clk, posedge nextcol) begin
    case (nextcol)
        1'b1 :begin
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

//increments row counter, and selects the next row slice to send to ALU
always @(posedge clk, posedge nextrow) begin
    case (nextrow)
        1'b1 :begin
              rowcount = rowcount + 1;
              rowout = bmp [23:0] [rowcount];
              nextrowready = 1'b1;
              end
        default :begin
                rowcount = rowcount;
                nextrowready = 1'b0;
                end
    endcase
end

//writes default values when a bitmap is passed in
always @(posedge clk)  begin
    case (wren)
        1'b1:   begin
                bitmap <= data;
                colcount <= 5'b0;
                rowcount <= 6'b0;
                alustart <= 1'b1;
                end
        default: begin
                bitmap <= bitmap;
                alustart <= 1'b0;
                end
    
end



end
        


