module lengthMux (tinymap, sel);

input sel;
output [255:0] tinymap;

wire [255:0] Whole, Half, Quarter;

assign Quarter = {20'h0,8'hFF,5'h0,14'h3FFF,1'h0,144'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
				1'h0,14'h3FFF,5'h0,8'hFF,20'h0,16'hFFFF};
				
assign Half = {20'h0,8'hFF,5'h0,14'h3FFF,1'h0,20'hFFFFF,8'h0,6'h3F,12'h0,2'h3,48'hFFFFFFFFFFFF,
				2'h3,12'h0,6'h3F,8'h0,20'hFFFFF,1'h0,14'h3FFF,5'h0,8'hFF,20'h0,16'hFFFF};
				
//assign Whole =

assign tinymap = sel ?  Half : Quarter;
					

endmodule