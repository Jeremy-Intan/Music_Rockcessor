module exe_tb();

reg clk, rst_n;

reg [15:0] pc;
reg [15:0] rs1_data;
reg [15:0] rs2_data;
reg [1535:0] bs_data;
reg [15:0] lit;
reg add, sub, br, mv, bsh, bsl, save_addr, int_in, ret, int_state;
reg ldst;
reg [2:0] pnz_in;
wire [15:0] branch_addr; 
wire branch_taken;
wire [15:0] rd_data;
wire [1535:0] bd_data;
wire int_state_out;

int ii;
 
exe_stage iDUT(.clk(clk),
               .rst_n(rst_n),
               .pc(pc),
               .rs1_data(rs1_data),
               .rs2_data(rs2_data),
               .bs_data(bs_data),
               .lit(lit),
               .ldst(ldst),
               .add(add),
               .sub(sub),
               .br(br), 
               .mv(mv), 
               .bsh(bsh),
               .bsl(bsl),
               .save_addr(save_addr),
               .int_in(int_in),
               .ret(ret),
               .int_state(int_state),
               .pnz_in(pnz_in),
               .branch_addr(branch_addr),
               .branch_taken(branch_taken),
               .rd_data(rd_data),
               .bd_data(bd_data),
               .int_state_out(int_state_out));

initial begin
clk = 0;
rst_n = 0;
pc = 0;
rs1_data = 0;
rs2_data = 0;
bs_data = 0;
lit = 0;
add = 0;
sub = 0;
ldst = 0;
br = 0;
mv = 0;
bsh = 0;
bsl = 0;
save_addr = 0;
int_in = 0;
ret = 0;
int_state = 0;
pnz_in = 0;
@(posedge clk);
@(negedge clk);
@(posedge clk);
rst_n = 1;
@(negedge clk);
@(posedge clk);
add = 1;
rs1_data = 16'd900;
rs2_data = 16'd200;
@(negedge clk);
$display("ADD 900 + 200 = %d", rd_data);
@(posedge clk);
add = 0;
br = 1;
pnz_in = 3'b100;
save_addr = 1;
pc = 16'd100;
lit = 16'd10;
@(negedge clk);
$display("Branch from pc 100, offset 10, %d %b", branch_addr, branch_taken);
@(posedge clk);
br = 0;
save_addr = 0;
sub = 1;
rs1_data = 16'd800;
rs2_data = 16'd150;
@(negedge clk);
$display("Sub 800 - 150 = %d", rd_data);
@(posedge clk);
sub = 0;
mv = 1;
lit = 16'd567;
@(negedge clk);
$display ("Move lit 567, %d", rd_data);
@(posedge clk);
mv = 0;
br = 1;
save_addr = 0;
pnz_in = 3'b111;
pc = 16'd120;
lit = 16'd80;
@(negedge clk);
$display("Branch from pc 120, offset 80, %d %b", branch_addr, branch_taken);
@(posedge clk);
br = 0;
add = 1;
rs1_data = 16'd111;
rs2_data = 16'd111;
@(negedge clk);
$display("ADD 111 + 111 = %d", rd_data);
@(posedge clk);
add = 0;
sub = 1;
rs1_data = 16'd120;
rs2_data = 16'd120;
@(negedge clk);
$display("SUB 120 - 120 = %d", rd_data);
@(posedge clk);
sub = 0;
br = 1;
save_addr = 1;
pc = 16'd500;
lit = -16'd1;
pnz_in = 3'b001;
@(negedge clk);
$display("Branch from pc 500, offset -1, %d %b", branch_addr, branch_taken);
@(posedge clk);
br = 0;
save_addr = 0;
bsh = 1;
rs1_data = {4'd0,5'd7,6'd1};
bs_data = {
      24'b1000_0000_0000_0000_0000_0001,
      24'b0100_0000_0000_0000_0000_0010,
      24'b0010_0000_0000_0000_0000_0100,
      24'b0001_0000_0000_0000_0000_1000,
      24'b0000_1000_0000_0000_0001_0000,
      24'b0000_0100_0000_0000_0010_0000,
      24'b0000_0010_0000_0000_0100_0000,
      24'b0000_0001_0000_0000_1000_0000,

      24'b0000_0000_1000_0001_0000_0000,
      24'b0000_0000_0100_0010_0000_0000,
      24'b0000_0000_0010_0100_0000_0000,
      24'b0000_0000_0001_1000_0000_0000,
      24'b0000_0000_0001_1000_0000_0000,
      24'b0000_0000_0010_0100_0000_0000,
      24'b0000_0000_0100_0010_0000_0000,
      24'b0000_0000_1000_0001_0000_0000,

      24'b0000_0001_0000_0000_1000_0000,
      24'b0000_0010_0000_0000_0100_0000,
      24'b0000_0100_0000_0000_0010_0000,
      24'b0000_1000_0000_0000_0001_0000,
      24'b0001_0000_0000_0000_0000_1000,
      24'b0010_0000_0000_0000_0000_0100,
      24'b0100_0000_0000_0000_0000_0010,
      24'b1000_0000_0000_0000_0000_0001,

      24'b0000_0000_0001_1000_0000_0000,
      24'b0000_0000_0010_0100_0000_0000,
      24'b0000_0000_0100_0010_0000_0000,
      24'b0000_0000_1000_0001_0000_0000,
      24'b0000_0001_0000_0000_1000_0000,
      24'b0000_0010_0000_0000_0100_0000,
      24'b0000_0100_0000_0000_0010_0000,
      24'b0000_1000_0000_0000_0001_0000,

      24'b0001_0000_0000_0000_0000_1000,
      24'b0010_0000_0000_0000_0000_0100,
      24'b0100_0000_0000_0000_0000_0010,
      24'b1000_0000_0000_0000_0000_0001,
      24'b1000_0000_0000_0000_0000_0001,
      24'b0100_0000_0000_0000_0000_0010,
      24'b0010_0000_0000_0000_0000_0100,
      24'b0001_0000_0000_0000_0000_1000,

      24'b0000_1000_0000_0000_0001_0000,
      24'b0000_0100_0000_0000_0010_0000,
      24'b0000_0010_0000_0000_0100_0000,
      24'b0000_0001_0000_0000_1000_0000,
      24'b0000_0000_1000_0001_0000_0000,
      24'b0000_0000_0100_0010_0000_0000,
      24'b0000_0000_0010_0100_0000_0000,
      24'b0000_0000_0001_1000_0000_0000,

      24'b1111_0000_1111_0000_1111_0000,
      24'b0111_1000_0111_1000_0111_1000,
      24'b1111_0000_1111_0000_1111_0000,
      24'b1110_0001_1110_0001_1110_0000,
      24'b1111_0000_1111_0000_1111_0000,
      24'b0111_1000_0111_1000_0111_1000,
      24'b1111_0000_1111_0000_1111_0000,
      24'b1110_0001_1110_0001_1110_0000,

      24'b1111_0000_1111_0000_1111_0000,
      24'b0111_1000_0111_1000_0111_1000,
      24'b1111_0000_1111_0000_1111_0000,
      24'b1110_0001_1110_0001_1110_0000,
      24'b1111_0000_1111_0000_1111_0000,
      24'b0111_1000_0111_1000_0111_1000,
      24'b1111_0000_1111_0000_1111_0000,
      24'b1110_0001_1110_0001_1110_0000};

@(negedge clk);
$display ("BSH, 7 left, 1 down");
for (ii = 63; ii >= 0; ii--) begin
    $display("%b",bd_data[ii*24 +: 24]);
end
@(posedge clk);
bsh = 1;
rs1_data = {4'd0,5'd3,6'd3};
@(negedge clk);
$display ("BSH, 3 left, 3 down");
for (ii = 63; ii >= 0; ii--) begin
    $display("%b",bd_data[ii*24 +: 24]);
end
@(posedge clk);
bsh = 1;
rs1_data = {4'd0,5'd1,6'd7};
@(negedge clk);
$display ("BSH, 1 left, 7 down");
for (ii = 63; ii >= 0; ii--) begin
    $display("%b",bd_data[ii*24 +: 24]);
end
@(posedge clk);
bsh = 0;
ret = 1;
@(negedge clk);
$display("RET %d %b", branch_addr, branch_taken);
@(posedge clk);
bsh = 0;
ret = 1;
@(negedge clk);
$display("RET %d %b", branch_addr, branch_taken);
@(posedge clk);
ret = 0;
sub = 0;
br = 1;
save_addr = 1;
pc = 16'd123;
lit = -16'd2;
pnz_in = 3'b111;
@(negedge clk);
$display("Branch from pc 123, offset -2, %d %b", branch_addr, branch_taken);
@(posedge clk);
sub = 0;
br = 1;
save_addr = 1;
pc = 16'd124;
lit = -16'd2;
pnz_in = 3'b111;
@(negedge clk);
$display("Branch from pc 124, offset -2, %d %b", branch_addr, branch_taken);
@(posedge clk);
sub = 0;
br = 1;
save_addr = 1;
pc = 16'd125;
lit = -16'd2;
pnz_in = 3'b111;
@(negedge clk);
$display("Branch from pc 125, offset -2, %d %b", branch_addr, branch_taken);
@(posedge clk);
sub = 0;
br = 1;
save_addr = 1;
pc = 16'd126;
lit = -16'd2;
pnz_in = 3'b111;
@(negedge clk);
$display("Branch from pc 126, offset -2, %d %b", branch_addr, branch_taken);
@(posedge clk);
sub = 0;
br = 1;
save_addr = 1;
pc = 16'd127;
lit = -16'd2;
pnz_in = 3'b111;
@(negedge clk);
$display("Branch from pc 127, offset -2, %d %b", branch_addr, branch_taken);
@(posedge clk);
sub = 0;
br = 1;
save_addr = 1;
pc = 16'd128;
lit = -16'd2;
pnz_in = 3'b111;
@(negedge clk);
$display("Branch from pc 128, offset -2, %d %b", branch_addr, branch_taken);
@(posedge clk);
sub = 0;
br = 1;
save_addr = 1;
pc = 16'd129;
lit = -16'd2;
pnz_in = 3'b111;
@(negedge clk);
$display("Branch from pc 129, offset -2, %d %b", branch_addr, branch_taken);
@(posedge clk);
sub = 0;
br = 1;
save_addr = 1;
pc = 16'd130;
lit = -16'd2;
pnz_in = 3'b111;
@(negedge clk);
$display("Branch from pc 130, offset -2, %d %b", branch_addr, branch_taken);
@(posedge clk);
br = 0;
save_addr = 0;
ret = 1;
@(negedge clk);
$display("RET %d %b", branch_addr, branch_taken);
@(posedge clk);
br = 0;
save_addr = 0;
ret = 1;
@(negedge clk);
$display("RET %d %b", branch_addr, branch_taken);
@(posedge clk);
br = 0;
save_addr = 0;
ret = 1;
@(negedge clk);
$display("RET %d %b", branch_addr, branch_taken);
@(posedge clk);
br = 0;
save_addr = 0;
ret = 1;
@(negedge clk);
$display("RET %d %b", branch_addr, branch_taken);
@(posedge clk);
br = 0;
save_addr = 0;
ret = 1;
@(negedge clk);
$display("RET %d %b", branch_addr, branch_taken);
@(posedge clk);
br = 0;
save_addr = 0;
ret = 1;
@(negedge clk);
$display("RET %d %b", branch_addr, branch_taken);
@(posedge clk);
br = 0;
save_addr = 0;
ret = 1;
@(negedge clk);
$display("RET %d %b", branch_addr, branch_taken);
@(posedge clk);
br = 0;
save_addr = 0;
ret = 1;
@(negedge clk);
$display("RET %d %b", branch_addr, branch_taken);
@(posedge clk);
ret = 0;
ldst = 1;
rs1_data=16'd123;
lit = -16'd7;
@(negedge clk);
$display("LDST 123, -7, $d", rd_data);
@(posedge clk);
rs1_data=16'd600;
lit = 16'd1;
@(negedge clk);
$display("LDST 600, 1, $d", rd_data);

$stop;
end

always begin
#2 clk = ~clk;
end

endmodule
