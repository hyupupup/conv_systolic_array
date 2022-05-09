// �?条输入�?�线
module input_bus
#(parameter BUS_WIDTH=8) //总线位宽
(
    clk,
    rst_n,
    data,
    en,             //en应该提前�?个时钟周期有效？
    data_l0,
    data_l1,
    data_l2,
    en_l0,
    en_l1,
    en_l2
);

input clk,rst_n; 
input en;                           //总线使能(影响PE�?�?)
input [BUS_WIDTH-1:0] data;         //总线数据

output en_l0,en_l1,en_l2;                           //共三级，依次延时1个clk,分别对应不同的PE使用;
output [BUS_WIDTH-1:0] data_l0,data_l1,data_l2;     //共三级，依次延时1个clk,分别对应不同的PE使用;

reg en_l0,en_l1,en_l2;
reg [BUS_WIDTH-1:0] data_l0,data_l1,data_l2;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        en_l0 <= 1'b0;
        en_l1 <= 1'b0;
        en_l2 <= 1'b0;
        data_l0 <= 'd0;
        data_l1 <= 'd0;
        data_l2 <= 'd0;
    end
    else
    begin
        en_l0 <= en;
        en_l1 <= en_l0;
        en_l2 <= en_l1;
        data_l0 <= data;
        data_l1 <= data_l0;
        data_l2 <= data_l1;
    end
end

endmodule