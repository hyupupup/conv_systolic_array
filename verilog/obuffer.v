// 输出buffer(同步FIFO)
module obuffer
#(
parameter DATA_WIDTH=8, // 输入数据位宽8，下面其实是用的2*8;
parameter MEM_DATA_WIDTH=9,   //存入max情况，每个输出通道3*3;
parameter MEM_ADDR_WIDTH=4   //地址位宽4;
)  
(
    clk,
    rst_n,
    p0_ready,
    p1_ready,
    p2_ready,
    p0_din,
    p1_din,
    p2_din,
    empty,
    full,
    rd_en,
    data_rdout,
    errout
);

input clk,rst_n;
input p0_ready,p1_ready,p2_ready;
input [2*DATA_WIDTH-1:0] p0_din,p1_din,p2_din;
input rd_en;
output empty,full;
output [2*DATA_WIDTH-1:0] data_rdout;
output errout; //为1说明时序发生错误

// mem
reg [2*DATA_WIDTH-1:0] mem[MEM_DATA_WIDTH-1:0];

// ptr & addr
reg [MEM_ADDR_WIDTH:0] wr_ptr, rd_ptr;
wire [MEM_ADDR_WIDTH-1:0] wr_addr,rd_addr;
assign wr_addr[MEM_ADDR_WIDTH-1:0] = wr_ptr[MEM_ADDR_WIDTH-1:0];
assign rd_addr[MEM_ADDR_WIDTH-1:0] = rd_ptr[MEM_ADDR_WIDTH-1:0];

// wr_ptr
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        wr_ptr <= 'd0;
    else if(!full & (p0_ready | p1_ready | p2_ready))
    begin
        if(wr_ptr == MEM_DATA_WIDTH-1)
            wr_ptr <= {~wr_ptr[MEM_ADDR_WIDTH],4'b0000};
        else 
            wr_ptr <= wr_ptr + 1'b1;
    end
end

// rd_ptr
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        rd_ptr <= 'd0;
    else if(!empty & rd_en)
    begin
        if(rd_ptr == MEM_DATA_WIDTH-1)
            rd_ptr <= {~rd_ptr[MEM_ADDR_WIDTH],4'b0000};
        else 
            rd_ptr <= rd_ptr + 1'b1;
    end
end

// wr
reg errout;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        errout <= 1'b0;
    else if(!full & (p0_ready | p1_ready | p2_ready))
    begin
        case({p0_ready,p1_ready,p2_ready})
        3'b000:
            mem[wr_addr] <= mem[wr_addr];
        3'b100:
            mem[wr_addr] <= p0_din;
        3'b010:
            mem[wr_addr] <= p1_din;
        3'b001:
            mem[wr_addr] <= p2_din;
        default:
            errout <= 1'b1;
        endcase
    end
end

// rd
reg [2*DATA_WIDTH-1:0] data_rdout;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        data_rdout <= 'd0;
    else if(!empty & rd_en)
        data_rdout <= mem[rd_addr];
end

// empty & full
assign full = (wr_ptr=={~rd_ptr[MEM_ADDR_WIDTH],rd_ptr[MEM_ADDR_WIDTH-1:0]});
assign empty = (wr_ptr==rd_ptr);

endmodule
