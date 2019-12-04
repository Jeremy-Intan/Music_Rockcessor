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

    input rd_addr_1[3:0];
    output rd_data_1[15:0];
    input rd_addr_2[3:0];
    output rd_data_2[15:0];
    input wr_addr[3:0];
    input wr_data[15:0];
    input wr;
    input rbm_addr[1:0];
    output rbm_data[1535:0];
    input wbm_addr[1:0];
    output wbm_data[1535:0];
    input wbm;
    input clk;

    reg n_reg_0  [n-1:0];
    reg n_reg_1  [n-1:0];
    reg n_reg_2  [n-1:0];
    reg n_reg_3  [n-1:0];
    reg n_reg_4  [n-1:0];
    reg n_reg_5  [n-1:0];
    reg n_reg_6  [n-1:0];
    reg n_reg_7  [n-1:0];
    reg n_reg_8  [n-1:0];
    reg n_reg_9  [n-1:0];
    reg n_reg_10 [n-1:0];
    reg n_reg_11 [n-1:0];
    reg n_reg_12 [n-1:0];
    reg n_reg_13 [n-1:0];
    reg n_reg_14 [n-1:0];
    reg n_reg_15 [n-1:0];

    reg b_reg_0[b-1:0];
    reg b_reg_1[b-1:0];
    reg b_reg_2[b-1:0];

    always @ (*)
        case rd_addr_1
            4'h0 : r_data_1 = n_reg_0;
            4'h1 : r_data_1 = n_reg_1;
            4'h2 : r_data_1 = n_reg_2;
            4'h3 : r_data_1 = n_reg_3;
            4'h4 : r_data_1 = n_reg_4;
            4'h5 : r_data_1 = n_reg_5;
            4'h6 : r_data_1 = n_reg_6;
            4'h7 : r_data_1 = n_reg_7;
            4'h8 : r_data_1 = n_reg_8;
            4'h9 : r_data_1 = n_reg_9;
            4'ha : r_data_1 = n_reg_10;
            4'hb : r_data_1 = n_reg_11;
            4'hc : r_data_1 = n_reg_12;
            4'hd : r_data_1 = n_reg_13;
            4'he : r_data_1 = n_reg_14;
            default : r_data_1 = n_reg_15;
        endcase

    always @ (*)
        case rd_addr_2
            4'h0 : r_data_2 = n_reg_0;
            4'h1 : r_data_2 = n_reg_1;
            4'h2 : r_data_2 = n_reg_2;
            4'h3 : r_data_2 = n_reg_3;
            4'h4 : r_data_2 = n_reg_4;
            4'h5 : r_data_2 = n_reg_5;
            4'h6 : r_data_2 = n_reg_6;
            4'h7 : r_data_2 = n_reg_7;
            4'h8 : r_data_2 = n_reg_8;
            4'h9 : r_data_2 = n_reg_9;
            4'ha : r_data_2 = n_reg_10;
            4'hb : r_data_2 = n_reg_11;
            4'hc : r_data_2 = n_reg_12;
            4'hd : r_data_2 = n_reg_13;
            4'he : r_data_2 = n_reg_14;
            default : r_data_2 = n_reg_15;
        endcase

    always @ (*)
        case rbm_addr
            2'h1 : rbm_data = b_reg_1;
            2'h2 : rbm_data = b_reg_2;
            default : rbm_data = b_reg_0;
        endcase

    always @ (posedge clk) begin
        if (wr) begin
            case wr_addr 
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
            case wbm_addr
                2'h1 : b_reg_1 <= wbm_data;
                2'h2 : b_reg_2 <= wbm_data;
                default : b_reg_0 <= wbm_data;
            endcase
        end
    end

endmodule
