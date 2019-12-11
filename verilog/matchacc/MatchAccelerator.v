module MatchAccelerator(rst,clk,bmr, noteReg, lengthReg, start, finish);

input [1535:0] bmr;
input clk, start, finish, rst;
output reg [15:0] noteReg, lengthReg;

wire [255:0] bmNCMP,tmNCMP,noteXor;
reg StateN, nextStateN;
wire [15:0] noteFreq;
reg noteDone;
reg [7:0] noteSumHold;
reg [2:0] noteCountHold,countN;
wire [7:0] noteAdd;

wire [255:0] bmLCMP,tmLCMP,lengthXor;
reg StateL, nextStateL;
wire [15:0] lengthFreq;
reg lengthDone;
reg [7:0] lengthSumHold;
reg lengthCountHold;
reg [1:0] countL;
wire [7:0] lengthAdd;

noteMux noteMux(.tinymap(tmNCMP),.sel(countN));

assign bmNCMP = {bmr[1525:1522],bmr[1501:1498],bmr[1477:1474],bmr[1453:1450],bmr[1429:1426],bmr[1405:1402],bmr[1381:1378],bmr[1357:1354],
							bmr[1333:1330],bmr[1309:1306],bmr[1285:1282],bmr[1261:1258],bmr[1237:1234],bmr[1213:1210],bmr[1189:1186],bmr[1165:1162],
							bmr[1141:1138],bmr[1117:1114],bmr[1093:1090],bmr[1069:1066],bmr[1045:1042],bmr[1021:1018],bmr[997:994],bmr[973:970],
							bmr[949:946],bmr[925:922],bmr[901:898],bmr[877:874],bmr[853:850],bmr[829:826],bmr[805:802],bmr[781:778],
							bmr[757:754],bmr[743:740],bmr[709:706],bmr[685:682],bmr[661:658],bmr[637:634],bmr[613:610],bmr[589:586],
							bmr[565:562],bmr[541:538],bmr[517:514],bmr[493:490],bmr[469:466],bmr[445:442],bmr[421:418],bmr[397:394],
							bmr[373:370],bmr[349:346],bmr[325:322],bmr[301:298],bmr[277:274],bmr[253:250],bmr[229:226],bmr[205:202],
							bmr[181:178],bmr[157:154],bmr[133:130],bmr[109:106],bmr[85:82],bmr[61:58],bmr[37:34],bmr[13:10]};

assign noteXor = bmNCMP ^ tmNCMP;

assign noteFreq = (noteCountHold == 3'b000) ? 16'h000A : (noteCountHold == 3'b001) ? 16'h000B : (noteCountHold == 3'b010) ? 16'h000C : (noteCountHold == 3'b011) ? 16'h000D : (noteCountHold == 3'b100) ? 16'h000E : (noteCountHold == 3'b101) ? 16'h000F : 16'h0001;

assign noteAdd = noteXor[255]+noteXor[254]+noteXor[253]+noteXor[252]+noteXor[251]+noteXor[250]+noteXor[249]+noteXor[248]+noteXor[247]+noteXor[246]+noteXor[245]+noteXor[244]+noteXor[243]+noteXor[242]+noteXor[241]+noteXor[240]+
				 noteXor[239]+noteXor[238]+noteXor[237]+noteXor[236]+noteXor[235]+noteXor[234]+noteXor[233]+noteXor[232]+noteXor[231]+noteXor[230]+noteXor[229]+noteXor[228]+noteXor[227]+noteXor[226]+noteXor[225]+noteXor[224]+
				 noteXor[223]+noteXor[222]+noteXor[221]+noteXor[220]+noteXor[219]+noteXor[218]+noteXor[217]+noteXor[216]+noteXor[215]+noteXor[214]+noteXor[213]+noteXor[212]+noteXor[211]+noteXor[210]+noteXor[209]+noteXor[208]+
				 noteXor[207]+noteXor[206]+noteXor[205]+noteXor[204]+noteXor[203]+noteXor[202]+noteXor[201]+noteXor[200]+noteXor[199]+noteXor[198]+noteXor[197]+noteXor[196]+noteXor[195]+noteXor[194]+noteXor[193]+noteXor[192]+
				 noteXor[191]+noteXor[190]+noteXor[189]+noteXor[188]+noteXor[187]+noteXor[186]+noteXor[185]+noteXor[184]+noteXor[183]+noteXor[182]+noteXor[181]+noteXor[180]+noteXor[179]+noteXor[178]+noteXor[177]+noteXor[176]+
				 noteXor[175]+noteXor[174]+noteXor[173]+noteXor[172]+noteXor[171]+noteXor[170]+noteXor[169]+noteXor[168]+noteXor[167]+noteXor[166]+noteXor[165]+noteXor[164]+noteXor[163]+noteXor[162]+noteXor[161]+noteXor[160]+
				 noteXor[159]+noteXor[158]+noteXor[157]+noteXor[156]+noteXor[155]+noteXor[154]+noteXor[153]+noteXor[152]+noteXor[151]+noteXor[150]+noteXor[149]+noteXor[148]+noteXor[147]+noteXor[146]+noteXor[145]+noteXor[144]+
				 noteXor[143]+noteXor[142]+noteXor[141]+noteXor[140]+noteXor[139]+noteXor[138]+noteXor[137]+noteXor[136]+noteXor[135]+noteXor[134]+noteXor[133]+noteXor[132]+noteXor[131]+noteXor[130]+noteXor[129]+noteXor[128]+
				 noteXor[127]+noteXor[126]+noteXor[125]+noteXor[124]+noteXor[123]+noteXor[122]+noteXor[121]+noteXor[120]+noteXor[119]+noteXor[118]+noteXor[117]+noteXor[116]+noteXor[115]+noteXor[114]+noteXor[113]+noteXor[112]+
				 noteXor[111]+noteXor[110]+noteXor[109]+noteXor[108]+noteXor[107]+noteXor[106]+noteXor[105]+noteXor[104]+noteXor[103]+noteXor[102]+noteXor[101]+noteXor[100]+noteXor[99]+noteXor[98]+noteXor[97]+noteXor[96]+
				 noteXor[95]+noteXor[94]+noteXor[93]+noteXor[92]+noteXor[91]+noteXor[90]+noteXor[89]+noteXor[88]+noteXor[87]+noteXor[86]+noteXor[85]+noteXor[84]+noteXor[83]+noteXor[82]+noteXor[81]+noteXor[80]+
				 noteXor[79]+noteXor[78]+noteXor[77]+noteXor[76]+noteXor[75]+noteXor[74]+noteXor[73]+noteXor[72]+noteXor[71]+noteXor[70]+noteXor[69]+noteXor[68]+noteXor[67]+noteXor[66]+noteXor[65]+noteXor[64]+
				 noteXor[63]+noteXor[62]+noteXor[61]+noteXor[60]+noteXor[59]+noteXor[58]+noteXor[57]+noteXor[56]+noteXor[55]+noteXor[54]+noteXor[53]+noteXor[52]+noteXor[51]+noteXor[50]+noteXor[49]+noteXor[48]+
				 noteXor[47]+noteXor[46]+noteXor[45]+noteXor[44]+noteXor[43]+noteXor[42]+noteXor[41]+noteXor[40]+noteXor[39]+noteXor[38]+noteXor[37]+noteXor[36]+noteXor[35]+noteXor[34]+noteXor[33]+noteXor[32]+
				 noteXor[31]+noteXor[30]+noteXor[29]+noteXor[28]+noteXor[27]+noteXor[26]+noteXor[25]+noteXor[24]+noteXor[23]+noteXor[22]+noteXor[21]+noteXor[20]+noteXor[19]+noteXor[18]+noteXor[17]+noteXor[16]+
				 noteXor[15]+noteXor[14]+noteXor[13]+noteXor[12]+noteXor[11]+noteXor[10]+noteXor[9]+noteXor[8]+noteXor[7]+noteXor[6]+noteXor[5]+noteXor[4]+noteXor[3]+noteXor[2]+noteXor[1]+noteXor[0];
				 
always @(posedge clk) begin
	StateN <= nextStateN;
	if(rst == 0) begin
		StateN <= 1'b0;
	end
end

always @(posedge clk) begin
nextStateN <= 1'b0;
countN <= countN;
noteDone <= noteDone;
noteCountHold <= noteCountHold;
noteSumHold <= noteSumHold;
	case(StateN)
		1'b0 : if(start == 1'b1) begin
			nextStateN <= 1'b1;
			countN <= 3'b000;
			noteSumHold <= 16'hFFFF;
			noteDone <= 1'b0;
		end else begin
			nextStateN <= 1'b0;
			noteDone <= 1'b0;
		end
		1'b1 : if(countN >= 7) begin
			nextStateN <= 1'b0;
			noteDone <= 1'b1;
		end else begin
			nextStateN <= 1'b1;
			countN <= countN + 1;
			if(noteAdd < noteSumHold) begin
				noteCountHold <= countN;
				noteSumHold <= noteAdd;
			end
		end
	endcase
end

always @(posedge clk) begin
	if(noteDone == 1'b1) begin
		noteReg <= noteFreq;
	end else begin
		noteReg <= noteReg;
	end
end

lengthMux lengthMux(.tinymap(tmLCMP),.sel(countL[0]));

assign bmLCMP = (noteCountHold == 3'b000) ? {bmr[379:364],bmr[355:340],bmr[331:316],bmr[307:292],bmr[283:268],bmr[259:244],bmr[235:220],bmr[211:196],bmr[187:172],bmr[163:148],bmr[139:124],bmr[115:100],bmr[91:76],bmr[67:52],bmr[43:28],bmr[19:4]} :
				(noteCountHold == 3'b001) ? {bmr[571:556],bmr[547:532],bmr[523:508],bmr[499:484],bmr[475:460],bmr[451:436],bmr[427:412],bmr[403:388],bmr[379:364],bmr[355:340],bmr[331:316],bmr[307:292],bmr[283:268],bmr[259:244],bmr[235:220],bmr[211:196]} :
				(noteCountHold == 3'b010) ? {bmr[763:748],bmr[739:724],bmr[715:700],bmr[691:676],bmr[667:652],bmr[643:628],bmr[619:604],bmr[595:580],bmr[571:556],bmr[547:532],bmr[523:508],bmr[499:484],bmr[475:460],bmr[451:436],bmr[427:412],bmr[403:388]} :
				(noteCountHold == 3'b011) ? {bmr[955:940],bmr[931:916],bmr[907:892],bmr[883:868],bmr[859:844],bmr[835:820],bmr[811:796],bmr[787:772],bmr[763:748],bmr[739:724],bmr[715:700],bmr[691:676],bmr[667:652],bmr[643:628],bmr[619:604],bmr[595:580]} :
				(noteCountHold == 3'b100) ? {bmr[1147:1132],bmr[1123:1108],bmr[1099:1084],bmr[1075:1060],bmr[1051:1036],bmr[1027:1012],bmr[1003:988],bmr[979:964],bmr[955:940],bmr[931:916],bmr[907:892],bmr[883:868],bmr[859:844],bmr[835:820],bmr[811:796],bmr[787:772]} :
				(noteCountHold == 3'b101) ? {bmr[1339:1324],bmr[1315:1300],bmr[1291:1276],bmr[1267:1252],bmr[1243:1228],bmr[1219:1204],bmr[1195:1180],bmr[1171:1156],bmr[1147:1132],bmr[1123:1108],bmr[1099:1084],bmr[1075:1060],bmr[1051:1036],bmr[1027:1012],bmr[1003:988],bmr[979:964]} :
											{bmr[1531:1516],bmr[1507:1492],bmr[1483:1468],bmr[1459:1444],bmr[1435:1420],bmr[1411:1396],bmr[1387:1372],bmr[1363:1348],bmr[1339:1324],bmr[1315:1300],bmr[1291:1276],bmr[1267:1252],bmr[1243:1228],bmr[1219:1204],bmr[1195:1180],bmr[1171:1156]};

assign lengthXor = bmLCMP ^ tmLCMP;

assign lengthFreq = lengthCountHold ?  16'h0001 : 16'h0010;

assign lengthAdd = lengthXor[255]+lengthXor[254]+lengthXor[253]+lengthXor[252]+lengthXor[251]+lengthXor[250]+lengthXor[249]+lengthXor[248]+lengthXor[247]+lengthXor[246]+lengthXor[245]+lengthXor[244]+lengthXor[243]+lengthXor[242]+lengthXor[241]+lengthXor[240]+
				   lengthXor[239]+lengthXor[238]+lengthXor[237]+lengthXor[236]+lengthXor[235]+lengthXor[234]+lengthXor[233]+lengthXor[232]+lengthXor[231]+lengthXor[230]+lengthXor[229]+lengthXor[228]+lengthXor[227]+lengthXor[226]+lengthXor[225]+lengthXor[224]+
				   lengthXor[223]+lengthXor[222]+lengthXor[221]+lengthXor[220]+lengthXor[219]+lengthXor[218]+lengthXor[217]+lengthXor[216]+lengthXor[215]+lengthXor[214]+lengthXor[213]+lengthXor[212]+lengthXor[211]+lengthXor[210]+lengthXor[209]+lengthXor[208]+
				   lengthXor[207]+lengthXor[206]+lengthXor[205]+lengthXor[204]+lengthXor[203]+lengthXor[202]+lengthXor[201]+lengthXor[200]+lengthXor[199]+lengthXor[198]+lengthXor[197]+lengthXor[196]+lengthXor[195]+lengthXor[194]+lengthXor[193]+lengthXor[192]+
				   lengthXor[191]+lengthXor[190]+lengthXor[189]+lengthXor[188]+lengthXor[187]+lengthXor[186]+lengthXor[185]+lengthXor[184]+lengthXor[183]+lengthXor[182]+lengthXor[181]+lengthXor[180]+lengthXor[179]+lengthXor[178]+lengthXor[177]+lengthXor[176]+
				   lengthXor[175]+lengthXor[174]+lengthXor[173]+lengthXor[172]+lengthXor[171]+lengthXor[170]+lengthXor[169]+lengthXor[168]+lengthXor[167]+lengthXor[166]+lengthXor[165]+lengthXor[164]+lengthXor[163]+lengthXor[162]+lengthXor[161]+lengthXor[160]+
				   lengthXor[159]+lengthXor[158]+lengthXor[157]+lengthXor[156]+lengthXor[155]+lengthXor[154]+lengthXor[153]+lengthXor[152]+lengthXor[151]+lengthXor[150]+lengthXor[149]+lengthXor[148]+lengthXor[147]+lengthXor[146]+lengthXor[145]+lengthXor[144]+
				   lengthXor[143]+lengthXor[142]+lengthXor[141]+lengthXor[140]+lengthXor[139]+lengthXor[138]+lengthXor[137]+lengthXor[136]+lengthXor[135]+lengthXor[134]+lengthXor[133]+lengthXor[132]+lengthXor[131]+lengthXor[130]+lengthXor[129]+lengthXor[128]+
				   lengthXor[127]+lengthXor[126]+lengthXor[125]+lengthXor[124]+lengthXor[123]+lengthXor[122]+lengthXor[121]+lengthXor[120]+lengthXor[119]+lengthXor[118]+lengthXor[117]+lengthXor[116]+lengthXor[115]+lengthXor[114]+lengthXor[113]+lengthXor[112]+
				   lengthXor[111]+lengthXor[110]+lengthXor[109]+lengthXor[108]+lengthXor[107]+lengthXor[106]+lengthXor[105]+lengthXor[104]+lengthXor[103]+lengthXor[102]+lengthXor[101]+lengthXor[100]+lengthXor[99]+lengthXor[98]+lengthXor[97]+lengthXor[96]+
				   lengthXor[95]+lengthXor[94]+lengthXor[93]+lengthXor[92]+lengthXor[91]+lengthXor[90]+lengthXor[89]+lengthXor[88]+lengthXor[87]+lengthXor[86]+lengthXor[85]+lengthXor[84]+lengthXor[83]+lengthXor[82]+lengthXor[81]+lengthXor[80]+
				   lengthXor[79]+lengthXor[78]+lengthXor[77]+lengthXor[76]+lengthXor[75]+lengthXor[74]+lengthXor[73]+lengthXor[72]+lengthXor[71]+lengthXor[70]+lengthXor[69]+lengthXor[68]+lengthXor[67]+lengthXor[66]+lengthXor[65]+lengthXor[64]+
				   lengthXor[63]+lengthXor[62]+lengthXor[61]+lengthXor[60]+lengthXor[59]+lengthXor[58]+lengthXor[57]+lengthXor[56]+lengthXor[55]+lengthXor[54]+lengthXor[53]+lengthXor[52]+lengthXor[51]+lengthXor[50]+lengthXor[49]+lengthXor[48]+
				   lengthXor[47]+lengthXor[46]+lengthXor[45]+lengthXor[44]+lengthXor[43]+lengthXor[42]+lengthXor[41]+lengthXor[40]+lengthXor[39]+lengthXor[38]+lengthXor[37]+lengthXor[36]+lengthXor[35]+lengthXor[34]+lengthXor[33]+lengthXor[32]+
				   lengthXor[31]+lengthXor[30]+lengthXor[29]+lengthXor[28]+lengthXor[27]+lengthXor[26]+lengthXor[25]+lengthXor[24]+lengthXor[23]+lengthXor[22]+lengthXor[21]+lengthXor[20]+lengthXor[19]+lengthXor[18]+lengthXor[17]+lengthXor[16]+
				   lengthXor[15]+lengthXor[14]+lengthXor[13]+lengthXor[12]+lengthXor[11]+lengthXor[10]+lengthXor[9]+lengthXor[8]+lengthXor[7]+lengthXor[6]+lengthXor[5]+lengthXor[4]+lengthXor[3]+lengthXor[2]+lengthXor[1]+lengthXor[0];
				 
always @(posedge clk) begin
	StateL <= nextStateL;
	if(rst == 0) begin
		StateL <= 0'b0;
	end
end

always @(posedge clk) begin
nextStateL <= 1'b0;
countL <= countL;
lengthDone <= lengthDone;
lengthCountHold <= lengthCountHold;
lengthSumHold <= lengthSumHold;
	case(StateL)
		1'b0 : if(noteDone == 1'b1) begin
			nextStateL <= 1'b1;
			countL <= 3'b000;
			lengthSumHold <= 16'hFFFF;
			lengthDone <= 1'b0;
		end else begin
			nextStateL <= 1'b0;
			lengthDone <= 1'b0;
		end
		1'b1 : if(countL >= 2) begin
			nextStateL <= 1'b0;
			lengthDone <= 1'b1;
		end else begin
			nextStateL <= 1'b1;
			countL <= countL + 1;
			if(lengthAdd < lengthSumHold) begin
				lengthCountHold <= countL;
				lengthSumHold <= lengthAdd;
			end
		end
	endcase
end

always @(posedge clk) begin
	if(lengthDone == 1'b1) begin
		lengthReg <= lengthFreq;
	end else begin
		lengthReg <= lengthReg;
	end
end

assign finish = lengthDone;

endmodule