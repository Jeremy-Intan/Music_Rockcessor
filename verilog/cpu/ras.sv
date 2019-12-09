//pop has priority over push

module ras(clk, rst_n, push, new_data, pop, top_of_stack, err);

typedef enum reg [3:0] {EMPTY, ADDR_0, ADDR_1, ADDR_2, ADDR_3, ADDR_4, ADDR_5, ADDR_6, ADDR_7} state_t;

input wire clk;
input wire rst_n;
input wire push;
input wire [15:0] new_data;
input wire pop;
output reg [15:0] top_of_stack;
output reg err;

state_t state;
state_t new_state;
reg [15:0] addr_0_reg;
reg [15:0] addr_0_reg_new;
reg [15:0] addr_1_reg;
reg [15:0] addr_1_reg_new;
reg [15:0] addr_2_reg;
reg [15:0] addr_2_reg_new;
reg [15:0] addr_3_reg;
reg [15:0] addr_3_reg_new;
reg [15:0] addr_4_reg;
reg [15:0] addr_4_reg_new;
reg [15:0] addr_5_reg;
reg [15:0] addr_5_reg_new;
reg [15:0] addr_6_reg;
reg [15:0] addr_6_reg_new;
reg [15:0] addr_7_reg;
reg [15:0] addr_7_reg_new;

always @(posedge clk, negedge rst_n) begin
    if (rst_n == 0) 
        state <= EMPTY;
    else
        state <= new_state;
end

always @(posedge clk) begin
    addr_0_reg <= addr_0_reg_new;
    addr_1_reg <= addr_1_reg_new;
    addr_2_reg <= addr_2_reg_new;
    addr_3_reg <= addr_3_reg_new;
    addr_4_reg <= addr_4_reg_new;
    addr_5_reg <= addr_5_reg_new;
    addr_6_reg <= addr_6_reg_new;
    addr_7_reg <= addr_7_reg_new;
end

always_comb begin
    new_state = state;
    err = 0;
    addr_0_reg_new = addr_0_reg;
    addr_1_reg_new = addr_1_reg;
    addr_2_reg_new = addr_2_reg;
    addr_3_reg_new = addr_3_reg;
    addr_4_reg_new = addr_4_reg;
    addr_5_reg_new = addr_5_reg;
    addr_6_reg_new = addr_6_reg;
    addr_7_reg_new = addr_7_reg;
    top_of_stack = addr_0_reg;

    if (state == EMPTY) begin
        if (pop)
            err = 1;
        if (push) begin
            new_state = ADDR_0;
            addr_0_reg_new = new_data;
        end
    end
    else if (state == ADDR_0) begin
        top_of_stack = addr_0_reg;
        if (pop)
            new_state = EMPTY;
        else if (push) begin
            new_state = ADDR_1;
            addr_1_reg_new = new_data;
        end
    end
    else if (state == ADDR_1) begin
        top_of_stack = addr_1_reg;
        if (pop)
            new_state = ADDR_0;
        else if (push) begin
            new_state = ADDR_2;
            addr_2_reg_new = new_data;
        end
    end
    else if (state == ADDR_2) begin
        top_of_stack = addr_2_reg;
        if (pop)
            new_state = ADDR_1;
        else if (push) begin
            new_state = ADDR_3;
            addr_3_reg_new = new_data;
        end
    end
    else if (state == ADDR_3) begin
        top_of_stack = addr_3_reg;
        if (pop)
            new_state = ADDR_2;
        else if (push) begin
            new_state = ADDR_4;
            addr_4_reg_new = new_data;
        end
    end
    else if (state == ADDR_4) begin
        top_of_stack = addr_4_reg;
        if (pop)
            new_state = ADDR_3;
        else if (push) begin
            new_state = ADDR_5;
            addr_5_reg_new = new_data;
        end
    end
    else if (state == ADDR_5) begin
        top_of_stack = addr_5_reg;
        if (pop)
            new_state = ADDR_4;
        else if (push) begin
            new_state = ADDR_6;
            addr_6_reg_new = new_data;
        end
    end
    else if (state == ADDR_6) begin
        top_of_stack = addr_6_reg;
        if (pop)
            new_state = ADDR_5;
        else if (push) begin
            new_state = ADDR_7;
            addr_7_reg_new = new_data;
        end
    end
    else if (state == ADDR_7) begin
        top_of_stack = addr_7_reg;
        if (pop)
            new_state = ADDR_6;
        else if (push) begin
            err = 1;
        end
    end
end

endmodule
