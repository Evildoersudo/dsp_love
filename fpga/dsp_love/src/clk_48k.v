module clk_48k(
    input wire clk_50m,
    input wire rst_n,
    output reg clk_out
);

reg [9:0] clk_cnt;

always@(posedge clk_50m or negedge rst_n)begin
    if(!rst_n)begin
        clk_out <= 1'b0;
        clk_cnt <=10'd0;
    end
    else if(clk_cnt>=10'd521)begin
        clk_out <= ~clk_out;
        clk_cnt <= 10'd0;
    end
    else
        clk_cnt <= clk_cnt+1'b1;
end

endmodule