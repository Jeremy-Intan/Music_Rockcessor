module reg_file (
    rd_addr_1,
    rd_data_1,
    rd_addr_2,
    rd_data_2,
    wr_addr,
    wr_data,
    wr,
    rbm_addr,
    rbm_data,
    wbm_addr,
    wbm_data,
    wbm,
    clk);

    parameter n = 16;
    parameter b = 1536;

    input wire [3:0] rd_addr_1;
    output reg [15:0] rd_data_1;
    input wire [3:0] rd_addr_2;
    output reg [15:0] rd_data_2;
    input wire [3:0] wr_addr;
    input wire [15:0] wr_data;
    input wire wr;
    input wire [1:0] rbm_addr;
    output reg [1535:0] rbm_data;
    input wire [1:0] wbm_addr;
    output reg [1535:0] wbm_data;
    input wire wbm;
    input wire clk;

    reg [n-1:0] n_reg_0;
    reg [n-1:0] n_reg_1;
    reg [n-1:0] n_reg_2;
    reg [n-1:0] n_reg_3;
    reg [n-1:0] n_reg_4;
    reg [n-1:0] n_reg_5;
    reg [n-1:0] n_reg_6;
    reg [n-1:0] n_reg_7;
    reg [n-1:0] n_reg_8;
    reg [n-1:0] n_reg_9;
    reg [n-1:0] n_reg_10;
    reg [n-1:0] n_reg_11;
    reg [n-1:0] n_reg_12;
    reg [n-1:0] n_reg_13;
    reg [n-1:0] n_reg_14;
    reg [n-1:0] n_reg_15;

    reg [b-1:0] b_reg_0;
    reg [b-1:0] b_reg_1;
    reg [b-1:0] b_reg_2;

    always @ (*)
        case (rd_addr_1)
            4'h0 : rd_data_1 = n_reg_0;
            4'h1 : rd_data_1 = n_reg_1;
            4'h2 : rd_data_1 = n_reg_2;
            4'h3 : rd_data_1 = n_reg_3;
            4'h4 : rd_data_1 = n_reg_4;
            4'h5 : rd_data_1 = n_reg_5;
            4'h6 : rd_data_1 = n_reg_6;
            4'h7 : rd_data_1 = n_reg_7;
            4'h8 : rd_data_1 = n_reg_8;
            4'h9 : rd_data_1 = n_reg_9;
            4'ha : rd_data_1 = n_reg_10;
            4'hb : rd_data_1 = n_reg_11;
            4'hc : rd_data_1 = n_reg_12;
            4'hd : rd_data_1 = n_reg_13;
            4'he : rd_data_1 = n_reg_14;
            default : rd_data_1 = n_reg_15;
        endcase

    always @ (*)
        case (rd_addr_2)
            4'h0 : rd_data_2 = n_reg_0;
            4'h1 : rd_data_2 = n_reg_1;
            4'h2 : rd_data_2 = n_reg_2;
            4'h3 : rd_data_2 = n_reg_3;
            4'h4 : rd_data_2 = n_reg_4;
            4'h5 : rd_data_2 = n_reg_5;
            4'h6 : rd_data_2 = n_reg_6;
            4'h7 : rd_data_2 = n_reg_7;
            4'h8 : rd_data_2 = n_reg_8;
            4'h9 : rd_data_2 = n_reg_9;
            4'ha : rd_data_2 = n_reg_10;
            4'hb : rd_data_2 = n_reg_11;
            4'hc : rd_data_2 = n_reg_12;
            4'hd : rd_data_2 = n_reg_13;
            4'he : rd_data_2 = n_reg_14;
            default : rd_data_2 = n_reg_15;
        endcase

    always @ (*)
        case (rbm_addr)
            2'h1 : rbm_data = b_reg_1;
            2'h2 : rbm_data = b_reg_2;
            default : rbm_data = b_reg_0;
        endcase

    always @ (posedge clk) begin
        if (wr) begin
            case (wr_addr) 
                4'h0 : n_reg_0 <= wr_data; 
                4'h1 : n_reg_1 <= wr_data; 
                4'h2 : n_reg_2 <= wr_data; 
                4'h3 : n_reg_3 <= wr_data; 
                4'h4 : n_reg_4 <= wr_data; 
                4'h5 : n_reg_5 <= wr_data; 
                4'h6 : n_reg_6 <= wr_data; 
                4'h7 : n_reg_7 <= wr_data; 
                4'h8 : n_reg_8 <= wr_data; 
                4'h9 : n_reg_9 <= wr_data; 
                4'ha : n_reg_10 <= wr_data; 
                4'hb : n_reg_11 <= wr_data; 
                4'hc : n_reg_12 <= wr_data; 
                4'hd : n_reg_13 <= wr_data; 
                4'he : n_reg_14 <= wr_data; 
                default : n_reg_15 <= wr_data; 
            endcase
        end

        if (wbm) begin
            case (wbm_addr)
                2'h1 : b_reg_1 <= wbm_data;
                2'h2 : b_reg_2 <= wbm_data;
                default : b_reg_0 <= wbm_data;
            endcase
        end
    end

endmodule
