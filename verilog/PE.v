// 计算单元PE (3*3)
module PE
#(parameter DATA_WIDTH=8)
(
    clk,
    rst_n,
    en_din,
    en_win,
    data_in,
    weights_in,
    data_out,
    ready
);

input clk,rst_n;
input en_din,en_win;
input [DATA_WIDTH-1:0] data_in,weights_in;
output [2*DATA_WIDTH-1:0] data_out;  //精度更高
output ready; //输出信号有效

// 
wire en;
assign en = en_din & en_win;

// cnt
reg [4:0] cnt;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt <= 'd0;
    else if(en)
    begin
        if(cnt == 27)  
            cnt <= 'd0;
        else 
            cnt <= cnt + 1'b1;
    end
    else
        cnt <= 'd0;
end

// MAC
reg [2*DATA_WIDTH-1:0] sum;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        sum <= 'd0;
    else if(en)
        begin
            if(cnt == 27)  
                sum <= 'd0; 
            else
                sum <= data_in * weights_in + sum;
        end
end

// OUTPUT
reg ready;
reg [2*DATA_WIDTH-1:0] data_out;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        ready <= 1'b0;
        data_out <= 'd0;
    end
    else if(cnt == 27)
    begin
        ready <= 1'b1;
        data_out <= sum;
    end
    else
        ready <= 1'b0;        
end

endmodule
