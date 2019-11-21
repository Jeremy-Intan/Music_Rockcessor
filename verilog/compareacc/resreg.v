module resreg(input clk, input wren, input [15:0] data, output [15:0] resout);
//resreg stores the 16 bit result from the compare unit.


reg result [15:0];
assign resout = result;

always @(posedge clk)  begin
    case (wren)
        1'b1 : result <= data;
        default : result <= result;
    endcase   
end



end