module cmpalu(input clk, input start, input [63:0] bitcolumn, input [23:0] bitrow, input nextrowready, input nextcolumnready, output [15:0] result, output done, output nextcolumn, output nextrow);




reg [3:0] calcdone;
reg finished;
assign done = finished;

wire columndone;
wire toprowdone;
wire botrowdone;

reg [63:0] currcol;
reg [23:0] currrowtop;
reg [23:0] currrowbot;

//[4:0] = lshift
//[10:5] = dshift
//[11] = scale 2x horizontal
//[12] = scale 2x vertical
reg [15:0] res;

//number of empty columns and rows
reg [4:0] emptycolumns;
reg [5:0] emptyrows;
reg [5:0] emptyrowsupper;
reg [5:0] emptyrowslower;


//should we check the next column or row?
reg checkcol;
reg checkrowtop;
reg checkrowbot;
reg lboundaryfound;
reg topboundaryfound;
reg botboundaryfound;
reg lboundarystored;
reg topboundarystored;
reg botboundarystored;


//Row check logic
//checks from top to bot
//and bot to top

//finds empty rows on top
always @(posedge clk) begin
    casez ({checkrowtop, currrowtop})
        //check each row only once
        //checkrow, rowempty
        {1'b1,24'h00} : begin
                        emptyrowsupper <= emptyrowsupper + 1;
                        checkrowtop <= 1'b0;
                        end

        //don't cares if we shouldn't check row
        {1'b1, 24'h??} : emptyrowsupper <= emptyrowsupper;

        //checkrow, row not empty
        default :   begin
                    emptyrowsupper <= emptyrowsupper;
                    topboundaryfound <= 1'b1;
                    checkrowtop <= 1'b0;
                    end
    endcase
end

//finds empty rows on bot
always @(posedge clk) begin
    casez ({checkrowbot, currrowbot})
        //check each row only once
        //checkrow, rowempty
        {1'b1,24'h00} : begin
                        emptyrowslower <= emptyrowlower + 1;
                        checkrowbot <= 1'b0;
                        end

        //don't cares if we shouldn't check row
        {1'b1, 24'h??} : emptyrowslower <= emptyrowslower;

        //checkrow, row not empty
        default :   begin
                    emptyrowslower <= emptyrowslower;
                    botboundaryfound <= 1'b1;
                    checkrowbot <= 1'b0;
                    end
    endcase
end

//row store logic
always @(posedge clk) begin
    
    //store number of empty rows top
    case ({topboundaryfound, topboundarystored})
        2'b10 : begin
                emptyrows <= emptyrows + emptyrowsupper;
                topboundarystored <= 1'b1;
                end
        default: emptyrows <= emptyrows;
    endcase

    //store number of empty rows bot
    case ({botboundaryfound, botboundarystored})
        2'b10 : begin
                emptyrows <= emptyrows + emptyrowslower;
                result [10:5] <= emptyrowslower;
                calcdone[2] <= 1'b1;
                botboundarystored <= 1'b1;
                end 
        default : emptyrows <= emptyrows;
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
        default:    res[12] <= res[12];
    endcase
end

//Column check logic
always @(posedge clk) begin
    case ({lboundaryfound, lboundarystored})
    //store lshift in result once first boundary has been found
        2'b10 :  begin
                res [5:0] <= emptycolumns;
                calc [0] <= 1'b1;
                end
        default : emptycolumns <= emptycolumns;
    endcase

    case ({lastcolumn, emptycolumns[4]})
        //last column, 12 or greater empty columns
        //presently checks for 16 or greater, update later
        2'b11 :    begin 
                    res [11] <= 1'b1;
                    calc [1] <= 1'b1;
                    end
        2'b10 :     begin
                    res [11] <= 1'b0;
                    calc [1] <= 1'b1;
                    end
        default : calc[1] <= calc[1];
    endcase
end

always @(posedge clk) begin

    casez ({checkcol, currcol})
        //check each column only once
        //checkcolumn, column empty
        65'h10000 : begin
                    emptycolumns <= emptycolumns + 1;
                    checkcol <= 1'b0;
                    columndone <= 1'b1;
                    send
                    end

        //don't cares if column has been checked
        65'h0????:  begin
                    emptycolumns <= emptycolumns;
                    end

        //checkcolumn, column not empty
        default :   begin
                    emptycolumns <= emptycolumns;
                    checkcol <= 1'b0;
                    lboundaryfound <= 1'b1;
                    columndone <= 1'b1;
                    end
    endcase
end


//move current row and column into reg banks
always @(posedge clk)  begin
    //next column
    case (nextcolumnready)
        1'b1  : begin
                currcol <= bitcolumn;
                checkcol <= 1'b1;
                end
        default: currcol <= currcol;
    endcase  

    //nexttoprow
    case (nextrowtopready)
        1'b1  : currrowtop <= bitrowtop;
        default: currrowtop <= currrowtop;
    endcase

    //nextbotrow
    case (nextrowbotready)
        1'b1  : currrowbot <= bitrowbot;
        default: currrowbot <= currrowbot;
    endcase  
end

//once all 4 calcs are done, send finish signal
always @(posedge clk) begin
    case (calcdone)
        4'b1111 : finished <= 1'b1; 
        default : finished <= 1'b0;
    endcase
end

always @(posedge clk) begin
    case (alustart)
        1'b1 : begin
                emptycolumns <= 5'b0;
                emptyrows <= 6'b0;
                emptyrowsupper <= 6'b0;
                emptyrowlower <= 6'b0;
                lboundaryfound <= 1'b0;
                lboundarystored <= 1'b0;
                topboundaryfound <= 1'b0;
                botboundaryfound <= 1'b0;
                topboundarystored <= 1'b0;
                botboundarystored <= 1'b0;
                res <= 16'h0;
                end
        default : finished <= 1'b0;
    endcase
end

end
        