module cmpalu(output [3:0] LEDR, input clk, input start, input [63:0] bitcolumn, input [23:0] bitrowtop, input [23:0] bitrowbot, input nextrowtopready, input nextrowbotready, input nextcolumnready, input lastcolumn, output [12:0] result, output done, output nextcolumn, output nextrowtop, output nextrowbot, output lastrowbot, output lastrowtop);

//Takes in slices of a 64x24 bitmap and determines how far it should be shifted left and down, and whether or not it should be scaled by 2x

//output signals
reg rowbotchecked;
reg rowtopchecked;
reg colchecked;

reg finished;
assign done = finished;

//send the next row/column when current one has been checked
assign nextrowtop = rowtopchecked;
assign nextrowbot = rowbotchecked;
assign nextcolumn = colchecked;

//[4:0] = lshift
//[10:5] = dshift
//[11] = scale 2x horizontal
//[12] = scale 2x vertical
reg [12:0] res;
assign result = res;

//input
//bitmap staging
reg [63:0] currcol;
reg [23:0] currrowtop;
reg [23:0] currrowbot;

//number of empty columns and rows
reg [4:0] emptycolumns;
reg [5:0] emptyrows;
reg [5:0] emptyrowsupper;
reg [5:0] emptyrowslower;

//booleans


//1 indicates that the boundary has been found
reg lboundaryfound;
reg topboundaryfound;
reg botboundaryfound;

assign lastrowbot = botboundaryfound;
assign lastrowtop = topboundaryfound;

//1 indicates that the boundary has been stored in the result
reg lboundarystored;
reg topboundarystored;
reg botboundarystored;

//[0] is the calculation for left columns
//[1] is the calculation for bot rows
//[2] is the calculation for horizontal scaling
//[3] is the calculation for vertical scaling
reg [3:0] calcdone;

//Row check logic
//checks from top to bot
//and bot to top


//finds empty rows on top
always @(posedge clk) begin

/*
    casez ({rowtopchecked, currrowtop})
        //check each row only once
        //checkrow, rowempty
        {1'b0,24'h00} : begin
                        emptyrowsupper <= emptyrowsupper + 1'b1;
                        rowtopchecked <= 1'b1;  
						topboundaryfound <= topboundaryfound;
                        end

        //don't cares if we shouldn't check row
        {1'b1, 24'h??} : begin
						 emptyrowsupper <= emptyrowsupper;
						 rowtopchecked <= rowtopchecked;
						 topboundaryfound <= topboundaryfound;
						 end
		

        //checkrow, row not empty
        default :   begin
                    emptyrowsupper <= emptyrowsupper;
                    topboundaryfound <= 1'b1;
                    rowtopchecked <= 1'b1;
                    end
    endcase
*/

//finds empty rows on bot
/*
    casez ({rowbotchecked, currrowbot})
        //check each row only once
        //checkrow, rowempty
        {1'b0,24'h00} : begin
                        emptyrowslower <= emptyrowslower + 1'b1;
                        rowbotchecked <= 1'b1;
						botboundaryfound <= botboundaryfound;
                        end

        //don't cares if we shouldn't check row
        {1'b1, 24'h??} : begin
						emptyrowslower <= emptyrowslower;
						rowbotchecked <= rowbotchecked;
						botboundaryfound <= botboundaryfound;
						end

        //checkrow, row not empty
        default :   begin
                    emptyrowslower <= emptyrowslower;
                    botboundaryfound <= 1'b1;
                    rowbotchecked <= 1'b1;
                    end
    endcase
*/
	if (rowbotchecked == 1'b0 && currrowbot == 24'b0) begin
		emptyrowslower <= emptyrowslower + 1'b1;
		rowbotchecked <= 1'b1;
	end
	else if (rowbotchecked == 1'b0 && currrowbot != 64'b0) begin
		emptyrowslower <= emptyrowslower;
		rowbotchecked <= 1'b1;
		botboundaryfound <= 1'b1;
	end 
	
	if (rowtopchecked == 1'b0 && currrowtop == 24'b0) begin
		emptyrowsupper <= emptyrowsupper + 1'b1;
		rowbotchecked <= 1'b1;
	end
	else if (rowtopchecked == 1'b0 && currrowtop != 64'b0) begin
		emptyrowsupper <= emptyrowsupper;
		rowtopchecked <= 1'b1;
		topboundaryfound <= 1'b1;
	end 
//row store logic
    
    //store number of empty rows top
    case ({topboundaryfound, topboundarystored})
        2'b10 : begin
                emptyrows <= emptyrows + emptyrowsupper;
                topboundarystored <= 1'b1;
                end
        default: begin
				//emptyrows <= emptyrows;
				//topboundarystored <= topboundarystored;
				end
    endcase

    //store number of empty rows bot
    case ({botboundaryfound, botboundarystored})
        2'b10 : begin
                emptyrows <= emptyrows + emptyrowslower;
                res [10:5] <= emptyrowslower;
                calcdone[1] <= 1'b1;
                botboundarystored <= 1'b1;
                end 
        default : 	begin
					//emptyrows <= emptyrows;
					//res [10:5] <= res[10:5];
					calcdone[1] <= calcdone[1];
					//botboundarystored <= botboundarystored;
					end
    endcase

    case ({topboundarystored, botboundarystored, emptyrows[5]})
        //row calcs done, check if num empty rows >= 32
        3'b111 :    begin
                    res [12] <= 1'b1;
                    calcdone[3] <= 1'b1;
                    end
        3'b110 :    begin
                    res [12] <= 1'b0;
                    calcdone[3] <= 1'b1;
                    end
        default:    begin
					res[12] <= res[12];
					calcdone[3] <= calcdone[3];
					end
    endcase

//Column check logic

    case ({lboundaryfound, lboundarystored})
    //store lshift in result once first boundary has been found
        2'b10 :  begin
                res [4:0] <= emptycolumns;
                calcdone [0] <= 1'b1;
				lboundarystored <= 1'b1;
                end
        default : 	begin
					//res[4:0] <= res[4:0];
					calcdone[0] <= calcdone[0];
					end
    endcase
/*
    case ({lastcolumn, emptycolumns[4]})
        //last column, 12 or greater empty columns
        //presently checks for 16 or greater, update later
        2'b11 :    begin 
                    res [11] <= 1'b1;
                    calcdone [1] <= 1'b1;
                    end
        2'b10 :     begin
                    res [11] <= 1'b0;
                    calcdone [1] <= 1'b1;
                    end
        default : 	begin
					calcdone[1] <= calcdone[1];
					//res[11] <= res[11];
					end
    endcase
*/	
	if (lastcolumn == 1'b1 && emptycolumns > 11) begin
		res [11] <= 1'b1;
        calcdone [2] <= 1'b1;
        end
	else if (lastcolumn == 1'b1 && emptycolumns  < 12) begin
		res [11] <= 1'b0;
        calcdone [2] <= 1'b1;
        end
	else begin
		calcdone[2] <= calcdone[2];
	end

/*
    casez ({colchecked, currcol})
        //check each column only once
        //checkcolumn, column empty
        65'h00000 : begin
                    emptycolumns <= emptycolumns + 1'b1;
                    colchecked <= 1'b1;
					lboundaryfound <= lboundaryfound;
                    end

        //don't cares if column has been checked
        65'h1????:  begin
                    emptycolumns <= emptycolumns;
					colchecked <= colchecked;
					lboundaryfound <= lboundaryfound;
                    end

        //checkcolumn, column not empty
        default :   begin
                    emptycolumns <= emptycolumns;
                    colchecked <= 1'b1;
                    lboundaryfound <= 1'b1;
                    end
    endcase
*/
	if (colchecked == 1'b0 && currcol == 64'b0) begin
		emptycolumns <= emptycolumns + 1'b1;
		colchecked <= 1'b1;
	end
	else if (colchecked == 1'b0 && currcol != 64'b0) begin
		emptycolumns <= emptycolumns;
		colchecked <= 1'b1;
		lboundaryfound <= 1'b1;
	end
	

//move current row and column into reg banks

    //next column
    case (nextcolumnready)
        1'b1  : begin
                currcol <= bitcolumn;
                colchecked <= 1'b0;
                end
        default: begin
				currcol <= currcol;
				//colchecked <= colchecked;
				end
    endcase  

    //nexttoprow
    case (nextrowtopready)
        1'b1  : begin
                currrowtop <= bitrowtop;
                rowtopchecked <= 1'b0;
                end
        default: 	begin
					currrowtop <= currrowtop;
					//rowtopchecked <= rowtopchecked;
					end
    endcase

    //nextbotrow
    case (nextrowbotready)
        1'b1  : begin
                currrowbot <= bitrowbot;
                rowbotchecked <= 1'b0;
                end
        default: 	begin
					currrowbot <= currrowbot;
					//rowbotchecked <= rowbotchecked;
					end
    endcase  

    //once all 4 calcs are done, send finish signal
    case (calcdone)
        4'b1111 : finished <= 1'b1; 
        default : finished <= 1'b0;
    endcase

    //reset alu on start
    if (start == 1'b1) begin
                emptycolumns <= 5'b0;
                emptyrows <= 6'b0;
				colchecked <= 1'b1;
				rowbotchecked <= 1'b1;
				rowtopchecked <= 1'b1;
                emptyrowsupper <= 6'b0;
                emptyrowslower <= 6'b0;
                lboundaryfound <= 1'b0;
                lboundarystored <= 1'b0;
                topboundaryfound <= 1'b0;
                botboundaryfound <= 1'b0;
                topboundarystored <= 1'b0;
                botboundarystored <= 1'b0;
                res <= 13'h0000;
				calcdone<= 4'b0;
                end
					 
end

endmodule
        