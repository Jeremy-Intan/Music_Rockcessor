module ALU ();

wire [15:0] pc; //Not sure on size !!!!!!!!!!
wire [15:0] rs1, rs2; //input wires for registers
wire [8:0] sx_address;
wire [5:0] value; //used for loads and stores
wire [1535:0] bmr; //used for shift and scale
wire [2:0] pnz; //generated off add and sub
wire [15:0] pnz_check;

wire [1535:0] alu_bmo;
wire [15:0] alu_output;

wire rs_down, rs_left, rs_scale; //unknown sizes !!!!!!!!!!!!
wire [1535:0] down_shift, left_shift, scale;

wire [15:0] ADD, SUB, BR, LDST; // BR, BRR use same output, LD and ST use same output

assign ADD = rs1 + rs2; //reg + reg
assign SUB = rs1 - rs2; //reg - reg
assign BR = pc + {{7{sx_address[8]}},sx_address}; //pc + sign extended value
assign LDST = rs1 + {10'b0,value}; //reg + value

assign pnz_check = ______ ? ADD : SUB; //Need to know signal !!!!!!!!!!!
assign pnz[2] = ~pnz_check[15]; //is it positive
assign pnz[1] = pnz_check[15]; //is it negative
assign pnz[0] = pnz_check == 16'b0 ? 1'b1 : 1'b0; //is it zero

assign alu_output = ______ ? ADD : (______ ? SUB : (______ ? BR : (______ ? LDST : 16'b0))); //need signals !!!!!!!!!!!!

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
								  
assign scale = rs_scale[0] ? //not certain on algorithm for scaling should determine

assign alu_bmo = ______ ? left_shift : (______ ? scale : 1536'b0);

endmodule 