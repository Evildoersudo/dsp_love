module clock_1Mhz(
    input wire clk_50MHz,
    input wire rst_n,
    output reg clk_1MHz
);
    // 用 25 的分频计数器生成 1 MHz 时钟
    reg [4:0] count_50MHz;
    always @(posedge clk_50MHz or negedge rst_n) begin
        if (!rst_n) begin
            count_50MHz <= 0;
            clk_1MHz <= 0;
        end else if (count_50MHz == 24) begin
            count_50MHz <= 0;
            clk_1MHz <= ~clk_1MHz;
        end else begin
            count_50MHz <= count_50MHz + 1;
        end
    end

    // 将 1 MHz 时钟同步到 50 MHz 时钟域
    reg clk_1MHz_sync;
    always @(posedge clk_50MHz or negedge rst_n) begin
        if (!rst_n)
            clk_1MHz_sync <= 0;
        else
            clk_1MHz_sync <= clk_1MHz;
    end
endmodule
