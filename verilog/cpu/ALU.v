module ALU (pc,rs1,rs2,sx_address,value,bmr,add,sub,br,ldst,shift,scale,pnz,alu_output,alu_bmo);
input wire [15:0] pc; //Not sure on size !!!!!!!!!!
input wire [15:0] rs1, rs2; //input wires for registers
input wire [8:0] sx_address;
input wire [5:0] value; //used for loads and stores
input wire [1535:0] bmr; //used for shift and scale
input wire add, sub, br, ldst, shift, scale;
output wire [2:0] pnz; //generated off add and sub
output wire [1535:0] alu_bmo;
output wire [15:0] alu_output;

wire [15:0] pnz_check;
wire rs_down, rs_left, rs_scale; //unknown sizes !!!!!!!!!!!!
wire [1535:0] down_shift, left_shift, scale;
wire [15:0] ADD, SUB, BR, LDST; // BR, BRR use same output, LD and ST use same output

assign ADD = rs1 + rs2; //reg + reg
assign SUB = rs1 - rs2; //reg - reg
assign BR = pc + {{7{sx_address[8]}},sx_address}; //pc + sign extended value
assign LDST = rs1 + {10'b0,value}; //reg + value

assign pnz_check = add ? ADD : (sub ? SUB : 16'b0); //Need to know signal !!!!!!!!!!!
assign pnz[2] = ~pnz_check[15]; //is it positive
assign pnz[1] = pnz_check[15]; //is it negative
assign pnz[0] = pnz_check == 16'b0 ? 1'b1 : 1'b0; //is it zero

assign alu_output = add ? ADD : (sub ? SUB : (br ? BR : (ldst ? LDST : 16'b0))); //need signals !!!!!!!!!!!!

assign rs_down = rs1[]; //unknown size and location in reg !!!!!!!!!!!!!!!
assign rs_left = rs1[]; //unknown size and location in reg !!!!!!!!!!!!!!!
assign rs_scale = rs1[]; //unknown size and location in reg !!!!!!!!!!!!!!!

assign down_shift = rs_down[0] ? {24'b0,bmr[1535:24]} : //more down shifts based on size of rs_down

assign left_shift = rs_left[0] ? {down_shift[1534:1512],1'b0, down_shift[1510:1488],1'b0, down_shift[1486:1464],1'b0, down_shift[1462:1440],1'b0,
								  down_shift[1438:1416],1'b0, down_shift[1414:1392],1'b0, down_shift[1390:1368],1'b0, down_shift[1366:1344],1'b0,
								  down_shift[1342:1320],1'b0, down_shift[1318:1296],1'b0, down_shift[1294:1272],1'b0, down_shift[1270:1248],1'b0,
								  down_shift[1246:1224],1'b0, down_shift[1222:1200],1'b0, down_shift[1198:1176],1'b0, down_shift[1174:1152],1'b0,
								  down_shift[1150:1128],1'b0, down_shift[1126:1104],1'b0, down_shift[1102:1080],1'b0, down_shift[1078:1056],1'b0,
								  down_shift[1054:1032],1'b0, down_shift[1030:1008],1'b0, down_shift[1006:984],1'b0, down_shift[982:960],1'b0,
								  down_shift[958:936],1'b0, down_shift[934:912],1'b0, down_shift[910:888],1'b0, down_shift[886:864],1'b0,
								  down_shift[862:840],1'b0, down_shift[838:816],1'b0, down_shift[814:792],1'b0, down_shift[790:768],1'b0,
								  down_shift[766:744],1'b0, down_shift[742:720],1'b0, down_shift[718:696],1'b0, down_shift[694:672],1'b0,
								  down_shift[670:648],1'b0, down_shift[646:624],1'b0, down_shift[622:600],1'b0, down_shift[598:576],1'b0,
								  down_shift[574:552],1'b0, down_shift[550:528],1'b0, down_shift[526:504],1'b0, down_shift[502:480],1'b0,
								  down_shift[478:456],1'b0, down_shift[454:432],1'b0, down_shift[430:408],1'b0, down_shift[406:384],1'b0,
								  down_shift[382:360],1'b0, down_shift[358:336],1'b0, down_shift[334:312],1'b0, down_shift[310:288],1'b0,
								  down_shift[286:264],1'b0, down_shift[262:240],1'b0, down_shift[238:216],1'b0, down_shift[214:192],1'b0,
								  down_shift[190:168],1'b0, down_shift[166:144],1'b0, down_shift[142:120],1'b0, down_shift[118:96],1'b0,
								  down_shift[94:72],1'b0, down_shift[70:48],1'b0, down_shift[46:24],1'b0, down_shift[22:0],1'b0} : //more left shifts based on size of rs_left
								  
assign SCALE = {2{2{bmr[768]},2{bmr[769]},2{bmr[770]},2{bmr[771]},2{bmr[772]},2{bmr[773]},2{bmr[774]},2{bmr[775]},2{bmr[776]},2{bmr[777]},2{bmr[778]},2{bmr[779]}},
				2{2{bmr[792]},2{bmr[793]},2{bmr[794]},2{bmr[795]},2{bmr[796]},2{bmr[797]},2{bmr[798]},2{bmr[799]},2{bmr[800]},2{bmr[801]},2{bmr[802]},2{bmr[803]}},
				2{2{bmr[816]},2{bmr[817]},2{bmr[818]},2{bmr[819]},2{bmr[820]},2{bmr[821]},2{bmr[822]},2{bmr[823]},2{bmr[824]},2{bmr[825]},2{bmr[826]},2{bmr[827]}},
				2{2{bmr[840]},2{bmr[841]},2{bmr[842]},2{bmr[843]},2{bmr[844]},2{bmr[845]},2{bmr[846]},2{bmr[847]},2{bmr[848]},2{bmr[849]},2{bmr[850]},2{bmr[851]}},
				2{2{bmr[864]},2{bmr[865]},2{bmr[866]},2{bmr[867]},2{bmr[868]},2{bmr[869]},2{bmr[870]},2{bmr[871]},2{bmr[872]},2{bmr[873]},2{bmr[874]},2{bmr[875]}},
				2{2{bmr[888]},2{bmr[889]},2{bmr[890]},2{bmr[891]},2{bmr[892]},2{bmr[893]},2{bmr[894]},2{bmr[895]},2{bmr[896]},2{bmr[897]},2{bmr[898]},2{bmr[899]}},
				2{2{bmr[912]},2{bmr[913]},2{bmr[914]},2{bmr[915]},2{bmr[916]},2{bmr[917]},2{bmr[918]},2{bmr[919]},2{bmr[920]},2{bmr[921]},2{bmr[922]},2{bmr[923]}},
				2{2{bmr[936]},2{bmr[937]},2{bmr[938]},2{bmr[939]},2{bmr[940]},2{bmr[941]},2{bmr[942]},2{bmr[943]},2{bmr[944]},2{bmr[945]},2{bmr[946]},2{bmr[947]}},
				2{2{bmr[960]},2{bmr[961]},2{bmr[962]},2{bmr[963]},2{bmr[964]},2{bmr[965]},2{bmr[966]},2{bmr[967]},2{bmr[968]},2{bmr[969]},2{bmr[970]},2{bmr[971]}},
				2{2{bmr[984]},2{bmr[985]},2{bmr[986]},2{bmr[987]},2{bmr[988]},2{bmr[989]},2{bmr[990]},2{bmr[991]},2{bmr[992]},2{bmr[993]},2{bmr[994]},2{bmr[995]}},
				2{2{bmr[1008]},2{bmr[1009]},2{bmr[1010]},2{bmr[1011]},2{bmr[1012]},2{bmr[1013]},2{bmr[1014]},2{bmr[1015]},2{bmr[1016]},2{bmr[1017]},2{bmr[1018]},2{bmr[1019]}},
				2{2{bmr[1032]},2{bmr[1033]},2{bmr[1034]},2{bmr[1035]},2{bmr[1036]},2{bmr[1037]},2{bmr[1038]},2{bmr[1039]},2{bmr[1040]},2{bmr[1041]},2{bmr[1042]},2{bmr[1043]}},
				2{2{bmr[1056]},2{bmr[1057]},2{bmr[1058]},2{bmr[1059]},2{bmr[1060]},2{bmr[1061]},2{bmr[1062]},2{bmr[1063]},2{bmr[1064]},2{bmr[1065]},2{bmr[1066]},2{bmr[1067]}},
				2{2{bmr[1080]},2{bmr[1081]},2{bmr[1082]},2{bmr[1083]},2{bmr[1084]},2{bmr[1085]},2{bmr[1086]},2{bmr[1087]},2{bmr[1088]},2{bmr[1089]},2{bmr[1090]},2{bmr[1091]}},
				2{2{bmr[1104]},2{bmr[1105]},2{bmr[1106]},2{bmr[1107]},2{bmr[1108]},2{bmr[1109]},2{bmr[1110]},2{bmr[1111]},2{bmr[1112]},2{bmr[1113]},2{bmr[1114]},2{bmr[1115]}},
				2{2{bmr[1128]},2{bmr[1129]},2{bmr[1130]},2{bmr[1131]},2{bmr[1132]},2{bmr[1133]},2{bmr[1134]},2{bmr[1135]},2{bmr[1136]},2{bmr[1137]},2{bmr[1138]},2{bmr[1139]}},
				2{2{bmr[1152]},2{bmr[1153]},2{bmr[1154]},2{bmr[1155]},2{bmr[1156]},2{bmr[1157]},2{bmr[1158]},2{bmr[1159]},2{bmr[1160]},2{bmr[1161]},2{bmr[1162]},2{bmr[1163]}},
				2{2{bmr[1176]},2{bmr[1177]},2{bmr[1178]},2{bmr[1179]},2{bmr[1180]},2{bmr[1181]},2{bmr[1182]},2{bmr[1183]},2{bmr[1184]},2{bmr[1185]},2{bmr[1186]},2{bmr[1187]}},
				2{2{bmr[1200]},2{bmr[1201]},2{bmr[1202]},2{bmr[1203]},2{bmr[1204]},2{bmr[1205]},2{bmr[1206]},2{bmr[1207]},2{bmr[1208]},2{bmr[1209]},2{bmr[1210]},2{bmr[1211]}},
				2{2{bmr[1224]},2{bmr[1225]},2{bmr[1226]},2{bmr[1227]},2{bmr[1228]},2{bmr[1229]},2{bmr[1230]},2{bmr[1231]},2{bmr[1232]},2{bmr[1233]},2{bmr[1234]},2{bmr[1235]}},
				2{2{bmr[1248]},2{bmr[1249]},2{bmr[1250]},2{bmr[1251]},2{bmr[1252]},2{bmr[1253]},2{bmr[1254]},2{bmr[1255]},2{bmr[1256]},2{bmr[1257]},2{bmr[1258]},2{bmr[1259]}},
				2{2{bmr[1272]},2{bmr[1273]},2{bmr[1274]},2{bmr[1275]},2{bmr[1276]},2{bmr[1277]},2{bmr[1278]},2{bmr[1279]},2{bmr[1280]},2{bmr[1281]},2{bmr[1282]},2{bmr[1283]}},
				2{2{bmr[1296]},2{bmr[1297]},2{bmr[1298]},2{bmr[1299]},2{bmr[1300]},2{bmr[1301]},2{bmr[1302]},2{bmr[1303]},2{bmr[1304]},2{bmr[1305]},2{bmr[1306]},2{bmr[1307]}},
				2{2{bmr[1320]},2{bmr[1321]},2{bmr[1322]},2{bmr[1323]},2{bmr[1324]},2{bmr[1325]},2{bmr[1326]},2{bmr[1327]},2{bmr[1328]},2{bmr[1329]},2{bmr[1330]},2{bmr[1331]}},
				2{2{bmr[1344]},2{bmr[1345]},2{bmr[1346]},2{bmr[1347]},2{bmr[1348]},2{bmr[1349]},2{bmr[1350]},2{bmr[1351]},2{bmr[1352]},2{bmr[1353]},2{bmr[1354]},2{bmr[1355]}},
				2{2{bmr[1368]},2{bmr[1369]},2{bmr[1370]},2{bmr[1371]},2{bmr[1372]},2{bmr[1373]},2{bmr[1374]},2{bmr[1375]},2{bmr[1376]},2{bmr[1377]},2{bmr[1378]},2{bmr[1379]}},
				2{2{bmr[1392]},2{bmr[1393]},2{bmr[1394]},2{bmr[1395]},2{bmr[1396]},2{bmr[1397]},2{bmr[1398]},2{bmr[1399]},2{bmr[1400]},2{bmr[1401]},2{bmr[1402]},2{bmr[1403]}},
				2{2{bmr[1416]},2{bmr[1417]},2{bmr[1418]},2{bmr[1419]},2{bmr[1420]},2{bmr[1421]},2{bmr[1422]},2{bmr[1423]},2{bmr[1424]},2{bmr[1425]},2{bmr[1426]},2{bmr[1427]}},
				2{2{bmr[1440]},2{bmr[1441]},2{bmr[1442]},2{bmr[1443]},2{bmr[1444]},2{bmr[1445]},2{bmr[1446]},2{bmr[1447]},2{bmr[1448]},2{bmr[1449]},2{bmr[1450]},2{bmr[1451]}},
				2{2{bmr[1464]},2{bmr[1465]},2{bmr[1466]},2{bmr[1467]},2{bmr[1468]},2{bmr[1469]},2{bmr[1470]},2{bmr[1471]},2{bmr[1472]},2{bmr[1473]},2{bmr[1474]},2{bmr[1475]}},
				2{2{bmr[1488]},2{bmr[1489]},2{bmr[1490]},2{bmr[1491]},2{bmr[1492]},2{bmr[1493]},2{bmr[1494]},2{bmr[1495]},2{bmr[1496]},2{bmr[1497]},2{bmr[1498]},2{bmr[1499]}},
				2{2{bmr[1512]},2{bmr[1513]},2{bmr[1514]},2{bmr[1515]},2{bmr[1516]},2{bmr[1517]},2{bmr[1518]},2{bmr[1519]},2{bmr[1520]},2{bmr[1521]},2{bmr[1522]},2{bmr[1523]}}}

assign alu_bmo = shift ? left_shift : (scale ? SCALE : 1536'b0);

endmodule 