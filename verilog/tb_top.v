`timescale 1ns/1ps
module tb_top;

parameter DATA_WIDTH=8;

reg clk,rst_n;
reg ifm0_en,ifm1_en,ifm2_en;
reg w0_en,w1_en,w2_en;
reg [DATA_WIDTH-1:0] ifm0,ifm1,ifm2;
reg [DATA_WIDTH-1:0] w0,w1,w2;
reg obf0_rd_en,obf1_rd_en,obf2_rd_en;

wire obf0_empty,obf1_empty,obf2_empty;
wire obf0_full,obf1_full,obf2_full;
wire obf0_err,obf1_err,obf2_err;
wire [2*DATA_WIDTH-1:0] obf0_out,obf1_out,obf2_out;

// 测试场景
//
// ifm和w的数据流控制:
// 5*5 -> 9个位置的滑窗win；
// ifm0: win1_ci1, win1_ci2, win1_ci3, win4_ci1, win4_ci2, win4_ci3,  
// ifm1:           win2_ci1, win2_ci2, win2_ci3, win5_ci1, win5_ci2,
// ifm2:                     win3_ci1, win3_ci2, win3_ci3, win6_ci1,
// w0:   w0_ci1,   w0_ci2,   w0_ci3,   w0_ci1,   w0_ci2,   w0_ci3,
// w1:             w1_ci1,   w1_ci2,   w1_ci3,   w1_ci1,   w1_ci2,  
// w2:                       w2_ci1,   w2_ci2,   w2_ci3,   w2_ci1,  
// ifm和w的使能控制:
// 开始时:和数据同步;
// 结束时:和数据同步;

//
initial
begin
    #0;
    clk=0;
    rst_n=0;
    obf0_rd_en=0;
    obf1_rd_en=0;
    obf2_rd_en=0;
    #10;
    rst_n=1;    
end

always
    #5 clk = ~clk;

integer ifm0_i;
reg [DATA_WIDTH-1:0] ifm_mem0[28*3-1:0];

initial
begin
    $readmemb("E:\\reseach\\mygit\\conv_systolic_array\\python\\ifm0.txt",ifm_mem0);

    #10;
    for(ifm0_i=0;ifm0_i<28*3;ifm0_i=ifm0_i+1)
    begin
        @(posedge clk)
        begin
            ifm0_en <= 1'b1;
            ifm0 <= ifm_mem0[ifm0_i];
        end
    end
    ifm0_en <= 1'b0;
end

//
integer ifm1_i;
reg [DATA_WIDTH-1:0] ifm_mem1[28*3-1:0];
initial
begin
    $readmemb("E:\\reseach\\mygit\\conv_systolic_array\\python\\ifm1.txt",ifm_mem1);

    #10;
    @(posedge clk); //间隔一个时钟周期;

    for(ifm1_i=0;ifm1_i<28*3;ifm1_i=ifm1_i+1)
    begin
        @(posedge clk)
        begin
            ifm1_en <= 1'b1;
            ifm1 <= ifm_mem1[ifm1_i];
        end
    end
    ifm1_en <= 1'b0;
end

//
integer ifm2_i;
reg [DATA_WIDTH-1:0] ifm_mem2[28*3-1:0];
initial
begin
    $readmemb("E:\\reseach\\mygit\\conv_systolic_array\\python\\ifm2.txt",ifm_mem2);

    #10;
    @(posedge clk);
    @(posedge clk);  //间隔两个时钟周期;


    for(ifm2_i=0;ifm2_i<28*3;ifm2_i=ifm2_i+1)
    begin
        @(posedge clk)
        begin
            ifm2_en <= 1'b1;
            ifm2 <= ifm_mem2[ifm2_i];
        end
    end
    ifm2_en <= 1'b0;
end

//
integer w0_i,w0_j;
reg [DATA_WIDTH-1:0] w_mem0[28-1:0];
initial
begin
    $readmemb("E:\\reseach\\mygit\\conv_systolic_array\\python\\w_0.txt",w_mem0);
    
    #10;
    for(w0_i=0;w0_i<3;w0_i=w0_i+1)
    begin
        for(w0_j=0;w0_j<28;w0_j=w0_j+1)
        begin
            @(posedge clk)
            begin
                w0_en <= 1'b1;
                w0 <= w_mem0[w0_j];
            end
        end
    end
    w0_en <= 1'b0;
end

//
integer w1_i,w1_j;
reg [DATA_WIDTH-1:0] w_mem1[28-1:0];
initial
begin
    $readmemb("E:\\reseach\\mygit\\conv_systolic_array\\python\\w_1.txt",w_mem1);

    #10;
    @(posedge clk); //间隔一个时钟周期;

    for(w1_i=0;w1_i<3;w1_i=w1_i+1)
    begin
        for(w1_j=0;w1_j<28;w1_j=w1_j+1)
        begin
            @(posedge clk)
            begin
                w1_en <= 1'b1;
                w1 <= w_mem1[w1_j];
            end
        end
    end
    w1_en <= 1'b0;
end

integer w2_i,w2_j;
reg [DATA_WIDTH-1:0] w_mem2[28-1:0];
initial
begin
    $readmemb("E:\\reseach\\mygit\\conv_systolic_array\\python\\w_2.txt",w_mem2);

    #10;
    @(posedge clk);
    @(posedge clk); //间隔两个时钟周期;

    for(w2_i=0;w2_i<3;w2_i=w2_i+1)
    begin
        for(w2_j=0;w2_j<28;w2_j=w2_j+1)
        begin
            @(posedge clk)
            begin
                w2_en <= 1'b1;
                w2 <= w_mem2[w2_j];
            end
        end
    end
    w2_en <= 1'b0;
end


initial
begin
    #950;
    obf0_rd_en=1;
    obf1_rd_en=1;
    obf2_rd_en=1;
end

top mytop(
    .clk(clk),
    .rst_n(rst_n),

    .ifm0(ifm0),
    .ifm1(ifm1),
    .ifm2(ifm2),
    .ifm0_en(ifm0_en),
    .ifm1_en(ifm1_en),
    .ifm2_en(ifm2_en),

    .w0(w0),
    .w1(w1),
    .w2(w2),
    .w0_en(w0_en),
    .w1_en(w1_en),
    .w2_en(w2_en),

    .obf0_rd_en(obf0_rd_en),
    .obf1_rd_en(obf1_rd_en),
    .obf2_rd_en(obf2_rd_en),
    .obf0_empty(obf0_empty),
    .obf1_empty(obf1_empty),
    .obf2_empty(obf2_empty),
    .obf0_full(obf0_full),
    .obf1_full(obf1_full),
    .obf2_full(obf2_full),
    .obf0_err(obf0_err),
    .obf1_err(obf1_err),
    .obf2_err(obf2_err),
    .obf0_out(obf0_out),
    .obf1_out(obf1_out),
    .obf2_out(obf2_out)
);

endmodule