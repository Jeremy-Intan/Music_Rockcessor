module bmpreg(input clk, input wren, input [1535:0] data, output [1535:0] dataout);
//bmpreg takes in a 24x64 bitmap and stores it in a register. 


reg bitmap [1535:0];
assign dataout = bitmap;


always @(posedge clk)  begin
    case (wren)
      1'b1  : bitmap = data;
        default: bitmap = bitmap;
    endcase   
end

end
        


