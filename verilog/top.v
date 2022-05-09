// 顶层
module top(
    clk,
    rst_n,

    ifm0,
    ifm1,
    ifm2,
    ifm0_en,
    ifm1_en,
    ifm2_en,

    w0,
    w1,
    w2,
    w0_en,
    w1_en,
    w2_en,

    obf0_rd_en,
    obf1_rd_en,
    obf2_rd_en,
    obf0_empty,
    obf1_empty,
    obf2_empty,
    obf0_full,
    obf1_full,
    obf2_full,
    obf0_err,
    obf1_err,
    obf2_err,
    obf0_out,
    obf1_out,
    obf2_out
);


parameter DATA_WIDTH=8;

input clk,rst_n;
input ifm0_en,ifm1_en,ifm2_en;
input w0_en,w1_en,w2_en;
input [DATA_WIDTH-1:0] ifm0,ifm1,ifm2;
input [DATA_WIDTH-1:0] w0,w1,w2;

input obf0_rd_en,obf1_rd_en,obf2_rd_en;
output obf0_empty,obf1_empty,obf2_empty;
output obf0_full,obf1_full,obf2_full;
output obf0_err,obf1_err,obf2_err;
output [2*DATA_WIDTH-1:0] obf0_out,obf1_out,obf2_out;

// 6条bus
wire [DATA_WIDTH-1:0] ifm0_l0,ifm0_l1,ifm0_l2;
wire ifm0_en0,ifm0_en1,ifm0_en2;
input_bus ifm_bus0(
    .clk(clk),
    .rst_n(rst_n),
    .data(ifm0),
    .en(ifm0_en),             
    .data_l0(ifm0_l0),
    .data_l1(ifm0_l1),
    .data_l2(ifm0_l2),
    .en_l0(ifm0_en0),
    .en_l1(ifm0_en1),
    .en_l2(ifm0_en2)
);

wire [DATA_WIDTH-1:0] ifm1_l0,ifm1_l1,ifm1_l2;
wire ifm1_en0,ifm1_en1,ifm1_en2;
input_bus ifm_bus1(
    .clk(clk),
    .rst_n(rst_n),
    .data(ifm1),
    .en(ifm1_en),             
    .data_l0(ifm1_l0),
    .data_l1(ifm1_l1),
    .data_l2(ifm1_l2),
    .en_l0(ifm1_en0),
    .en_l1(ifm1_en1),
    .en_l2(ifm1_en2)
);

wire [DATA_WIDTH-1:0] ifm2_l0,ifm2_l1,ifm2_l2;
wire ifm2_en0,ifm2_en1,ifm2_en2;
input_bus ifm_bus2(
    .clk(clk),
    .rst_n(rst_n),
    .data(ifm2),
    .en(ifm2_en),             
    .data_l0(ifm2_l0),
    .data_l1(ifm2_l1),
    .data_l2(ifm2_l2),
    .en_l0(ifm2_en0),
    .en_l1(ifm2_en1),
    .en_l2(ifm2_en2)
);

wire [DATA_WIDTH-1:0] w0_l0,w0_l1,w0_l2;
wire w0_en0,w0_en1,w0_en2;
input_bus w_bus0(
    .clk(clk),
    .rst_n(rst_n),
    .data(w0),
    .en(w0_en),             
    .data_l0(w0_l0),
    .data_l1(w0_l1),
    .data_l2(w0_l2),
    .en_l0(w0_en0),
    .en_l1(w0_en1),
    .en_l2(w0_en2)
);

wire [DATA_WIDTH-1:0] w1_l0,w1_l1,w1_l2;
wire w1_en0,w1_en1,w1_en2;
input_bus w_bus1(
    .clk(clk),
    .rst_n(rst_n),
    .data(w1),
    .en(w1_en),             
    .data_l0(w1_l0),
    .data_l1(w1_l1),
    .data_l2(w1_l2),
    .en_l0(w1_en0),
    .en_l1(w1_en1),
    .en_l2(w1_en2)
);

wire [DATA_WIDTH-1:0] w2_l0,w2_l1,w2_l2;
wire w2_en0,w2_en1,w2_en2;
input_bus w_bus2(
    .clk(clk),
    .rst_n(rst_n),
    .data(w2),
    .en(w2_en),             
    .data_l0(w2_l0),
    .data_l1(w2_l1),
    .data_l2(w2_l2),
    .en_l0(w2_en0),
    .en_l1(w2_en1),
    .en_l2(w2_en2)
);

// 9个PE
wire [2*DATA_WIDTH-1:0] pe00_out,pe01_out,pe02_out,pe10_out,pe11_out,pe12_out,pe20_out,pe21_out,pe22_out;
wire pe00_rdy,pe01_rdy,pe02_rdy,pe10_rdy,pe11_rdy,pe12_rdy,pe20_rdy,pe21_rdy,pe22_rdy;
PE pe00(
    .clk(clk),
    .rst_n(rst_n),
    .en_din(ifm0_en0),
    .en_win(w0_en0),
    .data_in(ifm0_l0),
    .weights_in(w0_l0),
    .data_out(pe00_out),
    .ready(pe00_rdy)
);

PE pe01(
    .clk(clk),
    .rst_n(rst_n),
    .en_din(ifm0_en1),
    .en_win(w1_en0),
    .data_in(ifm0_l1),
    .weights_in(w1_l0),
    .data_out(pe01_out),
    .ready(pe01_rdy)
);

PE pe02(
    .clk(clk),
    .rst_n(rst_n),
    .en_din(ifm0_en2),
    .en_win(w2_en0),
    .data_in(ifm0_l2),
    .weights_in(w2_l0),
    .data_out(pe02_out),
    .ready(pe02_rdy)
);

PE pe10(
    .clk(clk),
    .rst_n(rst_n),
    .en_din(ifm1_en0),
    .en_win(w0_en1),
    .data_in(ifm1_l0),
    .weights_in(w0_l1),
    .data_out(pe10_out),
    .ready(pe10_rdy)
);

PE pe11(
    .clk(clk),
    .rst_n(rst_n),
    .en_din(ifm1_en1),
    .en_win(w1_en1),
    .data_in(ifm1_l1),
    .weights_in(w1_l1),
    .data_out(pe11_out),
    .ready(pe11_rdy)
);

PE pe12(
    .clk(clk),
    .rst_n(rst_n),
    .en_din(ifm1_en2),
    .en_win(w2_en1),
    .data_in(ifm1_l2),
    .weights_in(w2_l1),
    .data_out(pe12_out),
    .ready(pe12_rdy)
);

PE pe20(
    .clk(clk),
    .rst_n(rst_n),
    .en_din(ifm2_en0),
    .en_win(w0_en2),
    .data_in(ifm2_l0),
    .weights_in(w0_l2),
    .data_out(pe20_out),
    .ready(pe20_rdy)
);

PE pe21(
    .clk(clk),
    .rst_n(rst_n),
    .en_din(ifm2_en1),
    .en_win(w1_en2),
    .data_in(ifm2_l1),
    .weights_in(w1_l2),
    .data_out(pe21_out),
    .ready(pe21_rdy)
);

PE pe22(
    .clk(clk),
    .rst_n(rst_n),
    .en_din(ifm2_en2),
    .en_win(w2_en2),
    .data_in(ifm2_l2),
    .weights_in(w2_l2),
    .data_out(pe22_out),
    .ready(pe22_rdy)
);

// 3个输出buffer
obuffer obf0(
    .clk(clk),
    .rst_n(rst_n),
    .p0_ready(pe00_rdy),
    .p1_ready(pe10_rdy),
    .p2_ready(pe20_rdy),
    .p0_din(pe00_out),
    .p1_din(pe10_out),
    .p2_din(pe20_out),
    .empty(obf0_empty),
    .full(obf0_full),
    .rd_en(obf0_rd_en),
    .data_rdout(obf0_out),
    .errout(obf0_err)
);

obuffer obf1(
    .clk(clk),
    .rst_n(rst_n),
    .p0_ready(pe01_rdy),
    .p1_ready(pe11_rdy),
    .p2_ready(pe21_rdy),
    .p0_din(pe01_out),
    .p1_din(pe11_out),
    .p2_din(pe21_out),
    .empty(obf1_empty),
    .full(obf1_full),
    .rd_en(obf1_rd_en),
    .data_rdout(obf1_out),
    .errout(obf1_err)
);

obuffer obf2(
    .clk(clk),
    .rst_n(rst_n),
    .p0_ready(pe02_rdy),
    .p1_ready(pe12_rdy),
    .p2_ready(pe22_rdy),
    .p0_din(pe02_out),
    .p1_din(pe12_out),
    .p2_din(pe22_out),
    .empty(obf2_empty),
    .full(obf2_full),
    .rd_en(obf2_rd_en),
    .data_rdout(obf2_out),
    .errout(obf2_err)
);

endmodule