module noteMux (tinymap, sel);

input [2:0] sel;
output [255:0] tinymap;

wire [255:0] A,B,C,D,E,F,G;

assign A = {4'hF,56'h0,4'hF,60'h0,4'hF,60'h0,4'hF,4'h0,52'hFFFFFFFFFFFFF,4'h0,4'hF};
assign B = {4'hF,56'h0,4'hF,60'h0,4'hF,36'h0,52'hFFFFFFFFFFFFF,36'h0,4'hF};
assign C = {4'hF,56'h0,4'hF,60'h0,4'hF,4'h0,52'hFFFFFFFFFFFFF,4'h0,4'hF,60'h0,4'hF};
assign D = {4'hF,56'h0,4'hF,36'h0,52'hFFFFFFFFFFFFF,36'h0,4'hF,60'h0,4'hF};
assign E = {4'hF,56'h0,4'hF,4'h0,52'hFFFFFFFFFFFFF,4'h0,4'hF,60'h0,4'hF,60'h0,4'hF};
assign F = {4'hF,32'h0,52'hFFFFFFFFFFFFF,36'h0,4'hF,60'h0,4'hF,60'h0,4'hF};
assign G = {4'hF,4'h0,48'hFFFFFFFFFFFF,4'h0,4'hF,60'h0,4'hF,60'h0,4'hF,60'h0,4'hF};

assign tinymap = (sel == 3'b000) ? A : (sel == 3'b001) ? B : (sel == 3'b010) ? C : (sel == 3'b011) ? D : 
					(sel == 3'b100) ? E : (sel == 3'b101) ? F : G;
					

endmodule