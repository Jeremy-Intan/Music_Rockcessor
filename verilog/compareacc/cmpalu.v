module cmpalu(input clk, input start, input [63:0] bitcolumn, input [23:0] bitrow, input nextrowready, input nextcolumnready, output [15:0] result, output done, output nextcolumn, output nextrow);


//NOT SYNTHESIZABLE YET


wire [3:0] calcdone;
reg finished;
assign done = finished;


reg [63:0] currcol;
reg [23:0] currrow;

reg [15:0] res;


//lshift
reg lboundaryfound;
reg [4:0] lshifttotal;
always @(posedge clk) begin
    case (lboundaryfound)
    //store lshift in result once first boundary has been found
        1'b1 : res [4:0] <= lshifttotal;
        default : lshifttotal <= lshifttotal;
    endcase

end

always @(posedge clk)  begin
    case (nextcolumnready)
        1'b1  : currcol <= bitcolumn;
        default: currcol <= currcol;
    endcase   
end

always @(posedge clk)  begin
    case (nextrowready)
        1'b1  : currrow <= bitrow;
        default: currrow <= currrow;
    endcase   
end

always @(posedge clk) begin
    case (calcdone)
        4'b1111 : finished <= 1'b1; 
        default : finished <= 1'b0;
    endcase
end

always @(posedge clk) begin
    case (alustart)
        1'b1 : begin
                lshifttotal <= 5'b0;
                dshifttotal <= 6'b0;
                end
        default : finished <= 1'b0;
    endcase
end

end
        