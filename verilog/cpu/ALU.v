module ALU (pc,rs1,rs2,val,bmr,add,sub,br,ldst,shift,scale,pnz,alu_output,alu_bmo);
input wire [15:0] pc;
input wire [15:0] rs1, rs2; //input data for registers
input wire [15:0] val; //literal, any size (determined in decode)
input wire [1535:0] bmr; //used for shift and scale
input wire add, sub, br, ldst, shift, scale;
output wire [2:0] pnz; //generated off add and sub
output wire [1535:0] alu_bmo;
output wire [15:0] alu_output;

wire [15:0] pnz_check;
wire [5:0] rs_down;
wire [4:0] rs_left;
wire rs_scale;
reg [1535:0] down_shift_1, down_shift_2, down_shift_4, down_shift_8, down_shift_16, down_shift_32, left_shift_1, left_shift_2, left_shift_4, left_shift_8, left_shift_16, SCALE;
wire [15:0] ADD, SUB, BR, LDST; // BR, BRR use same output, LD and ST use same output

assign ADD = rs1 + rs2; //reg + reg
assign SUB = rs1 - rs2; //reg - reg
assign BR = pc + val; //pc + sign extended value
assign LDST = rs2 + val; //reg + value

assign pnz_check = add ? ADD : (sub ? SUB : 16'b0); //Need to know signal !!!!!!!!!!!
assign pnz[2] = ~pnz_check[15]; //is it positive
assign pnz[1] = pnz_check[15]; //is it negative
assign pnz[0] = pnz_check == 16'd0 ? 1'b1 : 1'b0; //is it zero

assign alu_output = add ? ADD : (sub ? SUB : (br ? BR : (ldst ? LDST : 16'd0))); //need signals !!!!!!!!!!!!

assign rs_down = rs1[5:0]; //unknown size and location in reg !!!!!!!!!!!!!!!
assign rs_left = rs1[10:6]; //unknown size and location in reg !!!!!!!!!!!!!!!
assign rs_scale = rs1[0]; //unknown size and location in reg !!!!!!!!!!!!!!!

assign down_shift_1  = rs_down[0] ? {24'd0,bmr[1535:24]} : bmr;
assign down_shift_2  = rs_down[1] ? {48'd0,down_shift_1[1535:48]} : down_shift_1;
assign down_shift_4  = rs_down[2] ? {96'd0,down_shift_2[1535:96]} : down_shift_2;
assign down_shift_8  = rs_down[3] ? {192'd0,down_shift_4[1535:192]} : down_shift_4;
assign down_shift_16 = rs_down[4] ? {384'd0,down_shift_8[1535:384]} : down_shift_8;
assign down_shift_32 = rs_down[5] ? {768'd0,down_shift_16[1535:768]} : down_shift_16;

assign left_shift_1 = rs_left[0] ? {down_shift_32[1534:1512],1'b0, down_shift_32[1510:1488],1'b0, down_shift_32[1486:1464],1'b0, down_shift_32[1462:1440],1'b0,
                                  down_shift_32[1438:1416],1'b0, down_shift_32[1414:1392],1'b0, down_shift_32[1390:1368],1'b0, down_shift_32[1366:1344],1'b0,
                                  down_shift_32[1342:1320],1'b0, down_shift_32[1318:1296],1'b0, down_shift_32[1294:1272],1'b0, down_shift_32[1270:1248],1'b0,
                                  down_shift_32[1246:1224],1'b0, down_shift_32[1222:1200],1'b0, down_shift_32[1198:1176],1'b0, down_shift_32[1174:1152],1'b0,
                                  down_shift_32[1150:1128],1'b0, down_shift_32[1126:1104],1'b0, down_shift_32[1102:1080],1'b0, down_shift_32[1078:1056],1'b0,
                                  down_shift_32[1054:1032],1'b0, down_shift_32[1030:1008],1'b0, down_shift_32[1006:984],1'b0, down_shift_32[982:960],1'b0,
                                  down_shift_32[958:936],1'b0, down_shift_32[934:912],1'b0, down_shift_32[910:888],1'b0, down_shift_32[886:864],1'b0,
                                  down_shift_32[862:840],1'b0, down_shift_32[838:816],1'b0, down_shift_32[814:792],1'b0, down_shift_32[790:768],1'b0,
                                  down_shift_32[766:744],1'b0, down_shift_32[742:720],1'b0, down_shift_32[718:696],1'b0, down_shift_32[694:672],1'b0,
                                  down_shift_32[670:648],1'b0, down_shift_32[646:624],1'b0, down_shift_32[622:600],1'b0, down_shift_32[598:576],1'b0,
                                  down_shift_32[574:552],1'b0, down_shift_32[550:528],1'b0, down_shift_32[526:504],1'b0, down_shift_32[502:480],1'b0,
                                  down_shift_32[478:456],1'b0, down_shift_32[454:432],1'b0, down_shift_32[430:408],1'b0, down_shift_32[406:384],1'b0,
                                  down_shift_32[382:360],1'b0, down_shift_32[358:336],1'b0, down_shift_32[334:312],1'b0, down_shift_32[310:288],1'b0,
                                  down_shift_32[286:264],1'b0, down_shift_32[262:240],1'b0, down_shift_32[238:216],1'b0, down_shift_32[214:192],1'b0,
                                  down_shift_32[190:168],1'b0, down_shift_32[166:144],1'b0, down_shift_32[142:120],1'b0, down_shift_32[118:96],1'b0,
                                  down_shift_32[94:72],1'b0, down_shift_32[70:48],1'b0, down_shift_32[46:24],1'b0, down_shift_32[22:0],1'b0} : down_shift_32;
								  
assign left_shift_2 = rs_left[1] ? {left_shift_1[1533:1512],2'd0, left_shift_1[1509:1488],2'd0, left_shift_1[1485:1464],2'd0, left_shift_1[1461:1440],2'd0,
                                  left_shift_1[1437:1416],2'd0, left_shift_1[1413:1392],2'd0, left_shift_1[1389:1368],2'd0, left_shift_1[1365:1344],2'd0,
                                  left_shift_1[1341:1320],2'd0, left_shift_1[1317:1296],2'd0, left_shift_1[1293:1272],2'd0, left_shift_1[1269:1248],2'd0,
                                  left_shift_1[1245:1224],2'd0, left_shift_1[1221:1200],2'd0, left_shift_1[1197:1176],2'd0, left_shift_1[1173:1152],2'd0,
                                  left_shift_1[1149:1128],2'd0, left_shift_1[1125:1104],2'd0, left_shift_1[1101:1080],2'd0, left_shift_1[1077:1056],2'd0,
                                  left_shift_1[1053:1032],2'd0, left_shift_1[1029:1008],2'd0, left_shift_1[1005:984],2'd0, left_shift_1[981:960],2'd0,
                                  left_shift_1[957:936],2'd0, left_shift_1[933:912],2'd0, left_shift_1[909:888],2'd0, left_shift_1[885:864],2'd0,
                                  left_shift_1[861:840],2'd0, left_shift_1[837:816],2'd0, left_shift_1[813:792],2'd0, left_shift_1[789:768],2'd0,
                                  left_shift_1[765:744],2'd0, left_shift_1[741:720],2'd0, left_shift_1[717:696],2'd0, left_shift_1[693:672],2'd0,
                                  left_shift_1[669:648],2'd0, left_shift_1[645:624],2'd0, left_shift_1[621:600],2'd0, left_shift_1[597:576],2'd0,
                                  left_shift_1[573:552],2'd0, left_shift_1[549:528],2'd0, left_shift_1[525:504],2'd0, left_shift_1[501:480],2'd0,
                                  left_shift_1[477:456],2'd0, left_shift_1[453:432],2'd0, left_shift_1[429:408],2'd0, left_shift_1[405:384],2'd0,
                                  left_shift_1[381:360],2'd0, left_shift_1[357:336],2'd0, left_shift_1[333:312],2'd0, left_shift_1[309:288],2'd0,
                                  left_shift_1[285:264],2'd0, left_shift_1[261:240],2'd0, left_shift_1[237:216],2'd0, left_shift_1[213:192],2'd0,
                                  left_shift_1[189:168],2'd0, left_shift_1[165:144],2'd0, left_shift_1[141:120],2'd0, left_shift_1[117:96],2'd0,
                                  left_shift_1[93:72],2'd0, left_shift_1[69:48],2'd0, left_shift_1[45:24],2'd0, left_shift_1[21:0],2'd0} : left_shift_1;

assign left_shift_4 = rs_left[2] ? {left_shift_2[1531:1512],4'd0, left_shift_2[1507:1488],4'd0, left_shift_2[1483:1464],4'd0, left_shift_2[1459:1440],4'd0,
                                  left_shift_2[1435:1416],4'd0, left_shift_2[1411:1392],4'd0, left_shift_2[1387:1368],4'd0, left_shift_2[1363:1344],4'd0,
                                  left_shift_2[1339:1320],4'd0, left_shift_2[1315:1296],4'd0, left_shift_2[1291:1272],4'd0, left_shift_2[1267:1248],4'd0,
                                  left_shift_2[1243:1224],4'd0, left_shift_2[1219:1200],4'd0, left_shift_2[1195:1176],4'd0, left_shift_2[1171:1152],4'd0,
                                  left_shift_2[1147:1128],4'd0, left_shift_2[1123:1104],4'd0, left_shift_2[1099:1080],4'd0, left_shift_2[1075:1056],4'd0,
                                  left_shift_2[1051:1032],4'd0, left_shift_2[1027:1008],4'd0, left_shift_2[1003:984],4'd0, left_shift_2[979:960],4'd0,
                                  left_shift_2[955:936],4'd0, left_shift_2[931:912],4'd0, left_shift_2[907:888],4'd0, left_shift_2[883:864],4'd0,
                                  left_shift_2[859:840],4'd0, left_shift_2[835:816],4'd0, left_shift_2[811:792],4'd0, left_shift_2[787:768],4'd0,
                                  left_shift_2[763:744],4'd0, left_shift_2[739:720],4'd0, left_shift_2[715:696],4'd0, left_shift_2[691:672],4'd0,
                                  left_shift_2[667:648],4'd0, left_shift_2[643:624],4'd0, left_shift_2[619:600],4'd0, left_shift_2[595:576],4'd0,
                                  left_shift_2[571:552],4'd0, left_shift_2[547:528],4'd0, left_shift_2[523:504],4'd0, left_shift_2[499:480],4'd0,
                                  left_shift_2[475:456],4'd0, left_shift_2[451:432],4'd0, left_shift_2[427:408],4'd0, left_shift_2[403:384],4'd0,
                                  left_shift_2[379:360],4'd0, left_shift_2[355:336],4'd0, left_shift_2[331:312],4'd0, left_shift_2[307:288],4'd0,
                                  left_shift_2[283:264],4'd0, left_shift_2[259:240],4'd0, left_shift_2[235:216],4'd0, left_shift_2[211:192],4'd0,
                                  left_shift_2[187:168],4'd0, left_shift_2[163:144],4'd0, left_shift_2[139:120],4'd0, left_shift_2[115:96],4'd0,
                                  left_shift_2[91:72],4'd0, left_shift_2[67:48],4'd0, left_shift_2[43:24],4'd0, left_shift_2[19:0],4'd0} : left_shift_2;

assign left_shift_8 = rs_left[3] ? {left_shift_4[1527:1512],8'd0, left_shift_4[1503:1488],8'd0, left_shift_4[1479:1464],8'd0, left_shift_4[1455:1440],8'd0,
                                  left_shift_4[1431:1416],8'd0, left_shift_4[1407:1392],8'd0, left_shift_4[1383:1368],8'd0, left_shift_4[1359:1344],8'd0,
                                  left_shift_4[1335:1320],8'd0, left_shift_4[1311:1296],8'd0, left_shift_4[1287:1272],8'd0, left_shift_4[1263:1248],8'd0,
                                  left_shift_4[1239:1224],8'd0, left_shift_4[1215:1200],8'd0, left_shift_4[1191:1176],8'd0, left_shift_4[1167:1152],8'd0,
                                  left_shift_4[1143:1128],8'd0, left_shift_4[1119:1104],8'd0, left_shift_4[1095:1080],8'd0, left_shift_4[1071:1056],8'd0,
                                  left_shift_4[1047:1032],8'd0, left_shift_4[1023:1008],8'd0, left_shift_4[999:984],8'd0, left_shift_4[975:960],8'd0,
                                  left_shift_4[951:936],8'd0, left_shift_4[927:912],8'd0, left_shift_4[903:888],8'd0, left_shift_4[879:864],8'd0,
                                  left_shift_4[855:840],8'd0, left_shift_4[831:816],8'd0, left_shift_4[807:792],8'd0, left_shift_4[783:768],8'd0,
                                  left_shift_4[759:744],8'd0, left_shift_4[735:720],8'd0, left_shift_4[711:696],8'd0, left_shift_4[687:672],8'd0,
                                  left_shift_4[663:648],8'd0, left_shift_4[639:624],8'd0, left_shift_4[615:600],8'd0, left_shift_4[591:576],8'd0,
                                  left_shift_4[567:552],8'd0, left_shift_4[543:528],8'd0, left_shift_4[519:504],8'd0, left_shift_4[495:480],8'd0,
                                  left_shift_4[471:456],8'd0, left_shift_4[447:432],8'd0, left_shift_4[423:408],8'd0, left_shift_4[399:384],8'd0,
                                  left_shift_4[375:360],8'd0, left_shift_4[351:336],8'd0, left_shift_4[327:312],8'd0, left_shift_4[303:288],8'd0,
                                  left_shift_4[279:264],8'd0, left_shift_4[255:240],8'd0, left_shift_4[231:216],8'd0, left_shift_4[207:192],8'd0,
                                  left_shift_4[183:168],8'd0, left_shift_4[159:144],8'd0, left_shift_4[135:120],8'd0, left_shift_4[111:96],8'd0,
                                  left_shift_4[87:72],8'd0, left_shift_4[63:48],8'd0, left_shift_4[39:24],8'd0, left_shift_4[15:0],8'd0} : left_shift_4;

assign left_shift_16 = rs_left[4] ? {left_shift_8[1519:1512],16'd0, left_shift_8[1495:1488],16'd0, left_shift_8[1471:1464],16'd0, left_shift_8[1447:1440],16'd0,
                                  left_shift_8[1423:1416],16'd0, left_shift_8[1399:1392],16'd0, left_shift_8[1375:1368],16'd0, left_shift_8[1351:1344],16'd0,
                                  left_shift_8[1327:1320],16'd0, left_shift_8[1303:1296],16'd0, left_shift_8[1279:1272],16'd0, left_shift_8[1255:1248],16'd0,
                                  left_shift_8[1231:1224],16'd0, left_shift_8[1207:1200],16'd0, left_shift_8[1183:1176],16'd0, left_shift_8[1159:1152],16'd0,
                                  left_shift_8[1135:1128],16'd0, left_shift_8[1111:1104],16'd0, left_shift_8[1087:1080],16'd0, left_shift_8[1063:1056],16'd0,
                                  left_shift_8[1039:1032],16'd0, left_shift_8[1015:1008],16'd0, left_shift_8[991:984],16'd0, left_shift_8[967:960],16'd0,
                                  left_shift_8[943:936],16'd0, left_shift_8[919:912],16'd0, left_shift_8[895:888],16'd0, left_shift_8[871:864],16'd0,
                                  left_shift_8[847:840],16'd0, left_shift_8[823:816],16'd0, left_shift_8[799:792],16'd0, left_shift_8[775:768],16'd0,
                                  left_shift_8[751:744],16'd0, left_shift_8[727:720],16'd0, left_shift_8[703:696],16'd0, left_shift_8[679:672],16'd0,
                                  left_shift_8[655:648],16'd0, left_shift_8[631:624],16'd0, left_shift_8[607:600],16'd0, left_shift_8[583:576],16'd0,
                                  left_shift_8[559:552],16'd0, left_shift_8[535:528],16'd0, left_shift_8[511:504],16'd0, left_shift_8[487:480],16'd0,
                                  left_shift_8[463:456],16'd0, left_shift_8[439:432],16'd0, left_shift_8[415:408],16'd0, left_shift_8[391:384],16'd0,
                                  left_shift_8[367:360],16'd0, left_shift_8[343:336],16'd0, left_shift_8[319:312],16'd0, left_shift_8[295:288],16'd0,
                                  left_shift_8[271:264],16'd0, left_shift_8[247:240],16'd0, left_shift_8[223:216],16'd0, left_shift_8[199:192],16'd0,
                                  left_shift_8[175:168],16'd0, left_shift_8[151:144],16'd0, left_shift_8[127:120],16'd0, left_shift_8[103:96],16'd0,
                                  left_shift_8[79:72],16'd0, left_shift_8[55:48],16'd0, left_shift_8[31:24],16'd0, left_shift_8[7:0],16'd0} : left_shift_8;

assign SCALE = {{2{{2{bmr[768]}},{2{bmr[769]}},{2{bmr[770]}},{2{bmr[771]}},{2{bmr[772]}},{2{bmr[773]}},{2{bmr[774]}},{2{bmr[775]}},{2{bmr[776]}},{2{bmr[777]}},{2{bmr[778]}},{2{bmr[779]}}}},
				{2{{2{bmr[792]}},{2{bmr[793]}},{2{bmr[794]}},{2{bmr[795]}},{2{bmr[796]}},{2{bmr[797]}},{2{bmr[798]}},{2{bmr[799]}},{2{bmr[800]}},{2{bmr[801]}},{2{bmr[802]}},{2{bmr[803]}}}},
				{2{{2{bmr[816]}},{2{bmr[817]}},{2{bmr[818]}},{2{bmr[819]}},{2{bmr[820]}},{2{bmr[821]}},{2{bmr[822]}},{2{bmr[823]}},{2{bmr[824]}},{2{bmr[825]}},{2{bmr[826]}},{2{bmr[827]}}}},
				{2{{2{bmr[840]}},{2{bmr[841]}},{2{bmr[842]}},{2{bmr[843]}},{2{bmr[844]}},{2{bmr[845]}},{2{bmr[846]}},{2{bmr[847]}},{2{bmr[848]}},{2{bmr[849]}},{2{bmr[850]}},{2{bmr[851]}}}},
				{2{{2{bmr[864]}},{2{bmr[865]}},{2{bmr[866]}},{2{bmr[867]}},{2{bmr[868]}},{2{bmr[869]}},{2{bmr[870]}},{2{bmr[871]}},{2{bmr[872]}},{2{bmr[873]}},{2{bmr[874]}},{2{bmr[875]}}}},
				{2{{2{bmr[888]}},{2{bmr[889]}},{2{bmr[890]}},{2{bmr[891]}},{2{bmr[892]}},{2{bmr[893]}},{2{bmr[894]}},{2{bmr[895]}},{2{bmr[896]}},{2{bmr[897]}},{2{bmr[898]}},{2{bmr[899]}}}},
				{2{{2{bmr[912]}},{2{bmr[913]}},{2{bmr[914]}},{2{bmr[915]}},{2{bmr[916]}},{2{bmr[917]}},{2{bmr[918]}},{2{bmr[919]}},{2{bmr[920]}},{2{bmr[921]}},{2{bmr[922]}},{2{bmr[923]}}}},
				{2{{2{bmr[936]}},{2{bmr[937]}},{2{bmr[938]}},{2{bmr[939]}},{2{bmr[940]}},{2{bmr[941]}},{2{bmr[942]}},{2{bmr[943]}},{2{bmr[944]}},{2{bmr[945]}},{2{bmr[946]}},{2{bmr[947]}}}},
				{2{{2{bmr[960]}},{2{bmr[961]}},{2{bmr[962]}},{2{bmr[963]}},{2{bmr[964]}},{2{bmr[965]}},{2{bmr[966]}},{2{bmr[967]}},{2{bmr[968]}},{2{bmr[969]}},{2{bmr[970]}},{2{bmr[971]}}}},
				{2{{2{bmr[984]}},{2{bmr[985]}},{2{bmr[986]}},{2{bmr[987]}},{2{bmr[988]}},{2{bmr[989]}},{2{bmr[990]}},{2{bmr[991]}},{2{bmr[992]}},{2{bmr[993]}},{2{bmr[994]}},{2{bmr[995]}}}},
				{2{{2{bmr[1008]}},{2{bmr[1009]}},{2{bmr[1010]}},{2{bmr[1011]}},{2{bmr[1012]}},{2{bmr[1013]}},{2{bmr[1014]}},{2{bmr[1015]}},{2{bmr[1016]}},{2{bmr[1017]}},{2{bmr[1018]}},{2{bmr[1019]}}}},
				{2{{2{bmr[1032]}},{2{bmr[1033]}},{2{bmr[1034]}},{2{bmr[1035]}},{2{bmr[1036]}},{2{bmr[1037]}},{2{bmr[1038]}},{2{bmr[1039]}},{2{bmr[1040]}},{2{bmr[1041]}},{2{bmr[1042]}},{2{bmr[1043]}}}},
				{2{{2{bmr[1056]}},{2{bmr[1057]}},{2{bmr[1058]}},{2{bmr[1059]}},{2{bmr[1060]}},{2{bmr[1061]}},{2{bmr[1062]}},{2{bmr[1063]}},{2{bmr[1064]}},{2{bmr[1065]}},{2{bmr[1066]}},{2{bmr[1067]}}}},
				{2{{2{bmr[1080]}},{2{bmr[1081]}},{2{bmr[1082]}},{2{bmr[1083]}},{2{bmr[1084]}},{2{bmr[1085]}},{2{bmr[1086]}},{2{bmr[1087]}},{2{bmr[1088]}},{2{bmr[1089]}},{2{bmr[1090]}},{2{bmr[1091]}}}},
				{2{{2{bmr[1104]}},{2{bmr[1105]}},{2{bmr[1106]}},{2{bmr[1107]}},{2{bmr[1108]}},{2{bmr[1109]}},{2{bmr[1110]}},{2{bmr[1111]}},{2{bmr[1112]}},{2{bmr[1113]}},{2{bmr[1114]}},{2{bmr[1115]}}}},
				{2{{2{bmr[1128]}},{2{bmr[1129]}},{2{bmr[1130]}},{2{bmr[1131]}},{2{bmr[1132]}},{2{bmr[1133]}},{2{bmr[1134]}},{2{bmr[1135]}},{2{bmr[1136]}},{2{bmr[1137]}},{2{bmr[1138]}},{2{bmr[1139]}}}},
				{2{{2{bmr[1152]}},{2{bmr[1153]}},{2{bmr[1154]}},{2{bmr[1155]}},{2{bmr[1156]}},{2{bmr[1157]}},{2{bmr[1158]}},{2{bmr[1159]}},{2{bmr[1160]}},{2{bmr[1161]}},{2{bmr[1162]}},{2{bmr[1163]}}}},
				{2{{2{bmr[1176]}},{2{bmr[1177]}},{2{bmr[1178]}},{2{bmr[1179]}},{2{bmr[1180]}},{2{bmr[1181]}},{2{bmr[1182]}},{2{bmr[1183]}},{2{bmr[1184]}},{2{bmr[1185]}},{2{bmr[1186]}},{2{bmr[1187]}}}},
				{2{{2{bmr[1200]}},{2{bmr[1201]}},{2{bmr[1202]}},{2{bmr[1203]}},{2{bmr[1204]}},{2{bmr[1205]}},{2{bmr[1206]}},{2{bmr[1207]}},{2{bmr[1208]}},{2{bmr[1209]}},{2{bmr[1210]}},{2{bmr[1211]}}}},
				{2{{2{bmr[1224]}},{2{bmr[1225]}},{2{bmr[1226]}},{2{bmr[1227]}},{2{bmr[1228]}},{2{bmr[1229]}},{2{bmr[1230]}},{2{bmr[1231]}},{2{bmr[1232]}},{2{bmr[1233]}},{2{bmr[1234]}},{2{bmr[1235]}}}},
				{2{{2{bmr[1248]}},{2{bmr[1249]}},{2{bmr[1250]}},{2{bmr[1251]}},{2{bmr[1252]}},{2{bmr[1253]}},{2{bmr[1254]}},{2{bmr[1255]}},{2{bmr[1256]}},{2{bmr[1257]}},{2{bmr[1258]}},{2{bmr[1259]}}}},
				{2{{2{bmr[1272]}},{2{bmr[1273]}},{2{bmr[1274]}},{2{bmr[1275]}},{2{bmr[1276]}},{2{bmr[1277]}},{2{bmr[1278]}},{2{bmr[1279]}},{2{bmr[1280]}},{2{bmr[1281]}},{2{bmr[1282]}},{2{bmr[1283]}}}},
				{2{{2{bmr[1296]}},{2{bmr[1297]}},{2{bmr[1298]}},{2{bmr[1299]}},{2{bmr[1300]}},{2{bmr[1301]}},{2{bmr[1302]}},{2{bmr[1303]}},{2{bmr[1304]}},{2{bmr[1305]}},{2{bmr[1306]}},{2{bmr[1307]}}}},
				{2{{2{bmr[1320]}},{2{bmr[1321]}},{2{bmr[1322]}},{2{bmr[1323]}},{2{bmr[1324]}},{2{bmr[1325]}},{2{bmr[1326]}},{2{bmr[1327]}},{2{bmr[1328]}},{2{bmr[1329]}},{2{bmr[1330]}},{2{bmr[1331]}}}},
				{2{{2{bmr[1344]}},{2{bmr[1345]}},{2{bmr[1346]}},{2{bmr[1347]}},{2{bmr[1348]}},{2{bmr[1349]}},{2{bmr[1350]}},{2{bmr[1351]}},{2{bmr[1352]}},{2{bmr[1353]}},{2{bmr[1354]}},{2{bmr[1355]}}}},
				{2{{2{bmr[1368]}},{2{bmr[1369]}},{2{bmr[1370]}},{2{bmr[1371]}},{2{bmr[1372]}},{2{bmr[1373]}},{2{bmr[1374]}},{2{bmr[1375]}},{2{bmr[1376]}},{2{bmr[1377]}},{2{bmr[1378]}},{2{bmr[1379]}}}},
				{2{{2{bmr[1392]}},{2{bmr[1393]}},{2{bmr[1394]}},{2{bmr[1395]}},{2{bmr[1396]}},{2{bmr[1397]}},{2{bmr[1398]}},{2{bmr[1399]}},{2{bmr[1400]}},{2{bmr[1401]}},{2{bmr[1402]}},{2{bmr[1403]}}}},
				{2{{2{bmr[1416]}},{2{bmr[1417]}},{2{bmr[1418]}},{2{bmr[1419]}},{2{bmr[1420]}},{2{bmr[1421]}},{2{bmr[1422]}},{2{bmr[1423]}},{2{bmr[1424]}},{2{bmr[1425]}},{2{bmr[1426]}},{2{bmr[1427]}}}},
				{2{{2{bmr[1440]}},{2{bmr[1441]}},{2{bmr[1442]}},{2{bmr[1443]}},{2{bmr[1444]}},{2{bmr[1445]}},{2{bmr[1446]}},{2{bmr[1447]}},{2{bmr[1448]}},{2{bmr[1449]}},{2{bmr[1450]}},{2{bmr[1451]}}}},
				{2{{2{bmr[1464]}},{2{bmr[1465]}},{2{bmr[1466]}},{2{bmr[1467]}},{2{bmr[1468]}},{2{bmr[1469]}},{2{bmr[1470]}},{2{bmr[1471]}},{2{bmr[1472]}},{2{bmr[1473]}},{2{bmr[1474]}},{2{bmr[1475]}}}},
				{2{{2{bmr[1488]}},{2{bmr[1489]}},{2{bmr[1490]}},{2{bmr[1491]}},{2{bmr[1492]}},{2{bmr[1493]}},{2{bmr[1494]}},{2{bmr[1495]}},{2{bmr[1496]}},{2{bmr[1497]}},{2{bmr[1498]}},{2{bmr[1499]}}}},
				{2{{2{bmr[1512]}},{2{bmr[1513]}},{2{bmr[1514]}},{2{bmr[1515]}},{2{bmr[1516]}},{2{bmr[1517]}},{2{bmr[1518]}},{2{bmr[1519]}},{2{bmr[1520]}},{2{bmr[1521]}},{2{bmr[1522]}},{2{bmr[1523]}}}}};

assign alu_bmo = shift ? left_shift_16 : (scale & rs_scale ? SCALE : 1536'b0);

endmodule 
