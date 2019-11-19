module bmpreg(input clk, input wren, input [1535:0] data, output [1535:0] dataout, output alustart);
//bmpreg takes in a 24x64 bitmap and stores it in a register. 


reg bitmap [1535:0];
reg ready;
assign dataout = bitmap;
assign alustart = ready;

always @(posedge clk)  begin
    case (wren)
        1'b1 : bitmap = data;
        default : bitmap = bitmap;
    endcase   
end

always @(posedge clk)  begin
    case (wren)
        1'b1 : ready = 1'b1;
        default : ready = 1'b0;
    endcase   
end

end
        


