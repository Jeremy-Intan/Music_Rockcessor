module cmpalu(input clk, input start, input [1535:0] bitmap, output [15:0] lshift, output [15:0] dshift, output [15:0] hscale, output [15:0] vscale, output done, output lshiftdone, output dshiftdone, output hscaledone, output vscaledone);
//alu temp file


wire [3:0] calcdone;
wire lshiftfinish;
wire dshiftfinish;
wire hscalefinish;
wire vscalefinish;


always @(posedge clk)  begin
    case (wren)
        1'b1  : bitmap = data;
        default: bitmap = bitmap;
    endcase   
end

always @(posedge clk) begin
    case (calcdone)
        4'b1111 : done = 1'b1; 
        default : done = 1'b0;
    endcase
end

end
        