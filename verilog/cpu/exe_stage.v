module exe_stage();

input [15:0] pc;
input [3:0] rs1_addr;
input [3:0] rs2_addr;
input [3:0] rd_addr;
input [15:0];

ALU alu(.pc(),
        .rs1(),
        .rs2(),
        .sx_address(),
        .value(),
        .bmr(),
        .add(),
        .sub(),
        .br(),
        .ldst(),
        .shift(),
        .scale(),
        .pnz(),
        .alu_output(),
        .alu_bmo());

endmodule
